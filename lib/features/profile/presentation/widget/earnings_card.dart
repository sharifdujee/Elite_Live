import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../controller/earning_overview_controller.dart';

class EarningSummaryCard extends StatelessWidget {
  final EarningsController controller;
  const EarningSummaryCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          Text(
            "Total Earning",
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            "\$${controller.totalEarnings}",
            style: GoogleFonts.inter(
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _infoItem("${controller.transactions}", "Transaction"),
              _infoItem("${controller.progress}", "Progress"),
              _infoItem("${controller.waiting}", "Waiting"),
            ],
          ),
          SizedBox(height: 14.h),
          Container(
            height: 40.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30.r),
            ),
            child: Center(
              child: Text(
                "Withdraw \$ →",
                style: GoogleFonts.inter(
                  color: AppColors.primaryColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
