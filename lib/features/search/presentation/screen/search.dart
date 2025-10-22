import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';


import '../../../../core/utils/constants/app_colors.dart';
import '../../controller/search_controller.dart';
import '../widget/all_tab_widget.dart';
import '../widget/live_tab_widgets.dart';
import '../widget/searchbar_widget.dart';
import '../widget/tab_widgets.dart';
import '../widget/user_tab_widget.dart';
import '../widget/video_tab_widgets.dart';


class Search extends StatelessWidget {
  Search({super.key});

  final controller = Get.put(SearchScreenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            //* Top header
            Stack(
              children: [
                Container(
                  height: 190.h,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: AppColors.primaryGradient,
                  ),
                ),
                Column(
                  children: [
                    CustomSearchBar(),
                    CustomTabBar(),
                    Container(
                      margin: EdgeInsets.only(top: 25.h),
                      padding: EdgeInsets.symmetric(horizontal: 25.w),
                      height: 560.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24.r),
                          topRight: Radius.circular(24.r),
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: Obx(() {
                          if (controller.selectedTab.value == 0) {
                            return AllTabBody();
                          } else if (controller.selectedTab.value == 1) {
                            return LiveTabBody();
                          } else if (controller.selectedTab.value == 2) {
                            return VideoTabWidget();
                          } else if (controller.selectedTab.value == 3) {
                            return UserTabWidget();
                          } else {
                            return SizedBox(height: 600.h);
                          }
                        })

                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
