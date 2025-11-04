import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/global_widget/custom_text_view.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/icon_path.dart';

class DesignationSection extends StatelessWidget {
  const DesignationSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomTextView(
         text:      "Influencer",
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          color: AppColors.textBody,
        ),
        SizedBox(width: 3.w),
        Image.asset(
          IconPath.dot,
          fit: BoxFit.cover,
          width: 5.w,
          height: 5.h,
        ),
        SizedBox(width: 3.w),
        CustomTextView(
         text:      "5h",
          fontWeight: FontWeight.w400,
          fontSize: 14.sp,
          color: AppColors.textBody,
        ),
      ],
    );
  }
}