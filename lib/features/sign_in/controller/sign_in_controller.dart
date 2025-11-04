import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/helper/shared_prefarenses_helper.dart';
import '../../../core/service_class/google_signin_helper.dart';
import '../../../core/service_class/network_caller/repository/network_caller.dart';
import '../../../core/utility/app_urls.dart';
import '../../../routes/app_routing.dart';

class SignInController extends GetxController {
  final _helper = GoogleSignInHelper2();
  SharedPreferencesHelper preferencesHelper = SharedPreferencesHelper();
  RxBool isLoading = false.obs;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Future<void> onInit() async {
    await preferencesHelper.init();
    super.onInit();
  }

  Future<void> signIn() async {
    String? token = "";
    Map<String, dynamic> registration = {
      "email": emailController.text,
      "password": passwordController.text,
      "fcmToken": token,
    };

    try {
      isLoading.value = true;

      String url = AppUrls.loginUrl;

      final response = await NetworkCaller().postRequest(
        url,
        body: registration,
      );

      if (response.isSuccess) {
        preferencesHelper.setString(
          "userToken",
          response.responseData['accessToken'],
        );
        log("the api response is ${response.responseData}");
        Get.offAllNamed(AppRoute.setupProfile, arguments: {});
        final isSetup = response.responseData['isSetup'];
        if (isSetup) {
          preferencesHelper.setBool("isSetup", isSetup);
          Get.snackbar(
            "Success",
            backgroundColor: Colors.green,
            colorText: Colors.white,
            "User logged in successfully",
            snackPosition: SnackPosition.TOP,
          );

          Get.offAllNamed(AppRoute.mainView);
        } else {
          preferencesHelper.setBool("isSetup", isSetup);
          Get.snackbar(
            "Success",
            backgroundColor: Colors.yellow,
            colorText: Colors.black,
            "User logged in successfully Setup your profile",
            snackPosition: SnackPosition.TOP,
          );
          // Get.offAllNamed(AppRoute.settingGoalScreen);
        }
      } else {
        Get.snackbar(
          "Error",
          response.errorMessage,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<Map<String, dynamic>?> continueWithGoogle() async {
    final user = await _helper.signInWithGoogle();
    if (user != null) {
      debugPrint("Name: ${user['name']}");
      debugPrint("Email: ${user['email']}");
      debugPrint("Photo URL: ${user['photoUrl']}");
      await sendToBackEnd(user['name'], user['email'], user['photoUrl']);
    }
    return null;
  }

  Future<void> sendToBackEnd(
    String name,
    String email,
    String? profileImage,
  ) async {
    isLoading.value = true;
    Map<String, dynamic> signInData = {
      "fullName": name,
      "email": email,
      "profileImage": profileImage ?? "",
    };
    try {
      var response = await NetworkCaller().postRequest(
        AppUrls.socialLogin,
        body: signInData,
      );

      if (response.isSuccess) {
        preferencesHelper.setString(
          "userToken",
          response.responseData['accessToken'],
        );
        final isSetup = response.responseData['isSetup'];
        if (isSetup) {
          preferencesHelper.setBool("isSetup", isSetup);
          Get.snackbar(
            "Success",
            backgroundColor: Colors.green,
            colorText: Colors.white,
            "User logged in successfully",
            snackPosition: SnackPosition.TOP,
          );
          // Get.offAllNamed(AppRoute.mainView);
        } else {
          preferencesHelper.setBool("isSetup", isSetup);
          Get.snackbar(
            "Success",
            backgroundColor: Colors.yellow,
            colorText: Colors.black,
            "User logged in successfully Setup your profile",
            snackPosition: SnackPosition.TOP,
          );
          // Get.offAllNamed(AppRoute.settingGoalScreen);
        }
      } else {
        Get.snackbar(
          "Error",
          response.errorMessage,
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
    passwordController.dispose();
    super.dispose();
  }
}
