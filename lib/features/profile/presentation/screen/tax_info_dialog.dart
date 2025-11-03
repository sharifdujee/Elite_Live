import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/global_widget/custom_elevated_button.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../controller/tax_info_dialog_controller.dart';

class TaxInfoDialog extends StatelessWidget {
  final TaxInfdialogController controller = Get.put(TaxInfdialogController());

  TaxInfoDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ====== Header ======
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Tax Information",
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Icon(Icons.close, color: Colors.grey.shade600, size: 22.sp),
                ),
              ],
            ),
            SizedBox(height: 18.h),

            // ====== EIN Title ======
            Text(
              "Employer Identification Number (EIN)",
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8.h),

            // ====== Description ======
            Text(
              "By providing your EIN, you are confirming that you are registered for Value-Added Tax (VAT) and should not be charged VAT. You will be charged VAT if the BIN you provide is invalid or incomplete.",
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                height: 1.5,
                color: Colors.grey.shade600,
              ),
            ),
            SizedBox(height: 20.h),

            // ====== Text Field ======
            TextField(
              controller: controller.einController,
              style: GoogleFonts.inter(
                fontSize: 13.sp,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: "Optional",
                hintStyle: GoogleFonts.inter(
                  fontSize: 13.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(color: AppColors.primaryColor),
                ),
              ),
            ),
            SizedBox(height: 24.h),

            // ====== Next Button ======
            CustomElevatedButton(
              text: "Next",
              ontap: () => controller.onNext(),
              gradient: AppColors.primaryGradient,
            ),
          ],
        ),
      ),
    );
  }
}
