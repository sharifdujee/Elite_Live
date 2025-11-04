import 'package:elites_live/features/home/presentation/widget/donation_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/global_widget/custom_text_view.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../home/presentation/widget/share_sheet.dart';

class UserInteractionSection extends StatelessWidget {
  const UserInteractionSection({
    super.key,
    this.isTip = false
  });

  final  bool isTip;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(Icons.favorite_outline),
            SizedBox(width: 4.w),
            CustomTextView(  text:   "4.5M",
                fontWeight: FontWeight.w500,
                fontSize: 14.sp,
                color: AppColors.textHeader),
          ],
        ),
        Row(
          children: [
            Icon(FontAwesomeIcons.comment),
            SizedBox(width: 4.w),
            CustomTextView(  text:   "25.2k",
                fontWeight: FontWeight.w500,
                fontSize: 14.sp,
                color: AppColors.textHeader),
          ],
        ),
        GestureDetector(
          onTap: () {
            ShareSheet().show(context);
          },
          child: Row(
            children: [
              Icon(FontAwesomeIcons.share),
              SizedBox(width: 4.w),
              CustomTextView(  text:   "Share",
                  fontWeight: FontWeight.w500,
                  fontSize: 14.sp,
                  color: AppColors.textHeader),
            ],
          ),
        ),
        isTip?GestureDetector(
          onTap: (){
            DonationSheet().show(context);
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              gradient: LinearGradient(colors: [
                AppColors.secondaryColor,
                AppColors.primaryColor
              ])
            ),
            child: CustomTextView(  text:   "Tips", color: AppColors.textWhite,fontWeight: FontWeight.w600,fontSize: 12.sp,),
          ),
        ):SizedBox.shrink()
      ],
    );
  }
}