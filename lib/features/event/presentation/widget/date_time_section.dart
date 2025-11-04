import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/global_widget/custom_text_view.dart';
import '../../../../core/utils/constants/app_colors.dart';

class DateTimeSection extends StatelessWidget {
  const DateTimeSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomTextView(  text:   "Date: 25-08-2025", fontSize: 14.sp,fontWeight: FontWeight.w500,color: AppColors.textHeader,),
        CustomTextView(  text:   "11:00 PM", fontSize: 14.sp,fontWeight: FontWeight.w500,color: AppColors.textHeader,),



      ],
    );
  }
}