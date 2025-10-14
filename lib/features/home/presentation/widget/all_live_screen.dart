import 'package:elites_live/core/global/custom_text_view.dart';
import 'package:elites_live/core/utils/constants/app_colors.dart';
import 'package:elites_live/core/utils/constants/image_path.dart';
import 'package:elites_live/features/home/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/utils/constants/icon_path.dart';

class AllLiveScreen extends StatelessWidget {
  final controller = Get.find<HomeController>();
  AllLiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      /// avoid
      ///height: 570.h,
      width: double.maxFinite,
      color: Colors.white,
      child: ListView.builder(
        itemCount: 5,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(left: 24.w, right: 24.w, top: 8.h),
            child: Column(
              children: [
                Row(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 30.r,
                          backgroundImage: AssetImage(ImagePath.user),
                        ),
                        Positioned(
                          bottom: 0.h,
                            left: 8.w,

                            child: Container(

                              padding: EdgeInsets.symmetric(horizontal: 8.h,vertical: 4.h),
                              decoration: BoxDecoration(
                                color: AppColors.liveColor,
                                borderRadius: BorderRadius.circular(4.r)
                                
                              ),
                                child: CustomTextView('Live', color: AppColors.white,fontWeight: FontWeight.w500,fontSize: 14.sp)))
                      ],
                    ),
                    
                    SizedBox(width: 12.w,),
                    Column(
                      children: [
                        CustomTextView("Ethan Walker", fontSize: 16.sp,fontWeight: FontWeight.w600,color: AppColors.textHeader,)
                      ],
                    )
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _recentItem(String name) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset(
                IconPath.clock, // clock icon PNG
                height: 16.h,
                width: 16.w,
              ),
              SizedBox(width: 10.w),
              Text(
                name,
                style: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF636F85),
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () => controller.removeRecentItem(name),
            child: Image.asset(IconPath.close, height: 20.h, width: 20.w),
          ),
        ],
      ),
    );
  }

  Widget _suggestedItem(String name) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: GoogleFonts.poppins(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF636F85),
            ),
          ),
          Image.asset(
            IconPath.search1, // magnifier PNG
            height: 16.h,
            width: 16.w,
          ),
        ],
      ),
    );
  }
}
