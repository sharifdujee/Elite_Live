import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:developer';



import '../../../../routes/app_routing.dart';

class PaymentWebViewScreen extends StatefulWidget {
  const PaymentWebViewScreen({super.key});

  @override
  State<PaymentWebViewScreen> createState() => _PaymentWebViewScreenState();
}

class _PaymentWebViewScreenState extends State<PaymentWebViewScreen> {
  late final WebViewController controller;
  bool isLoading = true;
  String? url;
  String? title;
  bool hasNavigated = false; // Prevent multiple navigations

  @override
  void initState() {
    super.initState();

    // Get arguments from Get.arguments
    final args = Get.arguments as Map<String, dynamic>?;
    url = args?['url'] as String?;
    title = args?['title'] as String? ?? 'Payment';

    if (url == null || url!.isEmpty) {
      log('Error: No URL provided');
      Get.back();
      Get.snackbar(
        'Error',
        'Payment URL is missing',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    log('Loading payment URL: $url');

    // Initialize WebView controller
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            log('Page started loading: $url');
            setState(() {
              isLoading = true;
            });

            // ✅ Check for success/cancel URLs when page starts loading
            if (!hasNavigated) {
              if (url.contains('/donation/success')) {
                hasNavigated = true;
                log('Payment successful - navigating to main view');

                // Navigate to main view
                Get.offAllNamed(AppRoute.mainView);

                // Show success message
                Get.snackbar(
                  'Success',
                  'Your payment was successfully done!',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                  duration: const Duration(seconds: 3),
                );
              } else if (url.contains('/donation/cancel')) {
                hasNavigated = true;
                log('Payment cancelled - navigating to main view');

                // Navigate to main view
                Get.offAllNamed(AppRoute.mainView);

                // Show cancellation message
                Get.snackbar(
                  'Cancelled',
                  'Payment was cancelled',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.orange,
                  colorText: Colors.white,
                  duration: const Duration(seconds: 3),
                );
              }
            }
          },
          onPageFinished: (String url) {
            log('Page finished loading: $url');
            setState(() {
              isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {
            log('WebView error: ${error.description}');
            setState(() {
              isLoading = false;
            });
            Get.snackbar(
              'Error',
              'Failed to load payment page',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
          },
        ),
      )
      ..loadRequest(Uri.parse(url!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title ?? 'Payment'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Get.back();
          },
        ),
        actions: [
          if (isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}