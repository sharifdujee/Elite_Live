import 'dart:developer';

import 'package:elites_live/core/utils/constants/app_colors.dart';
import 'package:elites_live/features/home/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/global/custom_text_view.dart';


class FollowSection extends StatelessWidget {
  final int index;

  FollowSection({super.key, required this.index});

  final HomeController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    final bool isFollowing = controller.isFollow[index];

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!isFollowing)
          GestureDetector(
            onTap: () {
              log("start following");
              // Update state logic here, e.g.:
              // controller.isFollow[index] = true;
              // controller.update(); // if using GetX
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: CustomTextView(
                "Follow",
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                textAlign: TextAlign.center,
                color: const Color(0xFF374151),
              ),
            ),
          ),
        SizedBox(width: 4.w),

        /// 3-dot popup
        PopupMenuButton<int>(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          color: Colors.white,
          elevation: 4,
          position: PopupMenuPosition.under,
          icon: Icon(
            Icons.more_vert,
            size: 22.sp,
            color: const Color(0xFF6B7280),
          ),
          itemBuilder: (context) {
            List<PopupMenuEntry<int>> items = [];

            if (isFollowing) {
              items.add(
                PopupMenuItem(
                  value: 0,
                  child: Row(
                    children: [
                      Icon(Icons.person_remove, size: 18.sp, color: AppColors.redColor),
                      SizedBox(width: 10.w),
                      CustomTextView("Unfollow", fontWeight: FontWeight.w500, fontSize: 14.sp, color: AppColors.redColor),
                    ],
                  ),
                ),
              );
            }

            items.addAll([
              PopupMenuItem(
                value: 1,
                child: Row(
                  children: [
                    Icon(Icons.block, size: 18.sp, color: Colors.black87),
                    SizedBox(width: 10.w),
                    CustomTextView("Not Interested", fontWeight: FontWeight.w500, fontSize: 14.sp, color: AppColors.textHeader),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 2,
                child: Row(
                  children: [
                    Icon(Icons.report_problem_outlined, size: 18.sp, color: Colors.black87),
                    SizedBox(width: 10.w),
                    CustomTextView("Report Channel", fontWeight: FontWeight.w500, fontSize: 14.sp, color: AppColors.textHeader),
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
    );
  }
}

