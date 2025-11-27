import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';

class PushNotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications =
  FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'default_channel',
    'General Notifications',
    description: 'This channel is used for basic notifications.',
    importance: Importance.high,
  );

  /// Initialize push notifications
  static Future<void> initialize() async {
    // Request permissions iOS + Android 13+
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Create local notification settings for BOTH Android AND iOS
    const AndroidInitializationSettings androidInit =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    // CRITICAL FIX: Add iOS initialization settings
    const DarwinInitializationSettings iosInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // CRITICAL FIX: Include iOS settings in initialization
    const InitializationSettings initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit, // ← This was missing!
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Create channel on Android
    await _localNotifications
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);

    // Handle foreground notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint("📥 Foreground message: ${message.notification?.title}");
      _showLocalNotification(message);
    });

    // When tapping a notification while app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint("📲 Notification opened: ${message.notification?.title}");
      _handleNotificationTap(message);
    });

    // For terminated state messages
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      debugPrint("🚀 App opened from terminated state: "
          "${initialMessage.notification?.title}");
      _handleNotificationTap(initialMessage);
    }
  }

  /// Handle notification tap
  static void _onNotificationTapped(NotificationResponse response) {
    debugPrint("🔔 Local notification tapped: ${response.payload}");
    // Add your navigation logic here
  }

  /// Handle notification tap (from FCM)
  static void _handleNotificationTap(RemoteMessage message) {
    debugPrint("🔔 FCM notification tapped: ${message.data}");
    // Add your navigation logic here based on message.data
  }

  /// Display notification manually for foreground messages
  static Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    final android = notification?.android;

    if (notification == null) return;

    // Android notification details
    final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      _channel.id,
      _channel.name,
      channelDescription: _channel.description,
      importance: Importance.high,
      priority: Priority.high,
      icon: android?.smallIcon ?? '@mipmap/ic_launcher',
    );

    // iOS notification details
    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    // Combined platform details
    final NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails, // ← Added iOS details
    );

    await _localNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      platformDetails,
      payload: message.data.toString(), // Optional: pass data for tap handling
    );
  }

  /// Get FCM Token (to test in Firebase Console)
  static Future<String?> getToken() async {
    final token = await _messaging.getToken();
    debugPrint("🔑 FCM Token: $token");
    return token;
  }

  /// Subscribe to a topic
  static Future<void> subscribeToTopic(String topic) async {
    await _messaging.subscribeToTopic(topic);
    debugPrint("✅ Subscribed to topic: $topic");
  }

  /// Unsubscribe from a topic
  static Future<void> unsubscribeFromTopic(String topic) async {
    await _messaging.unsubscribeFromTopic(topic);
    debugPrint("❌ Unsubscribed from topic: $topic");
  }
}