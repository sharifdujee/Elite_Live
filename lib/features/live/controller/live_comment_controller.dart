// lib/features/live/controller/live_comment_controller.dart

// lib/features/live/controller/live_comment_controller.dart
// FIXED: Handles both single comments and comment arrays

import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:elites_live/core/services/socket_service.dart';
import 'package:elites_live/core/helper/shared_prefarenses_helper.dart';
import 'package:elites_live/core/global_widget/custom_snackbar.dart';
import '../data/live_comment_data_model.dart';

/*
class LiveCommentController extends GetxController {
  final WebSocketClientService webSocketService = WebSocketClientService.to;
  final SharedPreferencesHelper helper = SharedPreferencesHelper();

  // Observable comment list
  final RxList<LiveComment> comments = <LiveComment>[].obs;
  final RxBool isJoined = false.obs;
  final RxBool isSending = false.obs;
  final RxBool isConnecting = false.obs;
  final RxString connectionError = ''.obs;

  // Stream info
  String? eventId;
  String? streamId;
  bool isFromEvent = false;

  @override
  void onInit() {
    super.onInit();
    _setupMessageListener();
  }

  /// Initialize for Event-based live streaming
  Future<void> initializeForEvent(String eventIdParam) async {
    eventId = eventIdParam;
    streamId = null;
    isFromEvent = true;

    log("📺 Initializing comment system for Event: $eventId");

    try {
      await _ensureWebSocketConnected();
      await _joinStream();
    } catch (e) {
      log("❌ Failed to initialize for event: $e");
      connectionError.value = "Failed to connect to chat server";
    }
  }

  /// Initialize for Free live streaming
  Future<void> initializeForFreeLive(String streamIdParam) async {
    streamId = streamIdParam;
    eventId = null;
    isFromEvent = false;

    log("📺 Initializing comment system for Free Live: $streamId");

    try {
      await _ensureWebSocketConnected();
      await _joinStream();
    } catch (e) {
      log("❌ Failed to initialize for free live: $e");
      connectionError.value = "Failed to connect to chat server";
    }
  }

  /// Ensure WebSocket is connected
  Future<void> _ensureWebSocketConnected() async {
    if (webSocketService.isConnected.value) {
      log("✅ WebSocket already connected");
      return;
    }

    if (webSocketService.isConnecting.value) {
      log("⏳ WebSocket connection already in progress, waiting...");
      int attempts = 0;
      const maxAttempts = 20;

      while (attempts < maxAttempts &&
          webSocketService.isConnecting.value &&
          !webSocketService.isConnected.value) {
        await Future.delayed(Duration(milliseconds: 500));
        attempts++;
      }

      if (webSocketService.isConnected.value) {
        log("✅ WebSocket connected (waited for existing connection)");
        return;
      }

      if (attempts >= maxAttempts) {
        throw Exception("Timeout waiting for existing connection");
      }
    }

    isConnecting.value = true;
    log("🔌 Connecting to WebSocket...");

    final authToken = helper.getString('userToken');
    if (authToken == null || authToken.isEmpty) {
      isConnecting.value = false;
      log("❌ No auth token available");
      throw Exception("Authentication token not found");
    }

    const socketUrl = "wss://api.morgan.smtsigma.com";

    try {
      await webSocketService.connect(socketUrl, authToken);

      int attempts = 0;
      const maxAttempts = 20;

      while (attempts < maxAttempts && !webSocketService.isConnected.value) {
        await Future.delayed(Duration(milliseconds: 500));
        attempts++;
      }

      if (!webSocketService.isConnected.value) {
        throw Exception("WebSocket connection timeout");
      }

      isConnecting.value = false;
      connectionError.value = '';
      log("✅ WebSocket connected successfully");
    } catch (e) {
      isConnecting.value = false;
      connectionError.value = e.toString();
      log("❌ WebSocket connection error: $e");
      rethrow;
    }
  }

  /// Setup message listener for incoming comments
  void _setupMessageListener() {
    webSocketService.setOnMessageReceived((message) {
      try {
        final data = jsonDecode(message);
        log("📨 Received message: $data");

        final messageType = data['type'] as String?;

        if (messageType == 'chat-streaming-comment' ||
            messageType == 'chat-streaming-free-comment' ||
            messageType == 'new-comment') {
          _handleNewComment(data);
        } else if (messageType == 'comment-history') {
          _handleCommentHistory(data);
        } else if (messageType == 'join-success') {
          log("✅ Successfully joined streaming room");
        } else if (messageType == 'error') {
          log("❌ Server error: ${data['message']}");
        }
      } catch (e) {
        log("❌ Error parsing message: $e");
      }
    });
  }

  /// ✅ FIXED: Handle both single comment and comment arrays
  void _handleNewComment(Map<String, dynamic> data) {
    try {
      log("🔍 Parsing comment from data: $data");

      final messageData = data['message'] ?? data;

      // ✅ Check if this message contains an EventComment array
      if (messageData['EventComment'] != null && messageData['EventComment'] is List) {
        log("📚 Detected EventComment array with ${(messageData['EventComment'] as List).length} comments");
        _handleCommentArray(messageData['EventComment'] as List);
        return;
      }

      // ✅ Otherwise, handle as single comment
      final comment = LiveComment.fromJson(data);

      log("✅ Parsed single comment: ${comment.userName} - ${comment.comment}");

      // Add to top of list (newest first)
      comments.insert(0, comment);

      // Keep only last 100 comments
      if (comments.length > 100) {
        comments.removeRange(100, comments.length);
      }

      log("💬 Comment added to list. Total comments: ${comments.length}");
    } catch (e, stackTrace) {
      log("❌ Error handling new comment: $e");
      log("Stack trace: $stackTrace");
      log("Data that failed to parse: $data");
    }
  }

  /// ✅ NEW: Handle array of comments (for event streams)
  void _handleCommentArray(List commentArray) {
    try {
      log("📥 Processing ${commentArray.length} comments from array");

      // Parse all comments from array
      final List<LiveComment> parsedComments = [];

      for (var commentData in commentArray) {
        try {
          final comment = LiveComment.fromJson(commentData);
          parsedComments.add(comment);
          log("✅ Parsed: ${comment.userName} - ${comment.comment}");
        } catch (e) {
          log("❌ Failed to parse comment: $e");
          log("Comment data: $commentData");
        }
      }

      if (parsedComments.isEmpty) {
        log("⚠️ No comments were successfully parsed");
        return;
      }

      // Sort by timestamp (newest first)
      parsedComments.sort((a, b) => b.timestamp.compareTo(a.timestamp));

      // Replace current comments with new array
      comments.value = parsedComments;

      log("✅ Loaded ${parsedComments.length} comments from array");
      log("💬 Total comments in list: ${comments.length}");
    } catch (e, stackTrace) {
      log("❌ Error handling comment array: $e");
      log("Stack trace: $stackTrace");
    }
  }

  /// Handle comment history
  void _handleCommentHistory(Map<String, dynamic> data) {
    try {
      final List<dynamic> history = data['comments'] ?? [];
      final List<LiveComment> loadedComments = history
          .map((item) => LiveComment.fromJson(item))
          .toList();

      comments.value = loadedComments;
      log("📜 Loaded ${loadedComments.length} comments from history");
    } catch (e) {
      log("❌ Error handling comment history: $e");
    }
  }

  /// Join the streaming room
  Future<void> _joinStream() async {
    if (!webSocketService.isConnected.value) {
      log("❌ Cannot join: WebSocket not connected");
      throw Exception("WebSocket not connected");
    }

    try {
      final request = isFromEvent
          ? JoinStreamingRequest(
        type: WebSocketMessageType.joinStreaming,
        eventId: eventId,
      )
          : JoinStreamingRequest(
        type: WebSocketMessageType.joinStreamingFree,
        streamId: streamId,
      );

      webSocketService.sendMessage(request.toJson());
      isJoined.value = true;

      log("✅ Joined streaming room: ${isFromEvent ? 'Event $eventId' : 'Stream $streamId'}");
    } catch (e) {
      log("❌ Error joining stream: $e");
      rethrow;
    }
  }

  /// Send a comment
  Future<void> sendComment(String commentText) async {
    if (commentText.trim().isEmpty) {
      log("⚠️ Cannot send empty comment");
      return;
    }

    if (!webSocketService.isConnected.value) {
      log("❌ Cannot send: WebSocket not connected");
      CustomSnackBar.error(
        title: "Connection Error",
        message: "Not connected to chat server. Please try again.",
      );
      throw Exception("Not connected to server");
    }

    if (!isJoined.value) {
      log("❌ Cannot send: Not joined to stream");
      CustomSnackBar.error(
        title: "Error",
        message: "Not joined to chat room. Please refresh.",
      );
      throw Exception("Not joined to stream");
    }

    isSending.value = true;

    try {
      final request = isFromEvent
          ? ChatStreamingRequest(
        type: WebSocketMessageType.chatStreaming,
        eventId: eventId,
        comment: commentText,
      )
          : ChatStreamingRequest(
        type: WebSocketMessageType.chatStreamingFree,
        streamId: streamId,
        comment: commentText,
      );

      webSocketService.sendMessage(request.toJson());

      log("💬 Comment sent: $commentText");
    } catch (e) {
      log("❌ Error sending comment: $e");
      CustomSnackBar.error(
        title: "Send Failed",
        message: "Failed to send comment. Please try again.",
      );
      rethrow;
    } finally {
      isSending.value = false;
    }
  }

  /// Retry connection
  Future<void> retryConnection() async {
    connectionError.value = '';

    try {
      if (isFromEvent && eventId != null) {
        await initializeForEvent(eventId!);
      } else if (!isFromEvent && streamId != null) {
        await initializeForFreeLive(streamId!);
      }
    } catch (e) {
      log("❌ Retry failed: $e");
    }
  }

  /// Leave the streaming room
  Future<void> leaveStream() async {
    if (!isJoined.value) return;

    try {
      final leaveType = isFromEvent
          ? WebSocketMessageType.leaveStreaming
          : WebSocketMessageType.leaveStreamingFree;

      final request = {
        'type': leaveType,
        if (isFromEvent) 'eventId': eventId,
        if (!isFromEvent) 'streamId': streamId,
      };

      if (webSocketService.isConnected.value) {
        webSocketService.sendMessage(request);
      }

      isJoined.value = false;
      comments.clear();

      log("👋 Left streaming room");
    } catch (e) {
      log("❌ Error leaving stream: $e");
    }
  }

  @override
  void onClose() {
    leaveStream();
    super.onClose();
  }
}*/


import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LiveCommentController extends GetxController {
  final WebSocketClientService webSocketService = WebSocketClientService.to;
  final SharedPreferencesHelper helper = SharedPreferencesHelper();

  // Observable comment list
  final RxList<LiveComment> comments = <LiveComment>[].obs;
  final RxBool isJoined = false.obs;
  final RxBool isSending = false.obs;
  final RxBool isConnecting = false.obs;
  final RxString connectionError = ''.obs;

  // NEW: Warning and ban tracking
  final RxInt warningCount = 0.obs;
  final RxBool isBanned = false.obs;
  final RxString banMessage = ''.obs;

  // Stream info
  String? eventId;
  String? streamId;
  bool isFromEvent = false;

  @override
  void onInit() {
    super.onInit();
    _setupMessageListener();
    _setupBadWordWarningListener();
    _setupBannedListener();
  }

  /// Initialize for Event-based live streaming
  Future<void> initializeForEvent(String eventIdParam) async {
    eventId = eventIdParam;
    streamId = null;
    isFromEvent = true;

    log("📺 Initializing comment system for Event: $eventId");

    try {
      await _ensureWebSocketConnected();
      await _joinStream();
    } catch (e) {
      log("❌ Failed to initialize for event: $e");
      connectionError.value = "Failed to connect to chat server";
    }
  }

  /// Initialize for Free live streaming
  Future<void> initializeForFreeLive(String streamIdParam) async {
    streamId = streamIdParam;
    eventId = null;
    isFromEvent = false;

    log("📺 Initializing comment system for Free Live: $streamId");

    try {
      await _ensureWebSocketConnected();
      await _joinStream();
    } catch (e) {
      log("❌ Failed to initialize for free live: $e");
      connectionError.value = "Failed to connect to chat server";
    }
  }

  /// Ensure WebSocket is connected
  Future<void> _ensureWebSocketConnected() async {
    if (webSocketService.isConnected.value) {
      log("✅ WebSocket already connected");
      return;
    }

    if (webSocketService.isConnecting.value) {
      log("⏳ WebSocket connection already in progress, waiting...");
      int attempts = 0;
      const maxAttempts = 20;

      while (attempts < maxAttempts &&
          webSocketService.isConnecting.value &&
          !webSocketService.isConnected.value) {
        await Future.delayed(Duration(milliseconds: 500));
        attempts++;
      }

      if (webSocketService.isConnected.value) {
        log("✅ WebSocket connected (waited for existing connection)");
        return;
      }

      if (attempts >= maxAttempts) {
        throw Exception("Timeout waiting for existing connection");
      }
    }

    isConnecting.value = true;
    log("🔌 Connecting to WebSocket...");

    final authToken = helper.getString('userToken');
    if (authToken == null || authToken.isEmpty) {
      isConnecting.value = false;
      log("❌ No auth token available");
      throw Exception("Authentication token not found");
    }

    const socketUrl = "wss://api.morgan.smtsigma.com";

    try {
      await webSocketService.connect(socketUrl, authToken);

      int attempts = 0;
      const maxAttempts = 20;

      while (attempts < maxAttempts && !webSocketService.isConnected.value) {
        await Future.delayed(Duration(milliseconds: 500));
        attempts++;
      }

      if (!webSocketService.isConnected.value) {
        throw Exception("WebSocket connection timeout");
      }

      isConnecting.value = false;
      connectionError.value = '';
      log("✅ WebSocket connected successfully");
    } catch (e) {
      isConnecting.value = false;
      connectionError.value = e.toString();
      log("❌ WebSocket connection error: $e");
      rethrow;
    }
  }

  /// Setup message listener for incoming comments
  void _setupMessageListener() {
    webSocketService.setOnMessageReceived((message) {
      try {
        final data = jsonDecode(message);
        log("📨 Received message: $data");

        final messageType = data['type'] as String?;

        if (messageType == 'chat-streaming-comment' ||
            messageType == 'chat-streaming-free-comment' ||
            messageType == 'new-comment') {
          _handleNewComment(data);
        } else if (messageType == 'comment-history') {
          _handleCommentHistory(data);
        } else if (messageType == 'join-success') {
          log("✅ Successfully joined streaming room");
        } else if (messageType == 'error') {
          log("❌ Server error: ${data['message']}");
        }
      } catch (e) {
        log("❌ Error parsing message: $e");
      }
    });
  }

  /// NEW: Setup bad word warning listener
  void _setupBadWordWarningListener() {
    webSocketService.setOnBadWordWarning((data) {
      try {
        final message = data['message'] as String? ?? 'Inappropriate language is not allowed';
        final count = data['warningCount'] as int? ?? 0;

        log("⚠️ Bad word warning received: $message (Count: $count)");

        warningCount.value = count;
        _showWarningBottomSheet(message, count);
      } catch (e) {
        log("❌ Error handling bad word warning: $e");
      }
    });
  }

  /// NEW: Setup banned listener
  void _setupBannedListener() {
    webSocketService.setOnUserBanned((data) {
      try {
        final message = data['message'] as String? ?? 'You have been banned due to repeated violations.';

        log("🚫 User banned: $message");

        isBanned.value = true;
        banMessage.value = message;

        // Disconnect from WebSocket
        _handleBan();
      } catch (e) {
        log("❌ Error handling ban: $e");
      }
    });
  }

  /// NEW: Show warning bottom sheet
  void _showWarningBottomSheet(String message, int count) {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Warning Icon
            Container(
              width: 80.w,
              height: 80.h,
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.warning_amber_rounded,
                color: Colors.orange,
                size: 48.sp,
              ),
            ),
            SizedBox(height: 16.h),

            // Title
            Text(
              'Warning!',
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 12.h),

            // Message
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.black54,
                height: 1.4,
              ),
            ),
            SizedBox(height: 16.h),

            // Violation Count
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.red.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.block, color: Colors.red, size: 20.sp),
                  SizedBox(width: 8.w),
                  Text(
                    'Violations: $count',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),

            // Warning Text
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                'Further violations may result in a permanent ban from this stream.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: Colors.black54,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            SizedBox(height: 20.h),

            // Close Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  'I Understand',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      isDismissible: false,
      enableDrag: false,
    );
  }

  /// NEW: Handle user ban
  void _handleBan() async {
    // Leave stream
    await leaveStream();

    // Disconnect WebSocket
    webSocketService.disconnect();

    // Show ban dialog
    Get.dialog(
      WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          contentPadding: EdgeInsets.all(24.w),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Ban Icon
              Container(
                width: 100.w,
                height: 100.h,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.block,
                  color: Colors.red,
                  size: 56.sp,
                ),
              ),
              SizedBox(height: 20.h),

              // Title
              Text(
                'Account Banned',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 12.h),

              // Message
              Text(
                banMessage.value,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.black54,
                  height: 1.4,
                ),
              ),
              SizedBox(height: 24.h),

              // Exit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.back(); // Close dialog
                    Get.back(); // Exit live stream
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    'Exit Stream',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  /// Handle both single comment and comment arrays
  void _handleNewComment(Map<String, dynamic> data) {
    try {
      log("🔍 Parsing comment from data: $data");

      final messageData = data['message'] ?? data;

      // Check if this message contains an EventComment array
      if (messageData['EventComment'] != null && messageData['EventComment'] is List) {
        log("📚 Detected EventComment array with ${(messageData['EventComment'] as List).length} comments");
        _handleCommentArray(messageData['EventComment'] as List);
        return;
      }

      // Otherwise, handle as single comment
      final comment = LiveComment.fromJson(data);

      log("✅ Parsed single comment: ${comment.userName} - ${comment.comment}");

      // Add to top of list (newest first)
      comments.insert(0, comment);

      // Keep only last 100 comments
      if (comments.length > 100) {
        comments.removeRange(100, comments.length);
      }

      log("💬 Comment added to list. Total comments: ${comments.length}");
    } catch (e, stackTrace) {
      log("❌ Error handling new comment: $e");
      log("Stack trace: $stackTrace");
      log("Data that failed to parse: $data");
    }
  }

  /// Handle array of comments (for event streams)
  void _handleCommentArray(List commentArray) {
    try {
      log("📥 Processing ${commentArray.length} comments from array");

      // Parse all comments from array
      final List<LiveComment> parsedComments = [];

      for (var commentData in commentArray) {
        try {
          final comment = LiveComment.fromJson(commentData);
          parsedComments.add(comment);
          log("✅ Parsed: ${comment.userName} - ${comment.comment}");
        } catch (e) {
          log("❌ Failed to parse comment: $e");
          log("Comment data: $commentData");
        }
      }

      if (parsedComments.isEmpty) {
        log("⚠️ No comments were successfully parsed");
        return;
      }

      // Sort by timestamp (newest first)
      parsedComments.sort((a, b) => b.timestamp.compareTo(a.timestamp));

      // Replace current comments with new array
      comments.value = parsedComments;

      log("✅ Loaded ${parsedComments.length} comments from array");
      log("💬 Total comments in list: ${comments.length}");
    } catch (e, stackTrace) {
      log("❌ Error handling comment array: $e");
      log("Stack trace: $stackTrace");
    }
  }

  /// Handle comment history
  void _handleCommentHistory(Map<String, dynamic> data) {
    try {
      final List<dynamic> history = data['comments'] ?? [];
      final List<LiveComment> loadedComments = history
          .map((item) => LiveComment.fromJson(item))
          .toList();

      comments.value = loadedComments;
      log("📜 Loaded ${loadedComments.length} comments from history");
    } catch (e) {
      log("❌ Error handling comment history: $e");
    }
  }

  /// Join the streaming room
  Future<void> _joinStream() async {
    if (!webSocketService.isConnected.value) {
      log("❌ Cannot join: WebSocket not connected");
      throw Exception("WebSocket not connected");
    }

    try {
      final request = isFromEvent
          ? JoinStreamingRequest(
        type: WebSocketMessageType.joinStreaming,
        eventId: eventId,
      )
          : JoinStreamingRequest(
        type: WebSocketMessageType.joinStreamingFree,
        streamId: streamId,
      );

      webSocketService.sendMessage(request.toJson());
      isJoined.value = true;

      log("✅ Joined streaming room: ${isFromEvent ? 'Event $eventId' : 'Stream $streamId'}");
    } catch (e) {
      log("❌ Error joining stream: $e");
      rethrow;
    }
  }

  /// Send a comment
  Future<void> sendComment(String commentText) async {
    if (commentText.trim().isEmpty) {
      log("⚠️ Cannot send empty comment");
      return;
    }

    // Check if user is banned
    if (isBanned.value) {
      CustomSnackBar.error(
        title: "Banned",
        message: "You cannot send messages because you are banned.",
      );
      return;
    }

    if (!webSocketService.isConnected.value) {
      log("❌ Cannot send: WebSocket not connected");
      CustomSnackBar.error(
        title: "Connection Error",
        message: "Not connected to chat server. Please try again.",
      );
      throw Exception("Not connected to server");
    }

    if (!isJoined.value) {
      log("❌ Cannot send: Not joined to stream");
      CustomSnackBar.error(
        title: "Error",
        message: "Not joined to chat room. Please refresh.",
      );
      throw Exception("Not joined to stream");
    }

    isSending.value = true;

    try {
      final request = isFromEvent
          ? ChatStreamingRequest(
        type: WebSocketMessageType.chatStreaming,
        eventId: eventId,
        comment: commentText,
      )
          : ChatStreamingRequest(
        type: WebSocketMessageType.chatStreamingFree,
        streamId: streamId,
        comment: commentText,
      );

      webSocketService.sendMessage(request.toJson());

      log("💬 Comment sent: $commentText");
    } catch (e) {
      log("❌ Error sending comment: $e");
      CustomSnackBar.error(
        title: "Send Failed",
        message: "Failed to send comment. Please try again.",
      );
      rethrow;
    } finally {
      isSending.value = false;
    }
  }

  /// Retry connection
  Future<void> retryConnection() async {
    connectionError.value = '';

    try {
      if (isFromEvent && eventId != null) {
        await initializeForEvent(eventId!);
      } else if (!isFromEvent && streamId != null) {
        await initializeForFreeLive(streamId!);
      }
    } catch (e) {
      log("❌ Retry failed: $e");
    }
  }

  /// Leave the streaming room
  Future<void> leaveStream() async {
    if (!isJoined.value) return;

    try {
      final leaveType = isFromEvent
          ? WebSocketMessageType.leaveStreaming
          : WebSocketMessageType.leaveStreamingFree;

      final request = {
        'type': leaveType,
        if (isFromEvent) 'eventId': eventId,
        if (!isFromEvent) 'streamId': streamId,
      };

      if (webSocketService.isConnected.value) {
        webSocketService.sendMessage(request);
      }

      isJoined.value = false;
      comments.clear();

      log("👋 Left streaming room");
    } catch (e) {
      log("❌ Error leaving stream: $e");
    }
  }

  @override
  void onClose() {
    leaveStream();
    super.onClose();
  }
}
