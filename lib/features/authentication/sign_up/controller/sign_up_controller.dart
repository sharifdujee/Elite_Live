

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/helper/shared_prefarenses_helper.dart';

import '../../../../core/services/google_signin_helper.dart';
import '../../../../core/services/network_caller/model/network_response.dart';
import '../../../../core/services/network_caller/repository/network_caller.dart';
import '../../../../core/utils/constants/app_urls.dart';
import '../../../../routes/app_routing.dart';



class SignUpController extends GetxController {
  final _helper = GoogleSignInHelper.instance;

  SharedPreferencesHelper preferencesHelper = SharedPreferencesHelper();
  RxBool isLoading = false.obs;
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Future<void> onInit() async {
    await preferencesHelper.init();
    super.onInit();
  }

  Future<void> registerUser() async {
    isLoading.value = true;
    try {
      Map<String, dynamic> signUpData = {
        "firstName": firstNameController.text.trim(),
        "lastName": lastNameController.text.trim(),
        "email": emailController.text.trim(),
        "password": passwordController.text.trim(),
      };

      ResponseData response = await NetworkCaller().postRequest(
        AppUrls.registerUrl,
        body: signUpData,
      );

      if (response.isSuccess) {
        // ✅ Only navigate when API is successful
        Get.toNamed(
          AppRoute.signOtp,
          arguments: {
            "email": emailController.text.trim(),
            "name": firstNameController.text.trim(),
            "password": passwordController.text.trim(),
          },
        );
      } else {
        // ❌ Show error but don’t navigate
        Get.snackbar(
          'Registration Failed',
          response.errorMessage.isNotEmpty ? response.errorMessage : 'Something went wrong',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint("Register Error: $e");
      Get.snackbar(
        'Error',
        'Unable to register. Please try again.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
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
  void onClose() {
    firstNameController.clear();
    lastNameController.clear();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}