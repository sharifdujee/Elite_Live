import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controller/search_controller.dart';

class CustomTabBar extends StatelessWidget {
  final controller = Get.find<SearchScreenController>();

  CustomTabBar({super.key});

  final tabs = ["All", "Live", "Video", "User"];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 15.h),
      child: Obx(() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(tabs.length, (index) {
          final selected = controller.selectedTab.value == index;
          return GestureDetector(
            onTap: () => controller.onTabSelected(index),
            child: Column(
              children: [
                Text(
                  tabs[index],
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    fontWeight:
                    selected ? FontWeight.w600 : FontWeight.w400,
                    color: selected
                        ? Colors.white
                        : Colors.white.withOpacity(0.7),
                  ),
                ),
                SizedBox(height: 5.h),
                Container(
                  height: 2.h,
                  width: 35.w,
                  color: selected ? Colors.white : Colors.transparent,
                )
              ],
            ),
          );
        }),
      )),
    );
  }
}
