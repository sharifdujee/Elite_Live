import 'package:elites_live/features/profile/presentation/screen/payment_success_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/global_widget/custom_elevated_button.dart';
import '../../../../core/global_widget/custom_password_field.dart';
import '../../../../core/global_widget/custom_text_fields.dart';
import '../../../../core/global_widget/custom_text_view.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/validation/password_validation.dart';
import '../../controller/change_password_controller.dart';

class CardDetails extends StatelessWidget {
  const CardDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChangePasswordController());
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 190.h,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: AppColors.primaryGradient,
                  ),
                ),
                Positioned(
                  top: 50.h,
                  left: 20.w,
                  child:     Row(
                    children: [
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: const Icon(Icons.arrow_back,color: Colors.white,),
                      ),
                      SizedBox(width: 20.w),
                      Text('Debit or credit card',
                        style: GoogleFonts.inter(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.maxFinite,
                  margin: EdgeInsets.only(top: 160.h),
                  padding: EdgeInsets.symmetric(horizontal: 25.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24.r),
                      topRight: Radius.circular(24.r),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                       SizedBox(height: 16.h,),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: CustomTextView(
                            "Card Details",
                            fontSize: 16.sp,
                            color: AppColors.textColorBlack,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        CustomTextField(
                          hintText: "Name on card",
                          controller: controller.passwordController,
                         // validator: validatePassword,
                        ),
                        SizedBox(height: 16.h),

                        SizedBox(height: 5.h),
                        CustomTextField(
                          hintText: "Card number",
                          controller: controller.passwordController,
                          validator: validatePassword,
                        ),
                        SizedBox(height: 16.h),

                        CustomTextField(
                          hintText: "MM/YY",
                          controller: controller.passwordController,
                          validator: validatePassword,
                        ),
                        SizedBox(height: 16.h),

                        SizedBox(height: 5.h),
                        CustomTextField(
                          hintText: "CVV",
                          controller: controller.passwordController,
                          validator: validatePassword,
                        ),
                       SizedBox(height: 280.h,),
                        CustomElevatedButton(ontap: (){ paymentSuccessBottomSheet(Get.context!);}, text: "Save"),
                        SizedBox(height: 16.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }



}
