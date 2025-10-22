
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/utils/constants/icon_path.dart';
import '../../controller/search_controller.dart';

class AllTabBody extends StatelessWidget {
  final controller = Get.find<SearchScreenController>();
  AllTabBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      /// avoid
      ///height: 570.h,
      width: double.maxFinite,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Recent Section
          Padding(
            padding: EdgeInsets.only(top: 40.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Recent",
                  style: GoogleFonts.poppins(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D2D2D),
                  ),
                ),
                GestureDetector(
                  onTap: controller.clearHistory,
                  child: Text(
                    "Clear History",
                    style: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      color: const Color(0xFF636F85),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 40.h),
          Obx(() => Column(
            children: controller.recentList.map((name) {
              return _recentItem(name);
            }).toList(),
          )),
          SizedBox(height: 45.h),
      
          // Suggested Section
          Text(
            "Suggested",
            style: GoogleFonts.poppins(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D2D2D),
            ),
          ),
          SizedBox(height: 20.h),
          Column(
            children: controller.suggestedList.map((name) {
              return _suggestedItem(name);
            }).toList(),
          ),
          SizedBox(height: 40.h),
        ],
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
            child: Image.asset(
              IconPath.close,
              height: 20.h,
              width: 20.w,
            ),
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
