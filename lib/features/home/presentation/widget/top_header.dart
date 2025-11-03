import 'dart:developer';

import 'package:elites_live/routes/app_routing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/global/custom_text_view.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/image_path.dart';
import '../../../profile/controller/profile_controller.dart';

import 'dart:developer';

import 'package:elites_live/routes/app_routing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/global/custom_text_view.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/image_path.dart';
import '../../../profile/controller/profile_controller.dart';

class TopHeader extends StatelessWidget {
  const TopHeader({
    super.key,
    this.isAdd = false,
    this.onTap,
  });
  final bool isAdd;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.find();
    return Container(
      margin: EdgeInsets.only(left: 8.w, right: 12.w, top: 61.h),
      child: Row(
        children: [
          // Profile Avatar
          Obx(() {
            final user = profileController.userinfo.value;

            if (user == null) {
              return CircleAvatar(
                radius: 24.r,
                backgroundImage: const AssetImage('assets/images/profile_image.jpg'),
              );
            }

            return CircleAvatar(
              radius: 24.r,
              backgroundImage: user.profileImage != null && user.profileImage!.isNotEmpty
                  ? NetworkImage(user.profileImage!)
                  : const AssetImage('assets/images/profile_image.jpg') as ImageProvider,
            );
          }),

          SizedBox(width: 8.w),

          // Name and Profession - Flexible to prevent overflow
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Obx(() {
                  final user = profileController.userinfo.value;

                  if (user == null) {
                    return Text(
                      'Jolie Topley',
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    );
                  }

                  return user.firstName.isNotEmpty
                      ? CustomTextView(
                    "${user.firstName} ${user.lastName}",
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
                      : Text(
                    'Jolie Topley',
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  );
                }),

                SizedBox(height: 2.h),

                Obx(() {
                  final user = profileController.userinfo.value;

                  if (user == null) {
                    return Text(
                      'Model',
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.white.withOpacity(0.8),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    );
                  }

                  return user.profession.isNotEmpty
                      ? CustomTextView(
                    user.profession,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.white.withOpacity(0.8),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
                      : Text(
                    'Model',
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.white.withOpacity(0.8),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  );
                }),
              ],
            ),
          ),

          SizedBox(width: 8.w),

          // Action Buttons - Fixed size
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isAdd) ...[
                GestureDetector(
                  onTap: () {
                    log("Hello, I try to navigate");
                    onTap!();
                  },
                  child: Container(
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100.r),
                    ),
                    child: Icon(
                      Icons.add,
                      size: 20.sp,
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
              ],

              GestureDetector(
                onTap: () {
                  Get.toNamed(AppRoute.group);
                },
                child: Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: AppColors.bgColor,
                    borderRadius: BorderRadius.circular(50.r),
                  ),
                  child: Icon(
                    FontAwesomeIcons.peopleGroup,
                    size: 18.sp,
                  ),
                ),
              ),

              SizedBox(width: 8.w),

              GestureDetector(
                onTap: () {
                  Get.toNamed(AppRoute.notification);
                },
                child: Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: AppColors.bgColor,
                    borderRadius: BorderRadius.circular(100.r),
                  ),
                  child: Icon(
                    FontAwesomeIcons.bell,
                    size: 18.sp,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}