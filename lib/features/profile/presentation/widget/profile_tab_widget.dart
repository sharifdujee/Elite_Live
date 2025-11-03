import 'package:elites_live/features/profile/controller/profile_controller.dart';
import 'package:elites_live/features/profile/presentation/widget/scheduleTab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/utils/constants/app_colors.dart';
import '../../controller/profile_tab_controller.dart';
import 'build_grid_tab.dart';



class ProfileTabsWidget extends StatelessWidget {
  final controller = Get.put(ProfileTabsController());
  final ProfileController profileController = Get.put(ProfileController());

  // Replace with your actual icons


  ProfileTabsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        children: [
          // Tabs Row
          Container(
            padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTabItem(
                  index: 0,
                  activeIcon: controller.gridActive,
                  inactiveIcon: controller.gridInactive,
                ),
                _buildTabItem(
                  index: 1,
                  activeIcon: controller.calendarActive,
                  inactiveIcon: controller.calendarInactive,
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          // Tab Content
          controller.selectedIndex.value == 0
              ? BuildGridTab(imageList: profileController.imageList)
              : ScheduleTab(),
        ],
      ),
    );
  }

  /// 🔹 Each Tab Icon with Gradient Underline
  Widget _buildTabItem({
    required int index,
    required String activeIcon,
    required String inactiveIcon,
  }) {
    bool isActive = controller.selectedIndex.value == index;

    return GestureDetector(
      onTap: () => controller.selectedIndex.value = index,
      child: Column(
        children: [
          Image.asset(
            isActive ? activeIcon : inactiveIcon,
            height: 26.h,
            width: 26.w,
          ),
          SizedBox(height: 4.h),
          // Gradient underline for active tab
          AnimatedContainer(
            duration: const Duration(milliseconds: 25),
            height: 2.h,
            width: 50.w,
            decoration: BoxDecoration(
              gradient:
                  isActive
                      ? AppColors.primaryGradient
                      : const LinearGradient(
                        colors: [Colors.transparent, Colors.transparent],
                      ),
              borderRadius: BorderRadius.circular(20.r),
            ),
          ),
        ],
      ),
    );
  }
}
