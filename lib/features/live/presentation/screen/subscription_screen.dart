
import 'package:elites_live/features/live/presentation/widget/payment_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/global_widget/custom_text_view.dart';
import '../../../../core/global_widget/custom_elevated_button.dart';
import '../../../../core/utils/constants/app_colors.dart';

import '../../controller/subscription_controller.dart';
import '../widget/subscription_plan_card.dart';






class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SubscriptionController());

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Column(
        children: [
          /// Gradient Header
          Container(
            height: 150.h,
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
                margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Icon(Icons.arrow_back, color: Colors.white, size: 24.sp),
                    ),
                    SizedBox(width: 12.w),
                    CustomTextView(
                           text:   "Subscription",
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
                borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: 24.h),

                          /// Basic Plan
                          Obx(() => GestureDetector(
                            onTap: () => controller.selectPlan('basic'),
                            child: SubscriptionPlanCard(
                              planName: "Basic",
                              price: "\$5",
                              isSelected: controller.selectedPlan.value == 'basic',
                              features: [
                                "Access to live streams",
                                "Standard chat privileges",
                                "Basic badges",
                              ],
                            ),
                          )),

                          SizedBox(height: 20.h),

                          /// Premium Plan
                          Obx(() => GestureDetector(
                            onTap: () => controller.selectPlan('premium'),
                            child: SubscriptionPlanCard(
                              planName: "Premium",
                              price: "\$20",
                              isSelected: controller.selectedPlan.value == 'premium',
                              features: [
                                "Access to all live streams",
                                "Early to on-demand",
                                "Join streamers live on stage",
                                "Exclusive chat privileges",
                                "Special badges",
                              ],
                            ),
                          )),

                          SizedBox(height: 24.h),
                        ],
                      ),
                    ),
                  ),

                  /// Bottom Button
                  CustomElevatedButton(

                    ontap: () {
                      PaymentDialog.show(context);
                    },
                    text: "Pay Now",
                    gradient: AppColors.primaryGradient,
                  ),

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




