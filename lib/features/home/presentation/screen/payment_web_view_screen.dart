import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:developer';

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
          },
          onPageFinished: (String url) {
            log('Page finished loading: $url');
            setState(() {
              isLoading = false;
            });

            // Check if payment is successful or cancelled
            if (url.contains('/donation/success')) {
              log('Payment successful');
              Get.back();
              Get.snackbar(
                'Success',
                'Payment completed successfully!',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green,
                colorText: Colors.white,
                duration: const Duration(seconds: 3),
              );
            } else if (url.contains('/donation/cancel')) {
              log('Payment cancelled');
              Get.back();
              Get.snackbar(
                'Cancelled',
                'Payment was cancelled',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.orange,
                colorText: Colors.white,
                duration: const Duration(seconds: 3),
              );
            }
          },
          onWebResourceError: (WebResourceError error) {
            log('WebView error: ${error.description}');
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