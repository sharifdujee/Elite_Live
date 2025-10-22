

import 'package:elites_live/features/home/controller/home_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class HomeTabBar extends StatelessWidget {
  final controller = Get.find<HomeController>();

  HomeTabBar({super.key});

  final tabs = ["All", "Following", "Live",];

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