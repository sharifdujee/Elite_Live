import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:elites_live/core/global_widget/custom_text_view.dart';
import 'package:elites_live/core/global_widget/custom_elevated_button.dart';
import 'package:elites_live/core/utils/constants/app_colors.dart';
import 'package:elites_live/features/live/controller/live_screen_controller.dart';

class CreateLiveScreen extends StatelessWidget {
  const CreateLiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final LiveScreenController controller = Get.put(LiveScreenController());

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Column(
        children: [
          /// Gradient Header
          Container(
            height: 140.h,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.secondaryColor, AppColors.primaryColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 24.sp,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    CustomTextView(
                      text: "Back",
                      fontWeight: FontWeight.w600,
                      fontSize: 20.sp,
                      color: AppColors.white,
                    )
                  ],
                ),
              ),
            ),
          ),

          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(24.r),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: 157.h),

                  /// Title Text
                  CustomTextView(
                    text: "Get your suitable live session with us.",
                    fontWeight: FontWeight.w600,
                    fontSize: 24.sp,
                    textAlign: TextAlign.center,
                    color: AppColors.liveText,
                  ),

                  SizedBox(height: 32.h),

                  /// Paid Live Button
                  Obx(() => CustomElevatedButton(
                    suffix: Icons.arrow_forward,
                    ontap: controller.isLoading.value
                        ? () {} // Disabled state
                        : () {
                      // Create live and navigate to paid live
                      controller.createAndNavigateToLive(
                        isPaid: true,
                        isHost: true,
                        cost: 100.0, // Set your cost here
                      );
                    },
                    text: "Go to Paid Live",
                    gradient: AppColors.primaryGradient,
                  )),

                  SizedBox(height: 12.w),

                  /// Free Live Button
                  Obx(() => CustomElevatedButton(
                    suffix: Icons.arrow_forward,
                    ontap: controller.isLoading.value
                        ? () {} // Disabled state
                        : () {
                      // Create live and navigate to free live
                      controller.createAndNavigateToLive(
                        isPaid: false,
                        isHost: true,
                        cost: 0.0,
                      );
                    },
                    text: "Go to Free Live",
                    gradient: AppColors.primaryGradient,
                  )),

                  SizedBox(height: 16.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}