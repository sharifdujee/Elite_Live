import 'package:elites_live/core/global/custom_text_view.dart';
import 'package:elites_live/core/utils/constants/app_colors.dart';
import 'package:elites_live/core/utils/constants/image_path.dart';
import 'package:elites_live/features/home/controller/home_controller.dart';
import 'package:elites_live/features/home/presentation/widget/video_player_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widget/designation_section.dart';
import '../widget/follow_section.dart';
import '../widget/live_description_section.dart';
import '../widget/live_indicator_section.dart';
import '../widget/nameBadgeSection.dart';
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
                          FollowSection(),
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
                  return Container(
                    width: 180.w,
                    margin: EdgeInsets.only(right: 12.w, left: index == 0 ? 14.w : 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image container with LIVE badge
                        Container(
                          height: 200.h,
                          width: 180.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
                            color: Colors.grey[200],
                          ),
                          child: Stack(
                            children: [
                              // Column of three images
                              ClipRRect(
                                borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: Image.asset(
                                        ImagePath.one, // top image
                                        width: 180.w,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Expanded(
                                      child: Image.asset(
                                        ImagePath.two, // middle image
                                        width: 180.w,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Expanded(
                                      child: Image.asset(
                                        ImagePath.three, // bottom image
                                        width: 180.w,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // LIVE badge
                              Positioned(
                                top: 8.h,
                                left: 8.w,
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                                  decoration: BoxDecoration(
                                    color: Color(0xFFFF3B30),
                                    borderRadius: BorderRadius.circular(4.r),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 5.w,
                                        height: 5.h,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      SizedBox(width: 4.w),
                                      Text(
                                        'LIVE',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 0.5,
                                          height: 1.2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),


                        // Text content
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomTextView(
                                "Tell me what excites...",
                                fontWeight: FontWeight.w500,
                                fontSize: 13.sp,
                                color: AppColors.textHeader,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 4.h),
                              CustomTextView(
                                "50k Watching",
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textBody,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
            }),
          )
        ],
      ),
    );
  }
}




