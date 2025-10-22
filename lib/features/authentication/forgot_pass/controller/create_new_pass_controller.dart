import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/services/network_caller/repository/network_caller.dart';
import '../../../../core/utils/constants/app_urls.dart';
import '../../../../routes/app_routing.dart';


class CreateNewPassController extends GetxController {
  RxBool isLoading = false.obs;
  final passwordController = TextEditingController();
  final conPasswordController = TextEditingController();
  var token = ''.obs;

  @override
  Future<void> onInit() async {
    if (Get.arguments != null) {
      var data = Get.arguments;
      token.value = data['forgetToken'] ?? '';
    } else {
      debugPrint("Error: Get.arguments is null");
    }
    super.onInit();
  }

  Future<void> resetPassword() async {
    debugPrint(token.value);
    isLoading.value = true;
    try {
      Map<String, dynamic> forgetPass = {
        "newPassword": passwordController.text,
      };

      final response = await NetworkCaller().patchRequest(
        AppUrls.resetPass,
        body: forgetPass,
        token: token.value,
      );

      if (response.isSuccess) {
        Get.toNamed(AppRoute.passwordChanged);
      } else {
        Get.snackbar(
          'Error',
          response.errorMessage,
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
      isLoading.value = false;
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void dispose() {
    passwordController.dispose();
    conPasswordController.dispose();
    super.dispose();
  }
}
