import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/global/custom_text_view.dart';
import '../../../../core/utils/constants/app_colors.dart';

class CloudFundingDetails extends StatelessWidget {
  const CloudFundingDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextView("Hey fam!", fontWeight: FontWeight.w400,fontSize: 14.sp,color: AppColors.liveText,),
        SizedBox(height: 10.h,),
        CustomTextView("We’ve got a big event coming up and we’d love your support Drop a tip, cheer or contribution to help us hit our goal Every little bit counts — let’s make this event epic together! ", fontSize: 14.sp,fontWeight: FontWeight.w400,color: AppColors.textBody,),
        SizedBox(height: 10.h,),


      ],
    );
  }
}