import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/global_widget/custom_text_view.dart';
import '../../../../core/utils/constants/app_colors.dart';

class DateTimeSection extends StatelessWidget {
  const DateTimeSection({
    super.key,
    required this.eventDate,
    required this.eventTime
  });
  final String eventDate;
  final String eventTime;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomTextView(  text:   "Date: $eventDate", fontSize: 14.sp,fontWeight: FontWeight.w500,color: AppColors.textHeader,),
        CustomTextView(  text:   eventTime, fontSize: 14.sp,fontWeight: FontWeight.w500,color: AppColors.textHeader,),



      ],
    );
  }
}