import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/global_widget/custom_text_view.dart';
import '../../../../core/utils/constants/app_colors.dart';


class LiveIndicatorSection extends StatelessWidget {
  const LiveIndicatorSection({
    super.key,
    required this.influencerProfile,
    required this.isLive,
  });
  final String influencerProfile;
  final bool isLive;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 30.r,
          backgroundImage: AssetImage(influencerProfile),
        ),
        Positioned(
          bottom: -6.h, // Align to the bottom
          left: 50.w - 40.r, // Center horizontally relative to CircleAvatar radius
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 8.h,
              vertical: 4.h,
            ),
            decoration: BoxDecoration(
              color: AppColors.liveColor,
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: isLive?
            CustomTextView(
              'Live',
              color: AppColors.white,
              fontWeight: FontWeight.w500,
              fontSize: 14.sp,
            ):SizedBox.shrink(),
          ),
        ),
      ],
    );
  }
}