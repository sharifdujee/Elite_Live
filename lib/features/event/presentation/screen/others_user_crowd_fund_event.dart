import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/global_widget/custom_loading.dart';
import '../../../../core/global_widget/custom_text_view.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../controller/schedule_controller.dart';
import 'package:intl/intl.dart';

class OthersUserCrowdScreen extends StatelessWidget {
  OthersUserCrowdScreen({super.key, this.userId});

  final String? userId;
  final ScheduleController controller = Get.find();

  String formatDate(DateTime date) {
    return DateFormat('dd-MM-yyyy').format(date);
  }

  String formatTime(DateTime date) {
    return DateFormat('hh:mm a').format(date);
  }

  Future<void> launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    Future.microtask(() => controller.getOthersUserCrowdEvent(userId!));

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CustomLoading(color: AppColors.primaryColor),
          );
        }

        if (controller.othersUserFundingResult.isEmpty) {
          return const Center(
            child: CustomTextView(text: "No Schedule Event Found"),
          );
        }

        final result = controller.othersUserFundingResult.first;

        return ListView.builder(
          padding: EdgeInsets.all(16.w),
          itemCount: result.events.length,
          itemBuilder: (context, index) {
            final event = result.events[index];
            final streamLink = event.isOwner
                ? event.stream.hostLink
                : event.stream.audienceLink;

            return Container(
              margin: EdgeInsets.only(bottom: 16.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: Colors.blue.shade200,
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.1),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with Date and Time
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12.r),
                        topRight: Radius.circular(12.r),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomTextView(
                          text: 'Date: ${formatDate(event.scheduleDate!)}',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                        CustomTextView(
                          text: formatTime(event.scheduleDate!),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryColor,
                        ),
                      ],
                    ),
                  ),

                  // Content
                  Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        CustomTextView(
                          text: event.title,
                          fontWeight: FontWeight.w600,
                          fontSize: 18.sp,
                          color: Colors.black,
                        ),
                        SizedBox(height: 12.h),

                        // Description
                        CustomTextView(
                          text: event.text,
                          fontWeight: FontWeight.w400,
                          fontSize: 14.sp,
                          color: Colors.grey.shade700,
                          maxLines: 10,
                        ),
                        SizedBox(height: 16.h),

                        // Pay Amount
                        if (event.payAmount > 0)
                          Padding(
                            padding: EdgeInsets.only(bottom: 12.h),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 6.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green.shade50,
                                borderRadius: BorderRadius.circular(8.r),
                                border: Border.all(
                                  color: Colors.green.shade200,
                                ),
                              ),
                              child: CustomTextView(
                                text: 'Pay \$${event.payAmount}',
                                fontWeight: FontWeight.w600,
                                fontSize: 14.sp,
                                color: Colors.green.shade700,
                              ),
                            ),
                          ),

                        // Live Event Link Button
                        InkWell(
                          onTap: () => launchURL(streamLink),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 8.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      CustomTextView(
                                        text: 'Go to Live Event:',
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12.sp,
                                        color: Colors.grey.shade600,
                                      ),
                                      SizedBox(height: 4.h),
                                      CustomTextView(
                                        text: streamLink,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 11.sp,
                                        color: Colors.blue.shade700,
                                        maxLines: 1,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Footer with Stats
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(12.r),
                        bottomRight: Radius.circular(12.r),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          event.isLiked ? Icons.favorite : Icons.favorite_border,
                          color: Colors.red,
                          size: 20.sp,
                        ),
                        SizedBox(width: 4.w),
                        CustomTextView(
                          text: _formatCount(event.count.eventLike),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        SizedBox(width: 24.w),
                        Icon(
                          Icons.chat_bubble_outline,
                          color: Colors.grey.shade600,
                          size: 20.sp,
                        ),
                        SizedBox(width: 4.w),
                        CustomTextView(
                          text: _formatCount(event.count.eventComment),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        const Spacer(),
                        Icon(
                          Icons.share_outlined,
                          color: Colors.grey.shade600,
                          size: 20.sp,
                        ),
                        SizedBox(width: 4.w),
                        CustomTextView(
                          text: 'Share',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade600,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }
}