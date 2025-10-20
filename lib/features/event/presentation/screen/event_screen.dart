
import 'package:elites_live/features/event/controller/event_controller.dart';
import 'package:elites_live/features/event/presentation/screen/cloud_funding_screen.dart';
import 'package:elites_live/features/event/presentation/screen/event_schedule_screen.dart';
import 'package:elites_live/features/event/presentation/widget/event_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../home/presentation/screen/all_live_screen.dart';
import '../../../home/presentation/screen/following_screen.dart';
import '../../../home/presentation/widget/top_header.dart';

class EventScreen extends StatelessWidget {
   const EventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final EventController controller = Get.find();
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
                    TopHeader(isAdd: true,),
                    EventTabBar(),
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
                              return EventScheduleScreen();
                            } else if (controller.selectedTab.value == 1) {
                              return CloudFundingScreen();
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
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
