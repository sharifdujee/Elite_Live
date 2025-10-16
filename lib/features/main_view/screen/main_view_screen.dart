import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/utility/app_colors.dart';
import '../../../core/utility/icon_path.dart';
import '../controller/main_view_controller.dart';

class MainViewScreen extends StatelessWidget {
  MainViewScreen({super.key});

  final MainViewController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Obx(() => controller.currentPage),
      floatingActionButton: Obx(() {
        return FloatingActionButton(
          onPressed: () {
            controller.toggleFab();
            showDialog(
              context: context,
              builder: (context) =>
                  AlertDialog(
                    backgroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    title: const Text(
                      'Stream',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
            ).then((_) {
              controller.isFabActive.value = false;
            });
          },
          backgroundColor:
          controller.isFabActive.value
              ? AppColors.primaryColor
              : AppColors.white,
          shape: const CircleBorder(),
          child: Image.asset(
            IconPath.stream,
            fit: BoxFit.cover,
            color:
            controller.isFabActive.value
                ? AppColors.white
                : Colors.grey,
            width: 24.w,
            height: 24.h,
          ),
        );
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: Obx(
            () =>
            BottomAppBar(
              shape: const CircularNotchedRectangle(),
              notchMargin: 10,
              elevation: 5,
              color: AppColors.white,
              child: SizedBox(
                height: 70.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _bottomItem(
                      index: 0,
                      icon:
                      controller.currentIndex.value == 0
                          ? IconPath.homeActive
                          : IconPath.homeInactive,
                      label: "Home",
                    ),
                    _bottomItem(
                      index: 1,
                      icon:
                      controller.currentIndex.value == 1
                          ? IconPath.searchActive
                          : IconPath.searchInactive,
                      label: "Search",
                    ),
                    SizedBox(width: 40.w),
                    _bottomItem(
                      index: 2,
                      icon:
                      controller.currentIndex.value == 2
                          ? IconPath.eventActive
                          : IconPath.eventInactive,
                      label: "Event",
                    ),
                    _bottomItem(
                      index: 3,
                      icon:
                      controller.currentIndex.value == 3
                          ? IconPath.profileActive
                          : IconPath.profileInactive,
                      label: "Profile",
                    ),
                  ],
                ),
              ),
            ),
      ),
    );
  }

  Widget _bottomItem({
    required int index,
    required String icon,
    required String label,
  }) {
    return InkWell(
      onTap: () => controller.changePage(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 24.h,
            width: 24.w,
            child: Image.asset(icon, fit: BoxFit.contain),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color:
              controller.currentIndex.value == index
                  ? AppColors.primaryColor
                  : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
