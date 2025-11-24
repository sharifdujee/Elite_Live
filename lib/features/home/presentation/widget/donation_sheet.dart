import 'package:elites_live/core/global_widget/custom_loading.dart';
import 'package:elites_live/core/global_widget/custom_text_view.dart';
import 'package:elites_live/core/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controller/home_controller.dart';
import 'package:flutter/services.dart';


class DonationSheet extends StatefulWidget {
  const DonationSheet({super.key});

  static void show(BuildContext context) {
    Get.bottomSheet(
      const DonationSheet(),
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
    );
  }

  @override
  State<DonationSheet> createState() => _DonationSheetState();
}

class _DonationSheetState extends State<DonationSheet> {
  final HomeController controller = Get.find<HomeController>();
  final TextEditingController customAmountController = TextEditingController();
  final FocusNode amountFocusNode = FocusNode();

  @override
  void dispose() {
    customAmountController.dispose();
    amountFocusNode.dispose();
    super.dispose();
  }

  /// Builds a donation amount button
  Widget _buildDonationButton(String text, double amount) {
    return Obx(() {
      final isSelected = controller.selectedDonationAmount.value == amount;

      return GestureDetector(
        onTap: () {
          controller.selectedDonationAmount.value = amount;
          customAmountController.clear();
          amountFocusNode.unfocus();
        },
        child: Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            gradient: isSelected
                ? null
                : LinearGradient(
              colors: [
                AppColors.secondaryColor,
                AppColors.primaryColor,
              ],
            ),
            borderRadius: BorderRadius.circular(22),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primaryColor : Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              text,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 14.sp,
              ),
            ),
          ),
        ),
      );
    });
  }

  /// Validates and processes the donation
  void _processDonation() {
    double amount = controller.selectedDonationAmount.value;

    // Check if custom amount is entered
    if (customAmountController.text.isNotEmpty) {
      final customAmount = double.tryParse(customAmountController.text.trim());

      if (customAmount == null) {
        Get.snackbar(
          'Invalid Amount',
          'Please enter a valid number',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return;
      }

      if (customAmount <= 0) {
        Get.snackbar(
          'Invalid Amount',
          'Please enter an amount greater than \$0',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return;
      }

      amount = customAmount;
    }

    // Validate that an amount is selected
    if (amount <= 0) {
      Get.snackbar(
        'No Amount Selected',
        'Please select or enter a donation amount',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    // Close the bottom sheet
    Get.back();

    // Show loading dialog
    Get.dialog(
      Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomLoading(color: AppColors.primaryColor,),
                const SizedBox(height: 16),
                const Text('Processing payment...'),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );

    // Process the donation
    controller.processDonation(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 40),
                  Expanded(
                    child: CustomTextView(
                      text: "Donation",
                      textAlign: TextAlign.center,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textColorBlack,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Get.back(),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              SizedBox(height: 24.h),

              // Description
              CustomTextView(
                text: "Choose a donation amount or send a virtual gift to cheer for your favorite streamer!",
                fontWeight: FontWeight.w400,
                fontSize: 12.sp,
                color: AppColors.textBody,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.h),

              // Preset amounts
              Wrap(
                spacing: 10.w,
                runSpacing: 10.h,
                alignment: WrapAlignment.center,
                children: [
                  _buildDonationButton('\$2.00', 2.00),
                  _buildDonationButton('\$5.00', 5.00),
                  _buildDonationButton('\$10.00', 10.00),
                  _buildDonationButton('\$50.00', 50.00),
                ],
              ),
              SizedBox(height: 24.h),

              // Custom amount input
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Custom Amount',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                      color: AppColors.textColorBlack,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  TextField(
                    controller: customAmountController,
                    focusNode: amountFocusNode,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                    ],
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        controller.selectedDonationAmount.value = 0;
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter amount...',
                      prefixText: '\$ ',
                      prefixStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: AppColors.primaryColor,
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32.h),

              // Pay button
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.secondaryColor,
                      AppColors.primaryColor,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryColor.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: _processDonation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'Pay Now',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8.h),
            ],
          ),
        ),
      ),
    );
  }
}
