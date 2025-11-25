import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../controller/earning_overview_controller.dart';
import '../widget/earnings_card.dart';
import '../widget/earnings_users_data.dart';

class EarningsPage extends StatelessWidget {
  EarningsPage({super.key});

  final EarningsController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                // Gradient Header
                Container(
                  height: 190.h,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: AppColors.primaryGradient,
                  ),
                ),

                // Back Button
                Positioned(
                  top: 50.h,
                  left: 20.w,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: const Icon(Icons.arrow_back, color: Colors.white),
                      ),
                      SizedBox(width: 20.w),
                      Text(
                        'Earning Overview',
                        style: GoogleFonts.inter(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                // Main Body
                Container(
                  margin: EdgeInsets.only(top: 160.h),
                  padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 20.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24.r),
                      topRight: Radius.circular(24.r),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTabs(controller),
                      SizedBox(height: 20.h),

                      EarningsSummaryCard(),
                      SizedBox(height: 20.h),

                      Obx(() {
                        if (controller.selectedTab.value == 0) {
                          return EarningListCard(
                            title: "Ads Revenue",
                            items: controller.adsRevenueList,
                          );
                        } else {
                          // Convert API model --> Map
                          final fundingItems = controller
                              .balanceHistory.first.transactionHistory
                              .map((tx) => {
                            "image": "assets/images/live1.png",
                            "title": tx.event.title,
                            "subtitle": tx.event.text,
                            "amount": "\$${tx.amount}",
                          })
                              .toList();

                          return EarningListCard(
                            title: "Crowdfunding",
                            items: fundingItems,
                          );
                        }
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabs(EarningsController controller) {
    return Obx(() => Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _tabItem(
          title: "Ads Revenue",
          isSelected: controller.selectedTab.value == 0,
          onTap: () => controller.changeTab(0),
        ),
        SizedBox(width: 80.w),
        _tabItem(
          title: "Funding",
          isSelected: controller.selectedTab.value == 1,
          onTap: () => controller.changeTab(1),
        ),
      ],
    ));
  }

  Widget _tabItem({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              color: isSelected ? AppColors.primaryColor : Colors.black54,
            ),
          ),
          SizedBox(height: 5.h),
          Container(
            height: 2.h,
            width: 70.w,
            color: isSelected ? AppColors.primaryColor : Colors.transparent,
          ),
        ],
      ),
    );
  }
}
