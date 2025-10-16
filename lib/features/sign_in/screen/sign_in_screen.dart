import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/global_widget/custom_elevated_button.dart';
import '../../../core/global_widget/custom_password_field.dart';
import '../../../core/global_widget/custom_text_fields.dart';
import '../../../core/global_widget/custom_text_view.dart';
import '../../../core/global_widget/social_login_button.dart';
import '../../../core/route/app_route.dart';
import '../../../core/utility/app_colors.dart';
import '../../../core/utility/image_path.dart';
import '../../../core/validation/email_validation.dart';
import '../../../core/validation/password_validation.dart';
import '../controller/sign_in_controller.dart';

class SignInScreen extends StatelessWidget {
  final SignInController controller = Get.find();
  final formKey = GlobalKey<FormState>();
  SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CustomTextView(
                  "Log In",
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                ),
                SizedBox(height: 5.h),
                CustomTextView(
                  "Log In to your account",
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textColor,
                ),
                SizedBox(height: 25.h),
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
                SizedBox(height: 25.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: CustomTextView(
                    "Password",
                    fontSize: 14.sp,
                    color: AppColors.textColorBlack,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 5.h),
                CustomPasswordField(
                  hints: "Enter Password",
                  controller: controller.passwordController,
                  validator: validatePassword,
                ),
                SizedBox(height: 10.h),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      Get.toNamed(AppRoute.forgotPassword);
                    },
                    child: CustomTextView(
                      "Forgot Password?",
                      fontSize: 14.sp,
                      color: AppColors.textColorBlack,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(height: 30.h),
                Obx(() {
                  return CustomElevatedButton(
                    ontap: () {
                      // if (formKey.currentState!.validate()) {
                        // controller.signIn();
                      // }
                      Get.offAllNamed(AppRoute.setupProfile);
                    },
                    text: "Log in",
                    isLoading: controller.isLoading.value,
                  );
                }),
                SizedBox(height: 25.h),
                Row(
                  children: [
                    Expanded(child: Divider()),
                    SizedBox(width: 10.w),
                    CustomTextView(
                      "Or login with",
                      fontSize: 12.sp,
                      color: AppColors.textColor,
                      fontWeight: FontWeight.w400,
                    ),
                    SizedBox(width: 10.w),
                    Expanded(child: Divider()),
                  ],
                ),
                SizedBox(height: 25.h),
                SocialLoginButton(
                  icon: Image.asset(
                    ImagePath.google,
                    width: 24.w,
                    height: 24.h,
                  ),
                  text: 'Continue with Google',
                  onPressed: () {
                    // controller.continueWithGoogle();
                  },
                ),
                SizedBox(height: 20.h),
                SocialLoginButton(
                  icon: Image.asset(
                    ImagePath.facebook,
                    width: 24.w,
                    height: 24.h,
                  ),
                  text: 'Continue with Facebook',
                  onPressed: () {},
                ),
                SizedBox(height: 25.h),
                Align(
                  alignment: Alignment.center,
                  child: RichText(
                    text: TextSpan(
                      text: 'Have an account ? ',
                      style: GoogleFonts.andika(
                        color: Colors.grey,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                      children: [
                        TextSpan(
                          text: 'Sign Up',
                          style: GoogleFonts.andika(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w400,
                            fontSize: 14.sp,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Get.toNamed(AppRoute.signUp);
                            },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 100.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
