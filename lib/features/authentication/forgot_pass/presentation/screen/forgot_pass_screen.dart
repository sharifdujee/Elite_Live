import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../core/global/custom_appbar.dart';
import '../../../../../core/global/custom_elevated_button.dart';
import '../../../../../core/global/custom_text_field.dart';
import '../../../../../core/global/custom_text_view.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/validation/email_validation.dart';
import '../../../../../routes/app_routing.dart';
import '../../controller/forgot_pass_controller.dart';



class ForgotPassScreen extends StatelessWidget {
  ForgotPassScreen({super.key});
  final formKey = GlobalKey<FormState>();

  final ForgotPassController controller = Get.find();
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
              //   controller.sendCode();
              // }
              Get.toNamed(
                AppRoute.forgotPasswordOtp,
              );
            },
            text: 'Send Code',
            isLoading: controller.isLoading.value,
          ),
        );
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.h),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              CustomTextView(
                textAlign: TextAlign.center,
                "Forgot Password",
                fontWeight: FontWeight.w700,
                fontSize: 20.sp,
                color: Color(0xFF2D2D2D),
              ),
              SizedBox(height: 10.h),
              CustomTextView(
                textAlign: TextAlign.center,
                "Enter your email to get a verification code.",
                fontWeight: FontWeight.w400,
                fontSize: 14.sp,
                color: Color(0xFF636F85),
              ),
              SizedBox(height: 30.h),
              Align(
                alignment: Alignment.centerLeft,
                child: CustomTextView(
                  "Email Address",
                  fontSize: 14.sp,
                  color: AppColors.textColorBlack,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 5.h),
              CustomTextField(
                hintText: "Enter your email",
                controller: controller.emailController,
                keyboardType: TextInputType.emailAddress,
                validator: validateEmail,
              ),
              SizedBox(height: 35.h),
            ],
          ),
        ),
      ),
    );
  }
}
