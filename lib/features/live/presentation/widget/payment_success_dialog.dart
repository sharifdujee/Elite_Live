import 'package:elites_live/core/utils/constants/image_path.dart';
import 'package:elites_live/routes/app_routing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/global_widget/custom_text_view.dart';
import '../../../../core/global_widget/custom_elevated_button.dart';
import '../../../../core/utils/constants/app_colors.dart';
import 'package:get/get.dart';

class PaymentSuccessDialog {
  static void show(BuildContext context) {



    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child:  Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                margin: EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Color(0xFF591AD4).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Container(
                  decoration: BoxDecoration(
                      color: Color(0xFFC121A0).withValues(alpha: 0.1)
                  ),
                  child: Image.asset(ImagePath.card, fit: BoxFit.cover,),
                ),

              ),

              // Title
              CustomTextView(
                "Payment Successful",
                fontSize: 24.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textHeader,
              ),
              SizedBox(height: 8.h),
              CustomTextView("Your payment has been done successfully.", fontWeight: FontWeight.w400,fontSize: 14.sp,color: AppColors.textBody,textAlign: TextAlign.center
                ,),
              SizedBox(height: 24.h),



              SizedBox(height: 16.h),



              SizedBox(height: 20),

              // Confirm button
              CustomElevatedButton(
                ontap: () {
                  Get.toNamed(AppRoute.myLive);

                },
                text: "Done",
              ),

              SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
            ],
          ),
        );
      },
    );
  }
}