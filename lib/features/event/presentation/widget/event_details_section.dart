import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/global_widget/custom_text_view.dart';
import '../../../../core/utils/constants/app_colors.dart';
class EventDetailsSection extends StatelessWidget {
  const EventDetailsSection({
    super.key,
    required this.eventDetails,
    required this.eventType,
    required this.joiningFee

  });
  final String eventDetails;
  final String eventType;
  final String joiningFee;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextView(  text:   eventType, fontWeight: FontWeight.w400,fontSize: 14.sp,color: AppColors.liveText,),
        SizedBox(height: 10.h,),
        CustomTextView(  text:   eventDetails, fontSize: 14.sp,fontWeight: FontWeight.w400,color: AppColors.textBody,),
        SizedBox(height: 10.h,),

        CustomTextView(  text:   "Pay \$$joiningFee", fontSize: 14.sp,fontWeight: FontWeight.w500,color: AppColors.liveText,),
        SizedBox(height: 10.h,),
        RichText(text: TextSpan(
            children: [
              TextSpan(
                  text: "Go to Live Event:",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                      color: AppColors.liveText
                  )
              ),
              TextSpan(
                  text: "https://fiverrzoom.zoom.us/j/86189047244?",
                  style: TextStyle(
                      color: AppColors.linkColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      decoration: TextDecoration.underline


                  )
              )

            ]
        )),
      ],
    );
  }
}