import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

import '../../../core/global_widget/custom_appbar.dart';
import '../../../core/global_widget/custom_elevated_button.dart';
import '../../../core/global_widget/custom_text_view.dart';
import '../../../core/route/app_route.dart';
import '../../../core/utility/app_colors.dart';
import '../../../core/validation/pin_validation.dart';
import '../controller/forgot_otp_controller.dart';

class ForgotOtpScreen extends StatelessWidget {
  ForgotOtpScreen({super.key});
  final formKey = GlobalKey<FormState>();

  final ForgotOtpController controller = Get.find();
  final bool isLoginButton = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      floatingActionButton: Obx(() {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: CustomElevatedButton(
            ontap: () {
              // if (formKey.currentState!.validate()) {
              //   controller.verifyOtp();
              // }
              Get.toNamed(AppRoute.resetPassword);
            },
            text: 'Submit',
            isLoading: controller.isLoading.value,
          ),
        );
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.h),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                SizedBox(height: 30.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: CustomTextView(
                    textAlign: TextAlign.center,
                    "Verification Code",
                    fontWeight: FontWeight.w600,
                    fontSize: 20.sp,
                    color: Color(0xFF2D2D2D),
                  ),
                ),
                SizedBox(height: 10.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: CustomTextView(
                    "Enter the verification code that we have sent to your email",
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
                    color: Color(0xFF636F85),
                  ),
                ),
                SizedBox(height: 30.h),
                Pinput(
                  length: 4,
                  keyboardType: TextInputType.number,
                  controller: controller.otpController,
                  validator: validatePin,
                  errorTextStyle: GoogleFonts.poppins(
                    color: Colors.red,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                  ),
                  defaultPinTheme: PinTheme(
                    height: 60.h,
                    width: 60.w,
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    textStyle: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF120D26),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Color(0xFFF9F9FB),
                    ),
                  ),
                  focusedPinTheme: PinTheme(
                    height: 60.h,
                    width: 60.w,
                    textStyle: GoogleFonts.inter(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryColor,
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xFFF9F9FB),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    formKey.currentState?.validate();
                  },
                ),
                SizedBox(height: 35.h),
                RichText(
                  text: TextSpan(
                    text: 'Re-send code in ',
                    style: GoogleFonts.andika(
                      color: Colors.grey,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                    children: [
                      TextSpan(
                        text: 'Resend',
                        style: GoogleFonts.andika(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w400,
                          fontSize: 14.sp,
                        ),
                        recognizer: TapGestureRecognizer()..onTap = () {
                          // controller.resendOtp();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
