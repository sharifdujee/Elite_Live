/*
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/utils/constants/app_colors.dart';
import '../../controller/earning_overview_controller.dart';

import 'package:get/get.dart';

class EarningsSummaryCard extends StatelessWidget {
  final EarningsController controller = Get.find<EarningsController>();

  EarningsSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.balanceHistory.isEmpty) {
        return const Center(child: Text("No balance data available."));
      }

      final balance = controller.balanceHistory.first;





      return Card(
        margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.r),
        ),
        color: AppColors.primaryColor,
        elevation: 5,
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Earnings Summary",
                style: GoogleFonts.poppins(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textHeader,
                ),
              ),
              SizedBox(height: 10.h),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInfoColumn("Available", available.toDouble()),
                  _buildInfoColumn("Withdrawable", withdrawable),
                  _buildInfoColumn("Pending", pending),
                ],
              ),

              SizedBox(height: 20.h),
              Divider(color: AppColors.dividerColor, thickness: 1),

              SizedBox(height: 10.h),

            ],
          ),
        ),
      );
    });
  }

  Widget _buildInfoColumn(String label, double value) {
    return Column(
      children: [
        Text(
          value.toStringAsFixed(2),
          style: GoogleFonts.poppins(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textHeader,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14.sp,
            color: AppColors.textBody,
          ),
        ),
      ],
    );
  }
}


*/


// earnings_summary_card.dart  →  Updated UI Only (100% same data & logic)
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../controller/earning_overview_controller.dart';

class EarningsSummaryCard extends StatelessWidget {
  const EarningsSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EarningsController>();

    return Obx(() {
      // Using your existing observables — NO CHANGES in logic
      final withdrawable = controller.balanceHistory.first.withdrawable;
      final available = controller.balanceHistory.first.available ;
      final pending = controller.balanceHistory.first.pendingBalance ;
      final totalTransaction = controller.balanceHistory.first.totalTransactions;
      final completeTransaction = controller.balanceHistory.first.completedTransactions;
      final pendingTransaction = controller.balanceHistory.first.pendingTransactions;


      return Container(
        margin: EdgeInsets.fromLTRB(10.w, 20.h, 10.w, 10.h),
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(28.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 32.h, horizontal: 24.w),
          child: Column(
            children: [
              // Top Stats: Transactions • Completed • In Progress
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _statItem("$totalTransaction", "Transactions"),
                  _statItem("$completeTransaction", "Completed"),
                  _statItem("$pendingTransaction", "In Progress"),
                ],
              ),

              SizedBox(height: 40.h),

              // Balance Details
              _balanceRow("Available Balance", available.toDouble()),
              SizedBox(height: 20.h),
              _balanceRow("Pending Balance", pending),
              SizedBox(height: 20.h),
              _balanceRow("Withdrawable Balance", withdrawable, isBold: true),

              SizedBox(height: 40.h),

              // Withdraw Button
              SizedBox(
                width: double.infinity,
                height: 56.h,
                child: ElevatedButton(
                  onPressed: () {
                    Get.bottomSheet(
                      _withdrawAmountSheet(controller),
                      isScrollControlled: true,
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
                      ),
                    );
                  },

                  child: Text(
                    "Withdraw  \$${withdrawable.toStringAsFixed(2)}",
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF9C27B0),
                    ),
                  ),
                )

                ),

            ],
          ),
        ),
      );
    });
  }

  Widget _statItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 36.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            height: 1,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _balanceRow(String label, double amount, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 15.sp,
            color: Colors.white70,
          ),
        ),
        Text(
          "\$${amount.toStringAsFixed(2)}",
          style: GoogleFonts.inter(
            fontSize: isBold ? 22.sp : 18.sp,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _withdrawAmountSheet(EarningsController controller) {
    final withdrawable = controller.balanceHistory.first.withdrawable;

    return Container(
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(Get.context!).viewInsets.bottom,
        left: 20,
        right: 20,
        top: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Withdraw Funds",
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),

          TextField(
            controller: controller.amountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "Enter amount",
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.attach_money),
              hintText: "Max: ${withdrawable.toStringAsFixed(2)}",
            ),
          ),

          SizedBox(height: 20),

          Obx(() => ElevatedButton(
            onPressed: controller.isLoading.value
                ? null
                : () => controller.instantPayout(),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 50),
            ),
            child: controller.isLoading.value
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(
              "Withdraw Now",
              style: TextStyle(fontSize: 16),
            ),
          )),
          SizedBox(height: 20),
        ],
      ),
    );
  }

}
