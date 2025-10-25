import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/global_widget/custom_elevated_button.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../controller/payment_info_dialog_controller.dart';

class PaymentInfoDialog extends StatelessWidget {
  final PaymentInfodialogController controller = Get.put(PaymentInfodialogController());

  PaymentInfoDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
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
            // ====== Header with title and close ======
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Add payment information",
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                GestureDetector(
                  onTap: () => Get.back(),
                  child: const Icon(Icons.close, color: Colors.grey),
                ),
              ],
            ),
            SizedBox(height: 20.h),

            // ====== Select location and currency ======
            Text(
              "Select location and currency",
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              "Payment methods vary by region, so they'll be customized to where you're located.",
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                color: Colors.grey.shade600,
                height: 1.4,
              ),
            ),
            SizedBox(height: 16.h),

            // Country/region dropdown
            Obx(() => _buildDropdown(
              'Country/region',
              controller.selectedCountry.value,
              controller.countries,
                  (val) => controller.selectedCountry.value = val!,
            )),
            SizedBox(height: 16.h),

            // ====== Currency and time zone ======
            Text(
              "Currency and time zone",
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 12.h),

            // Currency dropdown
            Obx(() => _buildDropdown(
              'Currency',
              controller.selectedCurrency.value,
              controller.currencies,
                  (val) => controller.selectedCurrency.value = val!,
            )),
            SizedBox(height: 12.h),

            // Time zone dropdown
            Obx(() => _buildDropdown(
              'Time zone',
              controller.selectedTimeZone.value,
              controller.timeZones,
                  (val) => controller.selectedTimeZone.value = val!,
            )),
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

  Widget _buildDropdown(
      String label,
      String value,
      List<String> items,
      Function(String?) onChanged,
      ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11.sp,
              fontWeight: FontWeight.w400,
              color: Colors.grey.shade600,
            ),
          ),
          DropdownButton<String>(
            value: value,
            isExpanded: true,
            underline: const SizedBox(),
            icon: Icon(Icons.keyboard_arrow_down, size: 20.sp, color: Colors.grey.shade700),
            items: items
                .map((e) => DropdownMenuItem<String>(
              value: e,
              child: Text(
                e,
                style: GoogleFonts.inter(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ))
                .toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
