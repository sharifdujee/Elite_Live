import 'package:elites_live/features/group/presentation/widget/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/global_widget/custom_text_view.dart';
import '../../../../core/utils/constants/app_colors.dart';

class UserSection extends StatelessWidget {
  const UserSection({
    super.key,
    required this.groupName,

    required this.groupImage,
    required this.userProfession
  });

  final String groupName;
  final String userProfession;

  final String groupImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(


        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 28.sp,
            backgroundImage: AssetImage(groupImage), // Use the passed parameter
          ),

          SizedBox(width: 12.w),

          // Group Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextView(
                 text:      groupName,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textHeader,
                ),
                SizedBox(height: 4.h),
                CustomTextView(
                   text:    userProfession,
                  fontWeight: FontWeight.w400,
                  fontSize: 13.sp,
                  color: AppColors.textBody,
                ),


              ],
            ),

          ),

          /// Invite Button
          GradientButton(title: "Join Now",),

        ],
      ),
    );
  }
}