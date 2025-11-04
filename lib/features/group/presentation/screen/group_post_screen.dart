

import 'dart:developer';


import 'package:elites_live/core/utils/constants/image_path.dart';
import 'package:elites_live/features/group/presentation/widget/gradient_button.dart';
import 'package:elites_live/routes/app_routing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../../core/global_widget/custom_text_field.dart';
import '../../../../core/global_widget/custom_text_view.dart';
import '../../../../core/global_widget/custom_elevated_button.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../home/controller/home_controller.dart';
import '../widget/group_post_section.dart';

class GroupPostScreen extends StatelessWidget {
  GroupPostScreen({super.key});

  final HomeController controller = Get.find<HomeController>();
  final RxString replyingToId = ''.obs;
  final RxString replyingToName = ''.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Column(
        children: [
          /// Gradient Header
          Container(
            height: 130.h,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 24.sp,
                      ),
                    ),
                    CustomTextView(
                      text:     "Group Post",
                      fontWeight: FontWeight.w600,
                      fontSize: 20.sp,
                      color: AppColors.white,
                    ),
                    PopupMenuButton<int>(
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      color: Colors.white,
                      elevation: 4,
                      position: PopupMenuPosition.under,
                      icon: Container(
                        ///padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                        

                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(100.r),
                          border: Border.all(
                            width: 1.5,
                            color: AppColors.white
                          )

                        ),
                        child: Icon(
                          Icons.more_vert,
                          size: 22.sp,
                          color: const Color(0xFF6B7280),
                        ),
                      ),
                      itemBuilder: (context) {
                        List<PopupMenuEntry<int>> items = [];



                        items.addAll([
                          PopupMenuItem(
                            value: 1,
                            child: Row(
                              children: [

                                SizedBox(width: 10.w),
                                CustomTextView(  text:   "Edit", fontWeight: FontWeight.w500, fontSize: 14.sp, color: AppColors.textHeader),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 2,
                            child: Row(
                              children: [

                                SizedBox(width: 10.w),
                                CustomTextView(  text:   "Delete", fontWeight: FontWeight.w500, fontSize: 14.sp, color: AppColors.textHeader),
                              ],
                            ),
                          ),
                        ]);

                        return items;
                      },
                      onSelected: (value) {
                        switch (value) {
                          case 0:
                            log("User clicked Unfollow");
                            // Unfollow logic:
                            // controller.isFollow[index] = false;
                            // controller.update(); // if using GetX
                            break;
                          case 1:
                            log("User clicked Not Interested");
                            break;
                          case 2:
                            log("User clicked Report Channel");
                            break;
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),

          /// White Card Container
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 50.r,
                      backgroundImage: AssetImage(ImagePath.dance),
                    ),
                    SizedBox(height: 7.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomTextView(
                           text:    "Dance Club",
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textHeader,
                        ),
                        GradientButton(title: "Leave Group", onTap: (){
                          _showLeaveConfirmation(context);
                        },),
                      ],
                    ),
                    SizedBox(height: 24.h),
                    CustomTextView(
                       text:    "Join us for a special live stream where 🎶 Arif will be performing his favorite acoustic covers and interacting with fans in real time! Don’t miss the chance to request your song.",
                      fontWeight: FontWeight.w400,
                      fontSize: 14.sp,
                      color: AppColors.textBody,
                    ),
                    SizedBox(height: 24.h),
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: AssetImage(ImagePath.three),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {

                              Get.toNamed(AppRoute.createPost);
                            },
                            child: AbsorbPointer(
                              absorbing: true,
                              child: CustomTextField(
                                hintText: "Write something",
                                isReadonly: true,
                              ),
                            ),
                          ),
                        )

                      ],
                    ),
                    SizedBox(height: 24.h),

                    /// post section
                    GroupPostSection(
                      replyingToId: replyingToId,
                      replyingToName: replyingToName,
                      controller: controller,
                    ),

                    /// Comments Section
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLeaveConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100.r),
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF591AD4).withValues(alpha: 0.1),
                      AppColors.primaryColor.withValues(alpha: 0.1),
                    ],
                  ),
                ),
                child: ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [
                      Color(0xFF591AD4),
                      AppColors.primaryColor,
                    ],
                  ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                  child: Icon(
                    FontAwesomeIcons.check,
                    size: 33.h,
                    color: Colors.white,  // color must be white or solid for ShaderMask to work properly
                  ),
                ),
              ),
             CustomTextView(  text:   "Leave Group", fontSize: 18.sp,fontWeight: FontWeight.w600,color: AppColors.textHeader,),

            ],
          ),
          content: CustomTextView(  text:   "Are you sure you want to leave group?", fontWeight: FontWeight.w500,fontSize: 14.sp,color: AppColors.textBody,textAlign: TextAlign.center,),
          actions: [
            Row(
              children: [
                Expanded(child: CustomElevatedButton(ontap: (){
                 Get.back();
                }, text: "Cancel")),
                SizedBox(width: 8.w,),
                Expanded(child: CustomElevatedButton(ontap: (){}, text: "Leave", backgroundColor: AppColors.white,textColor: AppColors.primaryColor,)),

              ],
            ),

          ],
        );
      },
    );
  }

}
