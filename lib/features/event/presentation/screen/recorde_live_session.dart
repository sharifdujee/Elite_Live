import 'package:elites_live/core/global_widget/custom_loading.dart';
import 'package:elites_live/core/global_widget/custom_text_view.dart';
import 'package:elites_live/core/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/global_widget/full_screen_video_player.dart';
import '../../../../core/global_widget/video_thumbnail_card.dart';
import '../../controller/schedule_controller.dart';

class RecordedLiveSession extends StatelessWidget {
  RecordedLiveSession({super.key, required this.userId});

  final String userId;
  final ScheduleController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    Future.microtask(() => controller.getOthersUserScheduleEvent(userId));

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Obx(() {
        // Loading State
        if (controller.isLoading.value) {
          return Center(
            child: CustomLoading(color: AppColors.primaryColor),
          );
        }

        // Empty State
        if (controller.otherScheduleEvent.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.video_library_outlined,
                  size: 80.sp,
                  color: Colors.grey.shade400,
                ),
                SizedBox(height: 16.h),
                CustomTextView(
                  text: "No Recorded Sessions Found",
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade600,
                ),
              ],
            ),
          );
        }

        final result = controller.otherScheduleEvent.first;
        final events = result.events;

        // Empty events list
        if (events.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.video_library_outlined,
                  size: 80.sp,
                  color: Colors.grey.shade400,
                ),
                SizedBox(height: 16.h),
                CustomTextView(
                  text: "No Recorded Videos Available",
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade600,
                ),
              ],
            ),
          );
        }

        // Grid View with Videos
        return GridView.builder(
          padding: EdgeInsets.all(8.w),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8.w,
            mainAxisSpacing: 8.h,
            childAspectRatio: 0.7,
          ),
          itemCount: events.length,
          itemBuilder: (context, index) {
            final event = events[index];
            // Use default video if recordedLink is null or empty
            final videoUrl = (event.recordedLink.isEmpty)
                ? 'https://cdn.pixabay.com/video/2016/08/16/4841-180474205_large.mp4'
                : event.recordedLink;

            return VideoThumbnailCard(
              videoUrl: videoUrl,
              title: event.title,
              duration: event.scheduleDate,
              onTap: () {
                // Navigate to full screen video player
                Get.to(() => FullScreenVideoPlayer(
                  videoUrl: videoUrl,
                  title: event.title,
                  description: event.text,
                ));
              },
            );
          },
        );
      }),
    );
  }
}





