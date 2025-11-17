
import 'package:elites_live/features/event/controller/event_controller.dart';
import 'package:elites_live/features/event/controller/schedule_controller.dart';
import 'package:elites_live/features/home/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/global_widget/custom_comment_sheet.dart';
import '../../../../core/global_widget/date_time_helper.dart';
import '../../../home/presentation/widget/designation_section.dart';
import '../../../home/presentation/widget/follow_section.dart';
import '../../../home/presentation/widget/live_indicator_section.dart';
import '../../../home/presentation/widget/nameBadgeSection.dart';


import '../widget/date_time_section.dart';
import '../widget/event_details_section.dart';
import '../widget/user_interaction_section.dart';

class EventScheduleScreen extends StatelessWidget {
  EventScheduleScreen({super.key});

  final HomeController controller = Get.find();
  final EventController eventController = Get.find();
  final ScheduleController scheduleController = Get.find();

  final RxString replyingToId = ''.obs;
  final RxString replyingToName = ''.obs;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (eventController.isLoading.value && eventController.eventList.isEmpty) {
        return Center(child: CircularProgressIndicator());
      }

      if (eventController.eventList.isEmpty) {
        return Center(child: Text('No events found'));
      }

      return RefreshIndicator(
        onRefresh: eventController.refreshEvents,
        child: ListView.separated(
          controller: eventController.scrollController,
          physics: BouncingScrollPhysics(),
          itemCount: eventController.eventList.length + 1, // +1 for loading indicator
          separatorBuilder: (context, index) {
            if (index >= eventController.eventList.length) {
              return SizedBox.shrink();
            }
            return Divider();
          },
          shrinkWrap: true,
          itemBuilder: (context, index) {
            // Show loading indicator at the bottom
            if (index >= eventController.eventList.length) {
              return Obx(() {
                if (eventController.isPaginationLoading.value) {
                  return Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                return SizedBox.shrink();
              });
            }

            // FIXED: Access event directly from the list
            final event = eventController.eventList[index];

            // Extract user data
            final firstName = event.user.firstName;
            final lastName = event.user.lastName;
            final userName = "$firstName $lastName";
            final userImage = event.user.profileImage;
            final profession = event.user.profession;
            final eventId = event.id;

            // Extract event data
            final about = event.text;
            final eventType = event.eventType;
            final joiningFee = event.payAmount.toString();

            // Format date and time
            final scheduleDateTime = DateTimeHelper.formatScheduleDateTime(event.scheduleDate.toIso8601String());
            final eventDate = scheduleDateTime['date']!;
            final eventTime = scheduleDateTime['time']!;
            final likeStatus = event.isLiked;

            // Calculate time ago
            final timeAgo = DateTimeHelper.getTimeAgo(event.createdAt.toIso8601String());

            // Counts
            final likeCount = event.count.eventLike;
            final commentCount = event.count.eventComment;

            // Live status (you may need to adjust this based on your logic)
            final isLive = index < controller.eventLive.length
                ? controller.eventLive[index]
                : false;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Live indicator
                    LiveIndicatorSection(
                      influencerProfile: userImage??'https://cdn2.psychologytoday.com/assets/styles/manual_crop_1_91_1_1528x800/public/field_blog_entry_images/2018-09/shutterstock_648907024.jpg?itok=7lrLYx-B',
                      isLive: isLive,
                    ),

                    SizedBox(width: 12.w),

                    /// Expanded wrapper to prevent overflow
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Name and badge
                          NameBadgeSection(userName: userName),
                          SizedBox(height: 4.h),

                          /// Designation and time ago
                          DesignationSection(
                            designation: profession??'',
                            timeAgo: timeAgo, // Pass time ago here
                          ),
                        ],
                      ),
                    ),

                    SizedBox(width: 8.w),

                    /// Follow and dot indicator section
                    FollowSection(index: index),
                  ],
                ),
                SizedBox(height: 16.h),

                /// Event date time section
                DateTimeSection(
                  eventDate: eventDate,
                  eventTime: eventTime,
                ),
                SizedBox(height: 10.h),

                /// Cloud Details Section
                EventDetailsSection(
                  eventDetails: about,
                  eventType: eventType,
                  joiningFee: joiningFee,
                ),

                SizedBox(height: 10.h),

                /// Like comment and share Section
                UserInteractionSection(
                  onLikeTap: (){

                    scheduleController.createLike(eventId);
                  },
                  isTip: false,
                  isLiked: likeStatus,
                  likeCount: likeCount.toString(),
                  commentCount: commentCount,
                  onCommentTap: (){
                    showModalBottomSheet(context: context, builder: (BuildContext context){
                      return CommentSheet(scheduleController: scheduleController, eventId: eventId);
                    });
                  },
                ),


              ],
            );
          },
        ),
      );
    });
  }
}









