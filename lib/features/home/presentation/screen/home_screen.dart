
import 'package:elites_live/features/home/controller/home_controller.dart';
import 'package:elites_live/features/home/presentation/widget/all_live_screen.dart';
import 'package:elites_live/features/home/presentation/widget/home_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/utils/constants/app_colors.dart';

import '../../../search/presentation/widget/all_tab_widget.dart';
import '../../../search/presentation/widget/live_tab_widgets.dart';

import '../../../search/presentation/widget/user_tab_widget.dart';
import '../../../search/presentation/widget/video_tab_widgets.dart';
import '../widget/top_header.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body:  SingleChildScrollView(
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
                      TopHeader(),
                      HomeTabBar(),
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
                                return AllLiveScreen();
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


