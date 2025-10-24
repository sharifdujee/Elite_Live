import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/utils/constants/app_colors.dart';

class ProfileTabsController extends GetxController {
  RxInt selectedIndex = 0.obs;
}

class ProfileTabsWidget extends StatelessWidget {
  final controller = Get.put(ProfileTabsController());

  // Replace with your actual icons
  final String gridActive = 'assets/icons/grid_active.png';
  final String gridInactive = 'assets/icons/grid_inactive.png';
  final String calendarActive = 'assets/icons/calendar_active.png';
  final String calendarInactive = 'assets/icons/calender_inactive.png';

  ProfileTabsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
      children: [
        // Tabs Row
        Container(
          padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 12.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTabItem(
                index: 0,
                activeIcon: gridActive,
                inactiveIcon: gridInactive,
              ),
              _buildTabItem(
                index: 1,
                activeIcon: calendarActive,
                inactiveIcon: calendarInactive,
              ),
            ],
          ),
        ),
        SizedBox(height: 10.h),
        // Tab Content
        controller.selectedIndex.value == 0
            ? _buildGridTab()
            : _buildScheduleTab(),
      ],
    ));
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
              gradient: isActive
                  ? AppColors.primaryGradient
                  : const LinearGradient(colors: [Colors.transparent, Colors.transparent]),
              borderRadius: BorderRadius.circular(20.r),
            ),
          ),
        ],
      ),
    );
  }

  /// 🔸 Grid Tab
  Widget _buildGridTab() {
    final List<String> imageList = [
      'assets/images/event1.png',
      'assets/images/live2.png',
      'assets/images/live3.png',
      'assets/images/live4.png',
      'assets/images/live5.png',
      'assets/images/live6.png',
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: imageList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisExtent: 140.h,
          crossAxisSpacing: 8.w,
          mainAxisSpacing: 10.h,
        ),
        itemBuilder: (context, index) {
          return Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: Image.asset(
                  imageList[index],
                  fit: BoxFit.cover,
                  height: double.infinity,
                  width: double.infinity,
                ),
              ),
              Positioned(
                top: 5,
                left: 5,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.people_alt, color: Colors.white, size: 12.sp),
                      SizedBox(width: 3.w),
                      Text(
                        "5.6k",
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// 🔸 Schedule Tab
  Widget _buildScheduleTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Date and Time Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Date: 25-08-2025",
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF191919),
              ),
            ),
            Text(
              "11:00 PM",
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF191919),
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),

        Text(
          "Event Schedule is Live!",
          style: GoogleFonts.inter(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF191919),
          ),
        ),
        SizedBox(height: 8.h),

        Text(
          "We’re excited to announce the official schedule for our upcoming Event.\n\n"
              "Mark your calendars and get ready — it’s going to be an amazing experience! "
              "Stay tuned for more updates and don’t forget to share with your friends!",
          style: GoogleFonts.inter(
            fontSize: 13.sp,
            color: const Color(0xFF636F85),
            height: 1.5,
          ),
        ),
        SizedBox(height: 15.h),

        Text(
          "Pay \$2",
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF191919),
          ),
        ),
        SizedBox(height: 6.h),

        RichText(
          text: TextSpan(
            text: "Go to Live Event: ",
            style: GoogleFonts.inter(
              fontSize: 13.sp,
              color: const Color(0xFF191919),
            ),
            children: [
              TextSpan(
                text: "https://fiverrzoom.zoom.us/j/86189047244?",
                style: GoogleFonts.inter(
                  fontSize: 13.sp,
                  color: const Color(0xFF007AFF),
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20.h),

        // Reactions Row
        Row(
          children: [
            Icon(Icons.favorite_border, size: 22.sp, color: Colors.black),
            SizedBox(width: 4.w),
            Text("4.5M", style: GoogleFonts.inter(fontSize: 13.sp)),

            SizedBox(width: 20.w),
            Icon(Icons.chat_bubble_outline, size: 22.sp, color: Colors.black),
            SizedBox(width: 4.w),
            Text("25.2K", style: GoogleFonts.inter(fontSize: 13.sp)),

            SizedBox(width: 20.w),
            Icon(Icons.share_outlined, size: 22.sp, color: Colors.black),
            SizedBox(width: 4.w),
            Text("Share", style: GoogleFonts.inter(fontSize: 13.sp)),
          ],
        ),
      ],
    );
  }
}
