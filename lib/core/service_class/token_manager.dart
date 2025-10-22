import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class TokenManager {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  /// Gets the FCM token with proper platform handling
  static Future<String?> getFcmToken() async {
    try {
      // Handle platform-specific requirements
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        await _handleIOSPermissions();
      }

      // Get and return the FCM token
      final token = await _messaging.getToken();
      debugPrint("✅ FCM Token: $token");
      return token;
    } catch (e) {
      debugPrint("❌ Error getting FCM token: $e");
      return null;
    }
  }

  /// Handles iOS-specific permission requests
  static Future<void> _handleIOSPermissions() async {
    try {
      final settings = await _messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: true, // Allow provisional authorization
        sound: true,
      );

      // Log permission status
      switch (settings.authorizationStatus) {
        case AuthorizationStatus.authorized:
          debugPrint('User granted full notification permission');
          break;
        case AuthorizationStatus.provisional:
          debugPrint('User granted provisional notification permission');
          break;
        case AuthorizationStatus.denied:
          debugPrint('User denied notification permission');
          break;
        case AuthorizationStatus.notDetermined:
          debugPrint('User hasn\'t decided yet');
          break;
      }

      // Optional: Get APNS token (useful for debugging)
      final apnsToken = await _messaging.getAPNSToken();
      if (apnsToken != null) {
        debugPrint("🍏 APNS Token: $apnsToken");
      }
    } catch (e) {
      debugPrint("⚠️ iOS permission error: $e");
    }
  }

  /// Listens for token refresh events
  static void setupTokenRefreshListener() {
    _messaging.onTokenRefresh.listen((newToken) {
      debugPrint('♻️ FCM Token Refreshed: $newToken');
      // Here you would typically send the new token to your server
    });
  }
}