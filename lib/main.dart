import 'package:elites_live/core/services/push_notification_service.dart';
import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:elites_live/core/services/auth_service.dart';
import 'package:elites_live/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'app.dart';
import 'core/binding/app_binding.dart';
import 'core/helper/stripe_key_helper.dart';
import 'core/services/socket_service.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  await AuthService().init();
  await PushNotificationService.initialize();

  AppBinding().dependencies();
  await initializeStripe();
  Get.put(WebSocketClientService(), permanent: true);


  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);

  runApp(MyApp());
}

Future<void> initializeStripe() async {
  try {
    log(' Initializing Stripe Flutter plugin...');

    if (stripePublishableKey.isEmpty ||
        !stripePublishableKey.startsWith('pk_')) {
      throw Exception('Invalid Stripe publishable key');
    }

    Stripe.publishableKey = stripePublishableKey;

    Stripe.merchantIdentifier = "merchant.com.fateforge.fateforge.fateforge";

    int retryCount = 0;
    const int maxRetries = 3;

    while (retryCount < maxRetries) {
      try {
        await Future.delayed(Duration(milliseconds: 500 * (retryCount + 1)));
        await Stripe.instance.applySettings();

        log('Stripe Flutter plugin initialized successfully');
        Get.put<bool>(true, tag: 'stripe_available');

        return;
      } catch (e) {
        retryCount++;
        log('Stripe initialization attempt $retryCount failed: $e');

        if (retryCount >= maxRetries) {
          log('Max retry attempts reached for Stripe initialization');
          rethrow;
        }
        log('Retrying Stripe initialization in ${500 * (retryCount + 1)}ms...');
      }
    }
  } catch (e) {
    log('Stripe initialization error: $e');

    Get.put<bool>(false, tag: 'stripe_available');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.snackbar(
        'Payment Service Error',
        'Payment system failed to initialize. Some features may not work.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );
    });

    rethrow;
  }
}
