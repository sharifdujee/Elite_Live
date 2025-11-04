import 'package:elites_live/core/global_widget/custom_text_view.dart';
import 'package:elites_live/core/utils/constants/app_colors.dart';
import 'package:elites_live/features/home/controller/home_controller.dart';
import 'package:elites_live/features/home/presentation/widget/video_player_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widget/designation_section.dart';
import '../widget/follow_section.dart';
import '../widget/live_description_section.dart';
import '../widget/live_indicator_section.dart';
import '../widget/nameBadgeSection.dart';
import '../widget/top_influence_section.dart';
import '../widget/video_interaction_section.dart';
import 'package:get/get.dart';


class AllLiveScreen extends StatelessWidget {
  const AllLiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find();
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.maxFinite,
            color: Colors.white,
            child: ListView.builder(
              itemCount: 5,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final description = controller.liveDescription[index];
                final userName = controller.influencerName[index];
                final userImage = controller.influencerProfile[index];
                final isLive = controller.isLive[index];

                return Container(
                  margin: EdgeInsets.only(left: 14.w, right: 14.w, top: 8.h),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// live indicator
                          LiveIndicatorSection(influencerProfile: userImage,isLive: isLive,),

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

                      /// video section
                      VideoPlayerSection(),

                      /// video details section
                      VideoInteractionSection(),
                      SizedBox(height: 12.h),

                      /// live description
                      LiveDescriptionSection(description: description),

                    ],
                  ),
                );
              },
            ),
          ),

          SizedBox(height: 32.h,),
          CustomTextView("Top Influencer Live", fontSize: 18.sp,fontWeight: FontWeight.w600,color: AppColors.textHeader,),
          SizedBox(height: 16.h,),
          SizedBox(
            height: 260.h,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context,index){
                  return TopInfluenceSection();
            }),
          )
        ],
      ),
    );
  }
}






