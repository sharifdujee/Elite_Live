


import 'package:elites_live/features/live/presentation/widget/payment_option_tile.dart';
import 'package:elites_live/features/live/presentation/widget/payment_success_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/global_widget/custom_text_view.dart';
import '../../../../core/global_widget/custom_elevated_button.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/icon_path.dart';
import '../../controller/payment_controller.dart';

class PaymentDialog {
  static void show(BuildContext context) {
    final PaymentController controller = Get.put(PaymentController());

    final gradientBorder = LinearGradient(
      colors: [AppColors.primaryColor, AppColors.secondaryColor],
    );

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Obx(() => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                margin: EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Title
              CustomTextView(
                     text:   "Payment Method",
                fontSize: 24.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textHeader,
              ),
              SizedBox(height: 27.h),
              Divider(),
              SizedBox(height: 24.h),

              // Google Pay
              PaymentOptionTile(
                index: 0,
                image: IconPath.google,
                isSelected: controller.selectedIndex.value == 0,
                onTap: () => controller.selectPayment(0),
                gradient: gradientBorder,
              ),

              SizedBox(height: 16.h),

              // Apple Pay
              PaymentOptionTile(
                index: 1,
                image: IconPath.apple,
                isSelected: controller.selectedIndex.value == 1,
                onTap: () => controller.selectPayment(1),
                gradient: gradientBorder,
              ),

              SizedBox(height: 20),

              // Confirm button
              CustomElevatedButton(
                ontap: () {
                  PaymentSuccessDialog.show(context);
                },
                text: "Confirm and pay",
              ),

              SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
            ],
          )),
        );
      },
    );
  }
}