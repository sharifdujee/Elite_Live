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
  });

  final String eventDetails;
  final String joiningFee;
  final String eventTitle;
  final bool isOwner;
  final String? hostLink;
  final String? audienceLink;

  // Helper method to copy link to clipboard
  void _copyToClipboard(String link, BuildContext context) {
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
    // Determine which link to display
    final String? displayLink = isOwner ? hostLink : audienceLink;
    final String linkLabel = isOwner ? "Host Link" : "Audience Link";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextView(
          text: eventTitle,
          fontWeight: FontWeight.w400,
          fontSize: 14.sp,
          color: AppColors.liveText,
        ),
        SizedBox(height: 10.h),
        CustomTextView(
          text: eventDetails,
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          color: AppColors.textBody,
        ),
        SizedBox(height: 10.h),
        CustomTextView(
          text: "Pay \$$joiningFee",
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          color: AppColors.liveText,
        ),
        SizedBox(height: 10.h),

        // Only show link if it exists
        if (displayLink != null && displayLink.isNotEmpty)
          GestureDetector(
            onTap: () => _copyToClipboard(displayLink, context),
            child: Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: AppColors.primaryColor.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.link,
                    color: AppColors.primaryColor,
                    size: 20.sp,
                  ),
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
                        CustomTextView(
                          text: displayLink,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.linkColor,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Icon(
                    Icons.copy,
                    color: AppColors.primaryColor,
                    size: 18.sp,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}