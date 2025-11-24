import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:elites_live/core/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';

import '../../features/home/controller/home_controller.dart';
import '../helper/shared_prefarenses_helper.dart';
import '../helper/stripe_key_helper.dart';
import '../utils/constants/app_urls.dart';
import 'network_caller/repository/network_caller.dart';

class StripeService {
  StripeService._();
  static final StripeService instance = StripeService._();

  final HomeController controller = Get.find<HomeController>();

  /// Main entry point for payment processing
  Future<void> paymentStart(String postId, double amount) async {
    log("PaymentStart called with postId: $postId and amount: \$$amount");

    if (amount <= 0) {
      _showError(
        'Invalid amount',
        'Please enter a valid amount greater than \$0',
      );
      return;
    }

    try {
      await setupPaymentMethod(postId, amount);
    } catch (e) {
      log("PaymentStart failed: $e");
      _closeLoadingDialog();
      _showError('Payment Error', 'Failed to start payment: ${e.toString()}');
    }
  }

  /// Sets up the payment method using Stripe SetupIntent
  Future<void> setupPaymentMethod(String postId, double amount) async {
    try {
      log('Starting payment setup for postId: $postId');

      // Create SetupIntent
      final String? setupIntentClientSecret = await _createSetupIntent();

      if (setupIntentClientSecret == null || setupIntentClientSecret.isEmpty) {
        throw Exception('Failed to create payment setup intent');
      }

      log('Setup Intent created successfully');

      // Initialize payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          setupIntentClientSecret: setupIntentClientSecret,
          merchantDisplayName: "Bd Calling IT",
          style: ThemeMode.light,
          appearance: const PaymentSheetAppearance(
            primaryButton: PaymentSheetPrimaryButtonAppearance(
              colors: PaymentSheetPrimaryButtonTheme(
                light: PaymentSheetPrimaryButtonThemeColors(
                  background: Color(0xFF5F53FB),
                ),
              ),
            ),
          ),
        ),
      );

      log('Payment sheet initialized successfully');

      // Close any loading dialogs before showing payment sheet
      _closeLoadingDialog();

      // Present payment sheet and confirm
      await _confirmSetupIntent(setupIntentClientSecret, postId, amount);
    } catch (e) {
      log('Setup Payment Method failed: $e');
      _closeLoadingDialog();
      _showError(
        'Payment Setup Error',
        'Failed to setup payment method: ${e.toString()}',
      );
      rethrow;
    }
  }

  /// Creates a SetupIntent on Stripe's server
  Future<String?> _createSetupIntent() async {
    try {
      log('Creating setup intent...');

      final Dio dio = Dio();
      dio.options.connectTimeout = const Duration(seconds: 30);
      dio.options.receiveTimeout = const Duration(seconds: 30);

      final Map<String, dynamic> data = {"payment_method_types[]": "card"};

      final response = await dio.post(
        "https://api.stripe.com/v1/setup_intents",
        data: data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {"Authorization": "Bearer $stripeSecretKey"},
        ),
      );

      log('Setup Intent Response Status: ${response.statusCode}');

      if (response.statusCode == 200 && response.data != null) {
        final clientSecret = response.data["client_secret"];
        if (clientSecret != null && clientSecret.isNotEmpty) {
          log('Setup Intent created successfully');
          return clientSecret;
        }
      }

      log('Invalid response from Stripe API');
      throw Exception('Invalid response from payment service');
    } on DioException catch (e) {
      log('DioException creating SetupIntent: ${e.type}');

      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception(
          'Connection timeout. Please check your internet connection.',
        );
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Request timeout. Please try again.');
      } else if (e.response != null) {
        log('Stripe API Error Response: ${e.response?.data}');
        throw Exception('Payment service error: ${e.response?.statusCode}');
      }

      throw Exception(
        'Network error. Please check your connection and try again.',
      );
    } catch (e) {
      log('Error creating SetupIntent: $e');
      throw Exception('Failed to create payment setup: ${e.toString()}');
    }
  }

  /// Confirms the SetupIntent by presenting the payment sheet
  Future<void> _confirmSetupIntent(
    String setupIntentClientSecret,
    String postId,
    double amount,
  ) async {
    try {
      log('Presenting payment sheet...');

      // Present the payment sheet to the user
      await Stripe.instance.presentPaymentSheet();

      log('Payment sheet completed successfully!');

      // Retrieve payment method details
      await _getSetupDetails(setupIntentClientSecret, postId, amount);
    } on StripeException catch (e) {
      log('StripeException: ${e.error.code} - ${e.error.message}');

      if (e.error.code == FailureCode.Canceled) {
        _showInfo('Cancelled', 'Payment was cancelled');
      } else {
        _showError(
          'Payment Error',
          e.error.message ?? 'Payment failed. Please try again.',
        );
      }
    } catch (e) {
      log('Setup Confirmation Failed: $e');
      _showError(
        'Payment Error',
        'Payment confirmation failed: ${e.toString()}',
      );
    }
  }

  /// Retrieves SetupIntent details to get the payment method ID
  Future<void> _getSetupDetails(
    String setupIntentClientSecret,
    String postId,
    double amount,
  ) async {
    try {
      log('Getting setup details...');

      final Dio dio = Dio();
      final setupIntentId = setupIntentClientSecret.split('_secret_')[0];
      log('Setup Intent ID: $setupIntentId');

      final response = await dio.get(
        "https://api.stripe.com/v1/setup_intents/$setupIntentId",
        options: Options(
          headers: {
            "Authorization": "Bearer $stripeSecretKey",
            "Content-Type": "application/x-www-form-urlencoded",
          },
        ),
      );

      if (response.statusCode == 200 &&
          response.data != null &&
          response.data['payment_method'] != null) {
        final String paymentMethodId = response.data['payment_method'];
        log('Payment method retrieved: $paymentMethodId');

        // Confirm payment with your backend
        await confirmPayment(paymentMethodId, postId, amount);
      } else {
        throw Exception('Failed to retrieve payment method');
      }
    } on DioException catch (e) {
      log('DioException retrieving setup details: ${e.message}');
      _showError(
        'Error',
        'Failed to complete payment setup. Please try again.',
      );
    } catch (e) {
      log('Failed to retrieve setup details: $e');
      _showError('Error', 'Failed to complete payment setup: ${e.toString()}');
    }
  }

  /// Confirms payment with your backend server
  Future<void> confirmPayment(
    String paymentId,
    String postId,
    double amount,
  ) async {
    final Map<String, dynamic> requestBody = {
      'postId': postId,
      'amount': amount,
      "paymentMethodId": paymentId,
    };

    try {
      log("Confirming payment with backend...");
      log("Request Body: $requestBody");

      final response = await NetworkCaller().postRequest(
        AppUrls.createPayment,
        body: requestBody,
        token: SharedPreferencesHelper().getString("userToken"),
      );

      log("Payment Response: ${response.responseData}");

      if (response.isSuccess) {
        final responseData = response.responseData["result"];
        final paymentIntentId = responseData['paymentIntentId'];
        final paymentMethodId = responseData['paymentMethodId'];

        log(
          'Payment confirmed: paymentIntentId = $paymentIntentId, paymentMethodId = $paymentMethodId',
        );

        _closeLoadingDialog();

        _showSuccess('Success!', 'Payment successfully completed!');

        // Refresh the posts list
        /// controller.getAllPost();
      } else {
        throw Exception(response.errorMessage ?? 'Payment confirmation failed');
      }
    } catch (error) {
      log('Payment confirmation error: $error');
      _closeLoadingDialog();
      _showError(
        'Payment Error',
        'Payment confirmation failed: ${error.toString()}',
      );
    }
  }

  /// Captures a payment (if using manual capture flow)
  Future<void> capturePayment(
    String paymentIntentId,
    String postId,
    double amount,
  ) async {
    final Map<String, dynamic> requestBody = {
      'postId': postId,
      'amount': amount,
      'paymentIntentId': paymentIntentId,
    };

    try {
      log("Capturing payment...");
      log("Request Body: $requestBody");

      final response = await NetworkCaller().postRequest(
        AppUrls.createPayment,
        body: requestBody,
        token: SharedPreferencesHelper().getString("userToken"),
      );

      log("Capture Response Status: ${response.statusCode}");
      log("Capture Response Body: ${response.responseData}");

      if (response.isSuccess == true && response.statusCode == 200) {
        log("Payment captured successfully!");
        _closeLoadingDialog();
        _showSuccess('Success!', 'Payment successfully completed!');

        //controller.getAllPost();
      } else {
        throw Exception(response.errorMessage ?? 'Payment capture failed');
      }
    } catch (error) {
      log("Payment capture error: $error");
      _closeLoadingDialog();
      _showError(
        'Payment Failed',
        'Payment could not be completed: ${error.toString()}',
      );
    }
  }

  // Helper methods for UI feedback
  void _closeLoadingDialog() {
    if (Get.isDialogOpen == true) {
      Get.back();
    }
  }

  void _showError(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 4),
      margin: const EdgeInsets.all(10),
    );
  }

  void _showSuccess(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.primaryColor,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(10),
    );
  }

  void _showInfo(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.grey[700],
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(10),
    );
  }
}
