import 'package:elites_live/core/global/custom_text_view.dart';
import 'package:elites_live/core/utils/constants/app_colors.dart';
import 'package:elites_live/features/home/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
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
   final RxString replyingToId = ''.obs;
   final RxString replyingToName = ''.obs;


  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: BouncingScrollPhysics(),
      itemCount: controller.influencerName.length,
      separatorBuilder: (context,index){
        return Divider();
      },
      shrinkWrap: true,
        itemBuilder: (context,index){
        final userName = controller.influencerName[index];
        final userImage = controller.influencerProfile[index];
        final isLive = controller.eventLive[index];
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// live indicator
              LiveIndicatorSection(influencerProfile: userImage, isLive: isLive,),

              SizedBox(width: 12.w),

              /// Expanded wrapper to prevent overflow
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// name and badge
                    NameBadgeSection(userName: userName,),
                    SizedBox(height: 4.h),

                    /// designation and hours before live
                    DesignationSection(),
                  ],
                ),
              ),

              SizedBox(width: 8.w),

              /// follow and dot indicator section
              FollowSection(index: index),
            ],
          ),
          SizedBox(height: 16.h,),

          /// event data time section
          DateTimeSection(),
          SizedBox(height: 10.h,),

          /// Cloud Details Section
          EventDetailsSection(),

          SizedBox(height: 10.h,),
          /// like comment and share Section
          UserInteractionSection(),



        ],

      );
    });
  }
}









