import 'package:elites_live/features/profile/presentation/screen/payment_info_dialog.dart';
import 'package:elites_live/features/profile/presentation/screen/tax_info_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/global/gradient_radio.dart';
import '../../../../core/global_widget/custom_elevated_button.dart';
import '../../../../core/utility/icon_path.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../controller/payment_info_controller.dart';

class PaymentInfoPage extends StatelessWidget {
  const PaymentInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PaymentInfopageController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                // Header gradient
                Container(
                  height: 190.h,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: AppColors.primaryGradient,
                  ),
                ),

                // Back + Title
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
                        'Payment Info',
                        style: GoogleFonts.inter(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                // White body container
                Container(
                  margin: EdgeInsets.only(top: 160.h),
                  padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 25.h),
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
                      // ==========================
                      // Business location section
                      // ==========================
                      Text(
                        "Business location and currency",
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "America, America Us Dollar",
                            style: GoogleFonts.inter(
                              fontSize: 13.sp,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          InkWell(
                            onTap: (){
                              showDialog(
                                context: context,
                                builder: (context) => PaymentInfoDialog(),
                              );

                            },
                            child: Text(
                              "Edit",
                              style: GoogleFonts.inter(
                                fontSize: 13.sp,
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    //  SizedBox(height: 4.h),



                      SizedBox(height: 24.h),

                      // ==========================
                      // Business tax info
                      // ==========================
                      Text(
                        "Business and tax info",
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 4.h),

                      SizedBox(height: 4.h),
                     Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         Text(
                           "Optional - Add a tax ID or address",
                           style: GoogleFonts.inter(
                             fontSize: 13.sp,
                             color: Colors.grey.shade600,
                           ),
                         ),
                         InkWell(
                           onTap: (){
                             showDialog(
                               context: context,
                               builder: (context) => TaxInfoDialog(),
                             );

                           },
                           child: Text(
                                "Edit",
                                style: GoogleFonts.inter(
                                  fontSize: 13.sp,
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                         ),
                       ],
                     ),

                      SizedBox(height: 24.h),


                      // ==========================
// Payment method (corrected)
// ==========================
                      Text(
                        "Add payment method",
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 10.h),

// Card option
                      Obx(() => GestureDetector(
                        onTap: () => controller.selectPaymentMethod('card'),
                        child: Row(
                          children: [
                            GradientRadio(
                              // Compare against controller.selectedPaymentMethod
                              selected: controller.selectedPaymentMethod.value == 'card',
                              // pass a VoidCallback - do not call the method here
                              onTap: () => controller.selectPaymentMethod('card'),
                              gradient: const LinearGradient(
                                colors: [Color(0xFF8A3FFC), Color(0xFFFF2E93)],
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Text(
                              "Debit or credit card",
                              style: GoogleFonts.inter(
                                fontSize: 13.sp,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Image.asset(IconPath.visa, width: 28.w, height: 18.h),
                            SizedBox(width: 6.w),
                            Image.asset(IconPath.master, width: 28.w, height: 18.h),
                            SizedBox(width: 6.w),
                            // other icons...
                            SizedBox(width: 5.w),
                            Text("+ More", style: GoogleFonts.inter(fontSize: 13.sp, color: Colors.black87)),
                          ],
                        ),
                      )),

                      SizedBox(height: 12.h),

// Example second option (e.g., PayPal) — illustrate how to add more options
                      Obx(() => GestureDetector(
                        onTap: () => controller.selectPaymentMethod('paypal'),
                        child: Row(
                          children: [
                            GradientRadio(
                              selected: controller.selectedPaymentMethod.value == 'paypal',
                              onTap: () => controller.selectPaymentMethod('paypal'),
                              gradient: const LinearGradient(
                                colors: [Color(0xFF8A3FFC), Color(0xFFFF2E93)],
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Text("I have an ad credit to claim.", style: GoogleFonts.inter(fontSize: 13.sp, color: Colors.black87)),
                          ],
                        ),
                      )),
SizedBox(height: 310.h,),

                      // ==========================
                      // Next Button
                      // ==========================
                      CustomElevatedButton(
                        text: 'Save Changes',
                        ontap: controller.onNext,
                      ),
                      SizedBox(height: 20.h),
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
}
