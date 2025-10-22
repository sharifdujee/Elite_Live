import 'dart:developer';

import 'package:elites_live/routes/app_routing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../../core/global/custom_text_view.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/image_path.dart';

class TopHeader extends StatelessWidget {
  const TopHeader({
    super.key,
    this.isAdd = false,
    this.onTap,
  });
  final bool isAdd;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 24.w, right: 12.w, top: 61.h),
      child: Row(
        children: [

          CircleAvatar(
            radius: 30.r,
            backgroundImage: AssetImage(ImagePath.user),),
          SizedBox(width: 8.w,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextView('Jolie Topley', fontWeight: FontWeight.w600,fontSize: 14.sp,color: AppColors.white,),
              SizedBox(height: 2.h,),
              CustomTextView("Model", fontSize: 12.sp,fontWeight: FontWeight.w400,color: AppColors.professionColor,)
            ],
          ),
          SizedBox(width: 37.w,),
          isAdd?GestureDetector(
            onTap: (){
              log("Hello, I try to navigate");
              onTap!();
            },
            child: Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100.r)
              ),
              child: Icon(Icons.add),

            ),
          ):SizedBox.shrink(),
          SizedBox(width: 16.w,),
          GestureDetector(
            onTap: (){
              Get.toNamed(AppRoute.group);
            },
            child: Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: AppColors.bgColor,
                borderRadius: BorderRadius.circular(50.r),
              ),
              child: Icon(FontAwesomeIcons.peopleGroup)
            ),
          ),
          SizedBox(width: 16.w,),

          GestureDetector(
            onTap: (){
              Get.toNamed(AppRoute.notification);
            },
            child: Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: AppColors.bgColor,
                borderRadius: BorderRadius.circular(100.r),
              ),
              child: Icon(FontAwesomeIcons.bell),
            ),
          ),

        ],
      ),
    );
  }
}