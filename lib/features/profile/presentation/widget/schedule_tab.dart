import 'package:elites_live/core/global_widget/custom_loading.dart';
import 'package:elites_live/core/global_widget/custom_text_view.dart';
import 'package:elites_live/core/utils/constants/app_colors.dart';
import 'package:elites_live/features/event/controller/schedule_controller.dart';
import 'package:elites_live/features/profile/controller/my_schedule_event_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'dart:developer';

import '../../../../core/global_widget/custom_comment_sheet.dart';
import '../../../event/presentation/widget/user_interaction_section.dart';

class EventScheduleTab extends StatelessWidget {
  const EventScheduleTab({super.key});

  @override
  Widget build(BuildContext context) {
    final MyScheduleEventController controller =
        Get.find();
    final ScheduleController scheduleController = Get.find();

    return Obx(() {
      log(
        'EventScheduleTab rebuild - isLoading: ${controller.isLoading.value}',
      );
      log(
        'EventScheduleTab rebuild - list length: ${controller.myEventScheduleList.length}',
      );

      if (controller.isLoading.value) {
        return SizedBox(
          height: 200.h,
          child: Center(child: CustomLoading(color: AppColors.primaryColor)),
        );
      }

      if (controller.myEventScheduleList.isEmpty) {
        log('EventScheduleTab: List is empty, showing empty state');
        return SizedBox(
          height: 200.h,
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 40.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.event_busy, size: 64.sp, color: Colors.grey[400]),
                  SizedBox(height: 16.h),
                  Text(
                    "No Schedule Available",
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    "Your scheduled events will appear here",
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }

      // Get the first schedule result
      final scheduleResult = controller.myEventScheduleList.first;
      log('EventScheduleTab: Events count: ${scheduleResult.events.length}');

      if (scheduleResult.events.isEmpty) {
        return SizedBox(
          height: 200.h,
          child: Center(
            child: Text(
              "No events found",
              style: GoogleFonts.inter(fontSize: 14.sp),
            ),
          ),
        );
      }

      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        itemCount: scheduleResult.events.length,
        separatorBuilder: (context, index) => SizedBox(height: 16.h),
        itemBuilder: (context, index) {
          final event = scheduleResult.events[index];

          // Format date and time
          String formattedDate = DateFormat(
            'dd-MM-yyyy',
          ).format(event.scheduleDate);
          String formattedTime = DateFormat(
            'hh:mm a',
          ).format(event.scheduleDate);

          return Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Color(0xFFE8E8E8), width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Date and Time Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomTextView(
                      text: formattedDate,

                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textHeader,
                    ),
                    CustomTextView(
                      text: formattedTime,

                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textHeader,
                    ),
                  ],
                ),

                SizedBox(height: 12.h),

                /// Event Title
                CustomTextView(
                  text: event.eventType,

                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textHeader,

                ),

                SizedBox(height: 8.h),

                /// Event Description
                CustomTextView(
                text:   event.text,

                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textBody,


                ),

                SizedBox(height: 12.h),

                /// Pay Amount
                if (event.payAmount > 0) ...[
                  Text(
                    "Pay \$${event.payAmount.toStringAsFixed(event.payAmount % 1 == 0 ? 0 : 2)}",
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF191919),
                    ),
                  ),
                  SizedBox(height: 8.h),
                ],

                /// Go to Live Event Link (if available - you can add a field for this)
                // For now, showing a placeholder
                RichText(
                  text: TextSpan(
                    text: "Go to Live Event: ",
                    style: GoogleFonts.inter(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF191919),
                    ),
                    children: [
                      TextSpan(
                        text: "Click here to join",
                        style: GoogleFonts.inter(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF007AFF),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 16.h),

                /// Reaction Row


                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                  child: UserInteractionSection(
                    onLikeTap: (){
                      scheduleController.createLike(event.id);
                    },
                    eventType: event.eventType,
                    isLiked: event.isLiked,
                    likeCount: event.count.eventLike.toString(),
                    commentCount: event.count.eventComment,
                    onCommentTap: (){
                      showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context){
                            return CommentSheet(
                                scheduleController: scheduleController,
                                eventId: event.id
                            );
                          }
                      );
                    },
                    isOwner: true,
                  ),
                ),
              ],
            ),
          );
        },
      );
    });
  }

  /// Helper method to format large numbers (4.5M, 25.2K, etc.)

}
