import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;
import 'package:get/get.dart';







/*class WebSocketClientService extends GetxService {
  final RxBool isConnected = false.obs;
  final RxBool isConnecting = false.obs;

  WebSocket? _socket;
  Timer? _reconnectTimer;
  Timer? _pingTimer;
  String? _socketUrl;
  String? _authToken;
  bool _isReconnecting = false;
  bool _isManualDisconnect = false;
  int _reconnectAttempts = 0;
  static const int _maxReconnectAttempts = 5;
  static const int _connectionTimeout = 10; // seconds

  Function(String)? onMessageRecived;
  Function(Map<String, dynamic>)? onContributionRequest;
  Function(Map<String, dynamic>)? onCoHostJoined;
  Function(Map<String, dynamic>)? onCoHostLeft;
  Function(Map<String, dynamic>)? onHostTransferred;

  static WebSocketClientService get to => Get.find();

  Future<void> connect(String socketUrl, String authToken) async {
    // Prevent multiple simultaneous connection attempts
    if (isConnecting.value) {
      log("⚠️ Connection already in progress");
      return;
    }

    _socketUrl = socketUrl;
    _authToken = authToken;
    _isManualDisconnect = false;
    isConnecting.value = true;

    try {
      // Close existing connection
      await _socket?.close();
      _reconnectTimer?.cancel();
      _pingTimer?.cancel();

      log("🔌 Connecting to $socketUrl");

      // Create connection with timeout
      _socket = await WebSocket.connect(
        socketUrl,
        headers: {'x-token': authToken},
      ).timeout(
        Duration(seconds: _connectionTimeout),
        onTimeout: () {
          throw TimeoutException('Connection timeout after $_connectionTimeout seconds');
        },
      );

      log("✅ WebSocket connected successfully");
      isConnected.value = true;
      isConnecting.value = false;
      _reconnectAttempts = 0; // Reset reconnect attempts on successful connection

      // Start ping timer to keep connection alive
      _startPingTimer();

      // Listen to socket events
      _socket?.listen(
            (message) {
          log("📨 Received: $message");
          _handleIncomingMessage(message);
          onMessageRecived?.call(message);
        },
        onDone: () {
          isConnected.value = false;
          isConnecting.value = false;
          log("🔌 Socket closed");
          _pingTimer?.cancel();
          if (!_isManualDisconnect) _handleDisconnect();
        },
        onError: (e) {
          isConnected.value = false;
          isConnecting.value = false;
          log("❌ Socket error: $e");
          _pingTimer?.cancel();
          if (!_isManualDisconnect) _handleDisconnect();
        },
        cancelOnError: false,
      );
    } catch (e) {
      isConnected.value = false;
      isConnecting.value = false;
      log("❌ Connection error: $e");

      if (!_isManualDisconnect) {
        _handleDisconnect();
      }

      rethrow;
    }
  }

  // Handle incoming WebSocket messages with all event types
  void _handleIncomingMessage(String message) {
    try {
      final decoded = jsonDecode(message);
      final messageType = decoded['type'];

      log("🎯 Processing message type: $messageType");

      switch (messageType) {
        case 'contribution-request':
          log("🎯 Received contribution request");
          onContributionRequest?.call(decoded);
          break;

        case 'cohost-joined':
          log("✅ Co-host joined notification");
          onCoHostJoined?.call(decoded);
          break;

        case 'cohost-left':
          log("❌ Co-host left notification");
          onCoHostLeft?.call(decoded);
          break;

        case 'host-transferred':
          log("🔄 Host transferred notification");
          onHostTransferred?.call(decoded);
          break;

        case 'accept-contribution':
          log("✅ Contribution accepted");
          // Handle contribution acceptance
          break;

        case 'reject-contribution':
          log("❌ Contribution rejected");
          // Handle contribution rejection
          break;

        case 'pong':
          log("🏓 Pong received");
          break;

        default:
          log("📨 Unknown message type: $messageType");
      }
    } catch (e) {
      log("❌ Error processing incoming message: $e");
    }
  }

  void _startPingTimer() {
    _pingTimer?.cancel();
    _pingTimer = Timer.periodic(Duration(seconds: 30), (timer) {
      if (isConnected.value) {
        try {
          sendMessage({'type': 'ping'});
        } catch (e) {
          log("❌ Ping failed: $e");
        }
      } else {
        timer.cancel();
      }
    });
  }

  void _handleDisconnect() {
    if (_isReconnecting) return;
    if (_reconnectAttempts >= _maxReconnectAttempts) {
      log("❌ Max reconnection attempts reached");
      return;
    }

    _isReconnecting = true;
    _reconnectAttempts++;

    final delay = Duration(seconds: math.min(math.pow(2, _reconnectAttempts).toInt(), 30));
    log("🔄 Reconnecting in ${delay.inSeconds}s (attempt $_reconnectAttempts/$_maxReconnectAttempts)...");

    _reconnectTimer = Timer(delay, () {
      _isReconnecting = false;
      if (_socketUrl != null &&
          _authToken != null &&
          !_isManualDisconnect) {
        connect(_socketUrl!, _authToken!).catchError((e) {
          log("❌ Reconnection failed: $e");
        });
      }
    });
  }

  void sendMessage(Map<String, dynamic> message) {
    if (!isConnected.value) {
      log("❌ Cannot send: WebSocket not connected");
      throw WebSocketException("WebSocket is not connected");
    }

    try {
      final jsonMessage = jsonEncode(message);
      _socket?.add(jsonMessage);
      log("📤 Sent: $jsonMessage");
    } catch (e) {
      log("❌ Send error: $e");
      rethrow;
    }
  }

  void disconnect() {
    _isManualDisconnect = true;
    _reconnectAttempts = 0;
    _reconnectTimer?.cancel();
    _pingTimer?.cancel();
    _socket?.close();
    _socket = null;
    isConnected.value = false;
    isConnecting.value = false;
    log("🔌 Disconnected manually");
  }

  void setOnMessageReceived(Function(String) callback) {
    onMessageRecived = callback;
  }

  void setOnContributionRequest(Function(Map<String, dynamic>) callback) {
    onContributionRequest = callback;
  }

  void setOnCoHostJoined(Function(Map<String, dynamic>) callback) {
    onCoHostJoined = callback;
  }

  void setOnCoHostLeft(Function(Map<String, dynamic>) callback) {
    onCoHostLeft = callback;
  }

  void setOnHostTransferred(Function(Map<String, dynamic>) callback) {
    onHostTransferred = callback;
  }

  /// Notify co-host joined
  void notifyCoHostJoined(String streamId, String coHostId, String coHostName) {
    sendMessage({
      "type": "cohost-joined",
      "streamId": streamId,
      "coHostId": coHostId,
      "coHostName": coHostName,
    });
  }

  /// Notify co-host left
  void notifyCoHostLeft(String streamId, String coHostId) {
    sendMessage({
      "type": "cohost-left",
      "streamId": streamId,
      "coHostId": coHostId,
    });
  }

  /// Notify host transferred
  void notifyHostTransferred(String streamId, String oldHostId, String newHostId) {
    sendMessage({
      "type": "host-transferred",
      "streamId": streamId,
      "oldHostId": oldHostId,
      "newHostId": newHostId,
    });
  }

  @override
  void onClose() {
    disconnect();
    super.onClose();
  }
}*/
class WebSocketClientService extends GetxService {
  final RxBool isConnected = false.obs;
  final RxBool isConnecting = false.obs;

  WebSocket? _socket;
  Timer? _reconnectTimer;
  Timer? _pingTimer;
  String? _socketUrl;
  String? _authToken;
  bool _isReconnecting = false;
  bool _isManualDisconnect = false;
  int _reconnectAttempts = 0;
  static const int _maxReconnectAttempts = 5;
  static const int _connectionTimeout = 10; // seconds

  Function(String)? onMessageRecived;
  Function(Map<String, dynamic>)? onContributionRequest;
  Function(Map<String, dynamic>)? onCoHostJoined;
  Function(Map<String, dynamic>)? onCoHostLeft;
  Function(Map<String, dynamic>)? onHostTransferred;
  // NEW: Bad word warning and ban handlers
  Function(Map<String, dynamic>)? onBadWordWarning;
  Function(Map<String, dynamic>)? onUserBanned;

  static WebSocketClientService get to => Get.find();

  Future<void> connect(String socketUrl, String authToken) async {
    // Prevent multiple simultaneous connection attempts
    if (isConnecting.value) {
      log("⚠️ Connection already in progress");
      return;
    }

    _socketUrl = socketUrl;
    _authToken = authToken;
    _isManualDisconnect = false;
    isConnecting.value = true;

    try {
      // Close existing connection
      await _socket?.close();
      _reconnectTimer?.cancel();
      _pingTimer?.cancel();

      log("🔌 Connecting to $socketUrl");

      // Create connection with timeout
      _socket = await WebSocket.connect(
        socketUrl,
        headers: {'x-token': authToken},
      ).timeout(
        Duration(seconds: _connectionTimeout),
        onTimeout: () {
          throw TimeoutException('Connection timeout after $_connectionTimeout seconds');
        },
      );

      log("✅ WebSocket connected successfully");
      isConnected.value = true;
      isConnecting.value = false;
      _reconnectAttempts = 0; // Reset reconnect attempts on successful connection

      // Start ping timer to keep connection alive
      _startPingTimer();

      // Listen to socket events
      _socket?.listen(
            (message) {
          log("📨 Received: $message");
          _handleIncomingMessage(message);
          onMessageRecived?.call(message);
        },
        onDone: () {
          isConnected.value = false;
          isConnecting.value = false;
          log("🔌 Socket closed");
          _pingTimer?.cancel();
          if (!_isManualDisconnect) _handleDisconnect();
        },
        onError: (e) {
          isConnected.value = false;
          isConnecting.value = false;
          log("❌ Socket error: $e");
          _pingTimer?.cancel();
          if (!_isManualDisconnect) _handleDisconnect();
        },
        cancelOnError: false,
      );
    } catch (e) {
      isConnected.value = false;
      isConnecting.value = false;
      log("❌ Connection error: $e");

      if (!_isManualDisconnect) {
        _handleDisconnect();
      }

      rethrow;
    }
  }

  // Handle incoming WebSocket messages with all event types
  void _handleIncomingMessage(String message) {
    try {
      final decoded = jsonDecode(message);
      final messageType = decoded['type'];

      log("🎯 Processing message type: $messageType");

      switch (messageType) {
        case 'contribution-request':
          log("🎯 Received contribution request");
          onContributionRequest?.call(decoded);
          break;

        case 'cohost-joined':
          log("✅ Co-host joined notification");
          onCoHostJoined?.call(decoded);
          break;

        case 'cohost-left':
          log("❌ Co-host left notification");
          onCoHostLeft?.call(decoded);
          break;

        case 'host-transferred':
          log("🔄 Host transferred notification");
          onHostTransferred?.call(decoded);
          break;

        case 'accept-contribution':
          log("✅ Contribution accepted");
          // Handle contribution acceptance
          break;

        case 'reject-contribution':
          log("❌ Contribution rejected");
          // Handle contribution rejection
          break;

        case 'bad-word-warning':
          log("⚠️ Bad word warning received");
          onBadWordWarning?.call(decoded);
          break;

        case 'banned':
          log("🚫 User banned notification");
          onUserBanned?.call(decoded);
          break;

        case 'pong':
          log("🏓 Pong received");
          break;

        case 'error':
          log("❌ Server error: ${decoded['message']}");
          // Handle generic errors
          break;

        default:
          log("📨 Unknown message type: $messageType");
      }
    } catch (e) {
      log("❌ Error processing incoming message: $e");
    }
  }

  void _startPingTimer() {
    _pingTimer?.cancel();
    _pingTimer = Timer.periodic(Duration(seconds: 30), (timer) {
      if (isConnected.value) {
        try {
          sendMessage({'type': 'ping'});
        } catch (e) {
          log("❌ Ping failed: $e");
        }
      } else {
        timer.cancel();
      }
    });
  }

  void _handleDisconnect() {
    if (_isReconnecting) return;
    if (_reconnectAttempts >= _maxReconnectAttempts) {
      log("❌ Max reconnection attempts reached");
      return;
    }

    _isReconnecting = true;
    _reconnectAttempts++;

    final delay = Duration(seconds: math.min(math.pow(2, _reconnectAttempts).toInt(), 30));
    log("🔄 Reconnecting in ${delay.inSeconds}s (attempt $_reconnectAttempts/$_maxReconnectAttempts)...");

    _reconnectTimer = Timer(delay, () {
      _isReconnecting = false;
      if (_socketUrl != null &&
          _authToken != null &&
          !_isManualDisconnect) {
        connect(_socketUrl!, _authToken!).catchError((e) {
          log("❌ Reconnection failed: $e");
        });
      }
    });
  }

  void sendMessage(Map<String, dynamic> message) {
    if (!isConnected.value) {
      log("❌ Cannot send: WebSocket not connected");
      throw WebSocketException("WebSocket is not connected");
    }

    try {
      final jsonMessage = jsonEncode(message);
      _socket?.add(jsonMessage);
      log("📤 Sent: $jsonMessage");
    } catch (e) {
      log("❌ Send error: $e");
      rethrow;
    }
  }

  void disconnect() {
    _isManualDisconnect = true;
    _reconnectAttempts = 0;
    _reconnectTimer?.cancel();
    _pingTimer?.cancel();
    _socket?.close();
    _socket = null;
    isConnected.value = false;
    isConnecting.value = false;
    log("🔌 Disconnected manually");
  }

  void setOnMessageReceived(Function(String) callback) {
    onMessageRecived = callback;
  }

  void setOnContributionRequest(Function(Map<String, dynamic>) callback) {
    onContributionRequest = callback;
  }

  void setOnCoHostJoined(Function(Map<String, dynamic>) callback) {
    onCoHostJoined = callback;
  }

  void setOnCoHostLeft(Function(Map<String, dynamic>) callback) {
    onCoHostLeft = callback;
  }

  void setOnHostTransferred(Function(Map<String, dynamic>) callback) {
    onHostTransferred = callback;
  }

  // NEW: Set bad word warning callback
  void setOnBadWordWarning(Function(Map<String, dynamic>) callback) {
    onBadWordWarning = callback;
  }

  // NEW: Set banned callback
  void setOnUserBanned(Function(Map<String, dynamic>) callback) {
    onUserBanned = callback;
  }

  /// Notify co-host joined
  void notifyCoHostJoined(String streamId, String coHostId, String coHostName) {
    sendMessage({
      "type": "cohost-joined",
      "streamId": streamId,
      "coHostId": coHostId,
      "coHostName": coHostName,
    });
  }

  /// Notify co-host left
  void notifyCoHostLeft(String streamId, String coHostId) {
    sendMessage({
      "type": "cohost-left",
      "streamId": streamId,
      "coHostId": coHostId,
    });
  }

  /// Notify host transferred
  void notifyHostTransferred(String streamId, String oldHostId, String newHostId) {
    sendMessage({
      "type": "host-transferred",
      "streamId": streamId,
      "oldHostId": oldHostId,
      "newHostId": newHostId,
    });
  }

  @override
  void onClose() {
    disconnect();
    super.onClose();
  }
}