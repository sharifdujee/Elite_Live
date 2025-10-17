
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/global/custom_text_view.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/image_path.dart';

class NameBadgeSection extends StatelessWidget {
  const NameBadgeSection({
    super.key,
    required this.userName,

  });
  final String userName;


  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: CustomTextView(
            userName,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textHeader,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),

        /// display badge
        SizedBox(width: 6.w),
        Image.asset(
          ImagePath.badge,
          height: 15.h,
          width: 15.w,
          fit: BoxFit.cover,
        ),
      ],
    );
  }
}