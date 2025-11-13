import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/global_widget/custom_text_view.dart';
import '../../../../core/utils/constants/app_colors.dart';

class CloudFundingDetails extends StatelessWidget {
  const CloudFundingDetails({super.key, required this.eventDescription});
  final  String eventDescription;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextView(  text:   "Hey fam!", fontWeight: FontWeight.w400,fontSize: 14.sp,color: AppColors.liveText,),
        SizedBox(height: 10.h,),
        CustomTextView(  text:   eventDescription, fontSize: 14.sp,fontWeight: FontWeight.w400,color: AppColors.textBody,),
        SizedBox(height: 10.h,),


      ],
    );
  }
}