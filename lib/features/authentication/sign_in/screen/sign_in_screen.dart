import 'package:elites_live/core/utils/constants/icon_path.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/global_widget/custom_password_field.dart';
import '../../../../core/global_widget/custom_text_field.dart';
import '../../../../core/global_widget/custom_text_view.dart';
import '../../../../core/global_widget/custom_elevated_button.dart';
import '../../../../core/global_widget/social_login_button.dart';
import '../../../../core/services/google_signin_helper.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/image_path.dart';
import '../../../../core/validation/email_validation.dart';
import '../../../../core/validation/password_validation.dart';
import '../../../../routes/app_routing.dart';
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
                  text: "Log In",
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                ),
                SizedBox(height: 5.h),
                CustomTextView(
                  text: "Log In to your account",
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textColor,
                ),
                SizedBox(height: 25.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: CustomTextView(
                    text: "Email Address",
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
                    text: "Password",
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
                      text: "Forgot Password?",
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
                      controller.signIn();
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
                      text: "Or login with",
                      fontSize: 12.sp,
                      color: AppColors.textColor,
                      fontWeight: FontWeight.w400,
                    ),
                    SizedBox(width: 10.w),
                    Expanded(child: Divider()),
                  ],
                ),
                SizedBox(height: 25.h),
                Obx(
                  () => SocialLoginButton(
                    icon:
                        GoogleSignInHelper.instance.isLoading.value
                            ? Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 0.6,
                                color: AppColors.primaryColor,
                              ),
                            )
                            : Image.asset(
                              ImagePath.google,
                              width: 24.w,
                              height: 24.h,
                            ),
                    borderColor: Colors.black.withValues(alpha: 0.5),
                    borderRadius: 40.r,
                    text:
                        GoogleSignInHelper.instance.isLoading.value
                            ? ""
                            : 'Continue with Google',
                    onPressed: () {
                      GoogleSignInHelper.instance.signInWithGoogle();
                    },
                  ),
                ),
                SizedBox(height: 20.h),
                SocialLoginButton(
                  icon: Image.asset(IconPath.applei, width: 24.w, height: 24.h),
                  text: 'Continue with Apple',
                  borderRadius: 40.r,
                  borderColor: Colors.black.withValues(alpha: 0.5),
                  onPressed: () {},
                ),
                SizedBox(height: 25.h),
                Align(
                  alignment: Alignment.center,
                  child: RichText(
                    text: TextSpan(
                      text: 'Have an account ? ',
                      style: GoogleFonts.poppins(
                        color: Colors.grey,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                      children: [
                        TextSpan(
                          text: 'Sign Up',
                          style: GoogleFonts.poppins(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w400,
                            fontSize: 14.sp,
                          ),
                          recognizer:
                              TapGestureRecognizer()
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
