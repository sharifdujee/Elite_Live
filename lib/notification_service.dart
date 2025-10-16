// import 'dart:io';
// import 'package:flutter/widgets.dart';
// import 'package:get/get.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// class NotificationService extends GetxService {
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
//   final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//
//   @override
//   void onInit() {
//     super.onInit();
//     _initializeNotificationService();
//   }
//
//   Future<void> _initializeNotificationService() async {
//     try {
//       await _initializeLocalNotifications();
//       await _setupFirebaseMessaging();
//       _configureNotificationListener();
//       await getFcmApns();
//
//       // Setup token refresh listener
//       FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) async {
//         debugPrint("🔁 Refreshed FCM Token: $fcmToken");
//       });
//     } catch (e) {
//       debugPrint("Error initializing notification service: $e");
//     }
//   }
//
//   Future<void> _initializeLocalNotifications() async {
//     const AndroidInitializationSettings initializationSettingsAndroid =
//     AndroidInitializationSettings('@mipmap/ic_launcher');
//
//     const DarwinInitializationSettings initializationSettingsIOS =
//     DarwinInitializationSettings(
//       requestAlertPermission: true,
//       requestBadgePermission: true,
//       requestSoundPermission: true,
//     );
//
//     const InitializationSettings initializationSettings = InitializationSettings(
//       android: initializationSettingsAndroid,
//       iOS: initializationSettingsIOS,
//     );
//
//     await _localNotificationsPlugin.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse: (NotificationResponse response) {
//         debugPrint("Notification clicked with payload: ${response.payload}");
//         _handleNotificationClick(response);
//       },
//     );
//
//     // Create notification channel for Android
//     if (GetPlatform.isAndroid) {
//       await _createNotificationChannel();
//     }
//   }
//
//   Future<void> _createNotificationChannel() async {
//     const AndroidNotificationChannel channel = AndroidNotificationChannel(
//       'high_importance_channel',
//       'High Importance Notifications',
//       description: 'This channel is used for important notifications.',
//       importance: Importance.high,
//     );
//
//     await _localNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//         AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(channel);
//   }
//
//   Future<void> _setupFirebaseMessaging() async {
//     // Request permission for notifications
//     NotificationSettings settings = await _firebaseMessaging.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//       provisional: false,
//     );
//
//     debugPrint('User granted permission: ${settings.authorizationStatus}');
//
//     // iOS specific setup
//     if (GetPlatform.isIOS) {
//       await _setupiOSNotifications();
//     }
//   }
//
//   Future<void> _setupiOSNotifications() async {
//     try {
//       // Set foreground notification presentation options for iOS
//       await _firebaseMessaging.setForegroundNotificationPresentationOptions(
//         alert: true,
//         sound: true,
//         badge: true,
//       );
//
//       // Wait for APNs token to be available
//       String? apnsToken;
//       int retries = 10;
//       while (apnsToken == null && retries > 0) {
//         await Future.delayed(const Duration(seconds: 1));
//         apnsToken = await _firebaseMessaging.getAPNSToken();
//         retries--;
//         debugPrint("Waiting for APNs token... Retries left: $retries");
//       }
//
//       if (apnsToken == null) {
//         debugPrint('❌ Failed to fetch APNs token after retries.');
//       } else {
//         debugPrint('✅ APNs Token: $apnsToken');
//       }
//     } catch (e) {
//       debugPrint("Error in iOS setup: $e");
//     }
//   }
//
//   static Future<String?> getFcmApns() async {
//     try {
//       if (Platform.isAndroid) {
//         String? fcmToken = await FirebaseMessaging.instance.getToken();
//         if (fcmToken != null) {
//           debugPrint("Android FCM Token: $fcmToken");
//           return fcmToken;
//         } else {
//           debugPrint("Failed to retrieve Android FCM token: Token is null");
//           return null;
//         }
//       } else if (Platform.isIOS) {
//         NotificationSettings settings =
//         await FirebaseMessaging.instance.requestPermission(
//           alert: true,
//           badge: true,
//           sound: true,
//         );
//         if (settings.authorizationStatus != AuthorizationStatus.authorized &&
//             settings.authorizationStatus != AuthorizationStatus.provisional) {
//           debugPrint("Push notification permission denied");
//           return null;
//         }
//         String? apnsToken;
//         for (int i = 0; i < 3; i++) {
//           apnsToken = await FirebaseMessaging.instance.getAPNSToken();
//           if (apnsToken != null) break;
//           debugPrint("Retrying APNs token retrieval... Attempt ${i + 1}");
//           await Future.delayed(Duration(seconds: 1));
//         }
//         if (apnsToken != null) {
//           debugPrint("iOS APNs Token: $apnsToken");
//           String? fcmToken = await FirebaseMessaging.instance.getToken();
//           if (fcmToken != null) {
//             debugPrint("iOS FCM Token: $fcmToken");
//             return fcmToken;
//           } else {
//             debugPrint("Failed to retrieve iOS FCM token: Token is null");
//             return apnsToken;
//           }
//         } else {
//           debugPrint("Failed to retrieve iOS APNs token after retries: Token is null");
//           return null;
//         }
//       } else {
//         debugPrint("Unsupported platform for FCM/APNs token retrieval");
//         return null;
//       }
//     } catch (e, stackTrace) {
//       debugPrint("Error retrieving FCM/APNs token: $e");
//       debugPrint("Stack trace: $stackTrace");
//       return null;
//     }
//   }
//
//   void _configureNotificationListener() {
//     // Handle messages when app is in foreground
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       debugPrint("📱 Notification received in foreground:");
//       debugPrint("Data: ${message.data}");
//
//       // Only show notification if the message contains a data payload
//       if (message.data.isNotEmpty) {
//         _showLocalNotification(
//           title: message.data['title'] ?? 'No Title',
//           body: message.data['body'] ?? 'No Body',
//           data: message.data,
//         );
//       }
//     });
//
//     // Handle notification clicks when app is in background
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       debugPrint("🔔 Notification opened from background:");
//       debugPrint("Data: ${message.data}");
//
//       // Handle the notification data without showing a duplicate notification
//       _handleNotificationData(message.data);
//     });
//   }
//
//   Future<void> _showLocalNotification({
//     required String title,
//     required String body,
//     Map<String, dynamic>? data,
//   }) async {
//     // Check if the notification should be shown
//     if (data != null && data['showNotification'] == 'false') {
//       debugPrint("Skipping local notification based on data payload flag");
//       return;
//     }
//
//     try {
//       const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
//         'high_importance_channel',
//         'High Importance Notifications',
//         channelDescription: 'This channel is used for important notifications.',
//         importance: Importance.high,
//         priority: Priority.high,
//         showWhen: false,
//       );
//
//       const DarwinNotificationDetails iOSDetails = DarwinNotificationDetails(
//         presentAlert: true,
//         presentBadge: true,
//         presentSound: true,
//       );
//
//       const NotificationDetails notificationDetails = NotificationDetails(
//         android: androidDetails,
//         iOS: iOSDetails,
//       );
//
//       await _localNotificationsPlugin.show(
//         DateTime.now().millisecondsSinceEpoch.remainder(100000),
//         title,
//         body,
//         notificationDetails,
//         payload: data?.toString(),
//       );
//     } catch (e) {
//       debugPrint("Error showing local notification: $e");
//     }
//   }
//
//   void _handleNotificationClick(NotificationResponse response) {
//     debugPrint("Notification clicked: ${response.payload}");
//     // Handle notification click action here
//     // You can navigate to specific screens or perform actions based on payload
//   }
//
//   void _handleNotificationData(Map<String, dynamic> data) {
//     debugPrint("Handling notification data: $data");
//     // Handle notification data here
//     // You can navigate to specific screens or perform actions based on data
//   }
//
//   Future<void> handleInitialMessage() async {
//     RemoteMessage? initialMessage =
//     await FirebaseMessaging.instance.getInitialMessage();
//
//     if (initialMessage != null) {
//       debugPrint("🚀 App opened from terminated state via notification:");
//       debugPrint("Data: ${initialMessage.data}");
//
//       // Handle the notification data without showing a duplicate notification
//       _handleNotificationData(initialMessage.data);
//     }
//   }
//
//   Future<bool> areNotificationsEnabled() async {
//     if (GetPlatform.isAndroid) {
//       final bool? enabled = await _localNotificationsPlugin
//           .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin>()
//           ?.areNotificationsEnabled();
//       return enabled ?? false;
//     }
//
//     final settings = await _firebaseMessaging.getNotificationSettings();
//     return settings.authorizationStatus == AuthorizationStatus.authorized;
//   }
//
//   Future<bool> requestNotificationPermissions() async {
//     final settings = await _firebaseMessaging.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//
//     return settings.authorizationStatus == AuthorizationStatus.authorized;
//   }
//
//   @override
//   void onClose() {
//     // Clean up resources if needed
//     super.onClose();
//   }
// }