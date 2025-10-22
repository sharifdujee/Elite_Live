import 'package:elites_live/core/global_widget/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/global_widget/custom_text_view.dart';
import '../../../core/helper/shared_prefarenses_helper.dart';
import '../../../core/service_class/network_caller/repository/network_caller.dart';
import '../../../core/utility/app_urls.dart';
import '../../../core/utils/constants/app_colors.dart';

class SignUpOtpController extends GetxController {
  SharedPreferencesHelper preferencesHelper = SharedPreferencesHelper();
  final TextEditingController otpController = TextEditingController();
  var otp = ''.obs;
  var name = ''.obs;
  var email = ''.obs;
  var password = ''.obs;
  RxBool isLoading = false.obs;

  @override
  Future<void> onInit() async {
    debugPrint(Get.arguments);
    if (Get.arguments != null) {
      var data = Get.arguments;
      name.value = data['name'] ?? '';
      email.value = data['email'] ?? '';
      password.value = data['password'] ?? '';
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

      String url = AppUrls.verifyOtp;

      final response = await NetworkCaller().postRequest(url, body: data);
      if (response.isSuccess) {
        showSuccessDialog();
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
    Map<String, dynamic> signUpData = {
      "fullName": name.value,
      "email": email.value,
      "password": password.value,
    };

    try {
      isLoading.value = true;

      String url = AppUrls.registerUrl;

      final response = await NetworkCaller().postRequest(url, body: signUpData);
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

  void showSuccessDialog() {
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          backgroundColor: AppColors.white,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 80.h,
                  width: 80.h,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.verified_user,
                    color: Colors.white,
                    size: 40.sp,
                  ),
                ),
                SizedBox(height: 20.h),
                CustomTextView(
                  'Account verified\nSuccessfully',
                  textAlign: TextAlign.center,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
                SizedBox(height: 25.h),
                SizedBox(
                  width: double.infinity,
                  height: 48.h,
                  child: CustomElevatedButton(
                    ontap: () {
                      Get.back();
                      // Get.offAllNamed(AppRoute.signIn);
                    },
                    text: "Done",
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
