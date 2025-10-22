import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/route/app_route.dart';
import '../../../core/service_class/network_caller/model/network_response.dart';
import '../../../core/service_class/network_caller/repository/network_caller.dart';
import '../../../core/utility/app_urls.dart';
import '../../../routes/app_routing.dart';

class ForgotPassController extends GetxController {
  TextEditingController emailController = TextEditingController();
  RxBool isLoading = false.obs;

  Future<void> sendCode() async {
    isLoading.value = true;
    try {
      Map<String, dynamic> body = {"email": emailController.text};
      ResponseData responses = await NetworkCaller().postRequest(
        AppUrls.sendOtp,
        body: body,
      );
      if (responses.isSuccess) {
        Get.toNamed(
          AppRoute.forgotPasswordOtp,
          arguments: {'email': emailController.text},
        );
      } else {
        Get.snackbar(
          'Error:',
          responses.errorMessage,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }
}
