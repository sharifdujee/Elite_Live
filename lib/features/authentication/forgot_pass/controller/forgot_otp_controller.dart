import 'package:elites_live/core/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/services/network_caller/repository/network_caller.dart';
import '../../../../core/utils/constants/app_urls.dart';
import '../../../../routes/app_routing.dart';


class ForgotOtpController extends GetxController {
  AuthService preferencesHelper = AuthService();
  final TextEditingController otpController = TextEditingController();
  var otp = ''.obs;
  var email = ''.obs;
  RxBool isLoading = false.obs;

  @override
  Future<void> onInit() async {
    if (Get.arguments != null) {
      var data = Get.arguments;
      email.value = data['email'] ?? '';
    } else {
      debugPrint("Error: Get.arguments is null");
    }
    await preferencesHelper.init();
    super.onInit();
  }

  Future<void> verifyOtp() async {
    Map<String, dynamic> data = {
      "email": email.value,
      "otp": otpController.text.trim(),
    };
    try {
      isLoading.value = true;

      String url = AppUrls.verifyForgotOtp;

      final response = await NetworkCaller().postRequest(url, body: data);
      if (response.isSuccess) {
        Get.toNamed(AppRoute.resetPassword, arguments: {
          "forgetToken": response.responseData['forgetToken']
        });
      } else {
        Get.snackbar(
          "Error",
          response.errorMessage,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resendOtp() async {
    Map<String, dynamic> data = {"email": email.value};
    try {
      isLoading.value = true;
      String url = AppUrls.sendOtp;
      final response = await NetworkCaller().postRequest(url, body: data);
      if (response.isSuccess) {
        otpController.text = "";
        Get.snackbar(
          "Success",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          "Resend Code successfully",
        );
      } else {
        Get.snackbar(
          "Error",
          response.errorMessage,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void clearOtp() {
    otp.value = '';
    otpController.clear();
  }

  @override
  void onClose() {
    otpController.dispose();
    super.onClose();
  }
}
