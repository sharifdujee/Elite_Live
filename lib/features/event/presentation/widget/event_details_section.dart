import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/global_widget/custom_text_view.dart';
import '../../../../core/utils/constants/app_colors.dart';


class EventDetailsSection extends StatelessWidget {
  const EventDetailsSection({
    super.key,
    required this.eventDetails,
    required this.joiningFee,
    required this.eventTitle,
    required this.isOwner,
    this.hostLink,
    this.audienceLink,
    required this.isPayment,
    this.onTap,
  });

  final String eventDetails;
  final String joiningFee;
  final String eventTitle;
  final bool isOwner;
  final bool isPayment;
  final String? hostLink;
  final String? audienceLink;
  final VoidCallback? onTap;

  // Copy link helper
  void _copyToClipboard(String link) {
    Clipboard.setData(ClipboardData(text: link));
    Get.snackbar(
      'Copied',
      'Link copied to clipboard',
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 2),
      backgroundColor: AppColors.primaryColor,
      colorText: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    final String? displayLink = isOwner ? hostLink : audienceLink;
    final String linkLabel = isOwner ? "Host Link" : "Audience Link";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        /// Event Title
        CustomTextView(
          text: eventTitle,
          fontWeight: FontWeight.w400,
          fontSize: 14.sp,
          color: AppColors.liveText,
        ),
        SizedBox(height: 10.h),

        /// Event Details
        CustomTextView(
          text: eventDetails,
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          color: AppColors.textBody,
        ),
        SizedBox(height: 10.h),

        /// --- PAYMENT SECTION ---
        _buildPaymentSection(context),
        SizedBox(height: 10.h),

        /// --- LINK SECTION ---
        if (displayLink != null && displayLink.isNotEmpty)
          GestureDetector(
            onTap: () => _copyToClipboard(displayLink),
            child: Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: AppColors.primaryColor.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.link, color: AppColors.primaryColor, size: 20.sp),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextView(
                          text: "Go to Live Event ($linkLabel)",
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.liveText,
                        ),
                        SizedBox(height: 4.h),
                        GestureDetector(
                          onTap: onTap,
                          child: CustomTextView(
                            text: displayLink,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.linkColor,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.copy, color: AppColors.primaryColor, size: 18.sp),
                ],
              ),
            ),
          ),
      ],
    );
  }

  /// PAYMENT SECTION LOGIC
  Widget _buildPaymentSection(BuildContext context) {
    if (isOwner) {
      return SizedBox.shrink(); // owners never see payment UI
    }

    // CASE A: Not owner & not paid → Pay Now
    if (!isPayment) {
      return GestureDetector(
        onTap: onTap, // open customPaymentSheet
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
          decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            children: [
              Icon(Icons.payment, color: Colors.green),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  "Pay \$$joiningFee",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.green,
                  ),
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16.sp, color: Colors.green),
            ],
          ),
        ),
      );
    }

    // CASE B: Not owner & already paid → Join Now
    return GestureDetector(
      onTap: onTap, // Navigate to Live
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        decoration: BoxDecoration(
          color: Colors.blue.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          children: [
            Icon(Icons.play_circle_fill, color: Colors.blue),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                "Join Now",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16.sp, color: Colors.blue),
          ],
        ),
      ),
    );
  }
}
