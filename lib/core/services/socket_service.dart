import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;
import 'package:get/get.dart';



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

      log("✅ WebSocket connected");
      isConnected.value = true;
      isConnecting.value = false;
      _reconnectAttempts = 0; // Reset reconnect attempts on successful connection

      // Start ping timer to keep connection alive
      _startPingTimer();

      // Listen to socket events
      _socket?.listen(
            (message) {
          log("📨 Received: $message");
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

      rethrow; // Rethrow to let caller handle the error
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

  @override
  void onClose() {
    disconnect();
    super.onClose();
  }
}
