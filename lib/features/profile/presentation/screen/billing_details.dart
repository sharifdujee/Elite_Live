import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/global_widget/custom_elevated_button.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../controller/billing_details_controller.dart';

class BillingDetailsPage extends StatelessWidget {
  final BillingDetailsController controller = Get.put(BillingDetailsController());

  BillingDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 190.h,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: AppColors.primaryGradient,
                  ),
                ),
                Positioned(
                  top: 50.h,
                  left: 20.w,
                  child:     Row(
                    children: [
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: const Icon(Icons.arrow_back,color: Colors.white,),
                      ),
                      SizedBox(width: 20.w),
                      Text('Edit Profile',
                        style: GoogleFonts.inter(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 160.h),
                  padding: EdgeInsets.symmetric(horizontal: 25.w),
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

                      SingleChildScrollView(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 24.h),

                            // Billing country or region
                            _sectionTitle('Billing country or region'),
                            SizedBox(height: 12.h),
                            Obx(() => _buildDropdown(
                              'Country/region',
                              controller.selectedCountry.value,
                              controller.countries,
                                  (val) => controller.selectedCountry.value = val!,
                            )),

                            SizedBox(height: 24.h),

                            // Currency and time zone
                            _sectionTitle('Currency and time zone'),
                            SizedBox(height: 12.h),
                            Obx(() => _buildDropdown(
                              'Currency',
                              controller.selectedCurrency.value,
                              controller.currencies,
                                  (val) => controller.selectedCurrency.value = val!,
                            )),
                            SizedBox(height: 12.h),
                            Obx(() => _buildDropdown(
                              'Time zone',
                              controller.selectedTimeZone.value,
                              controller.timeZones,
                                  (val) => controller.selectedTimeZone.value = val!,
                            )),

                            SizedBox(height: 24.h),

                            // Business address
                            _sectionTitle('Business address'),
                            SizedBox(height: 8.h),
                            Text(
                              'The legal address registered with your government and tax agency. If you\'re not a registered business, enter your mailing address.',
                              style: GoogleFonts.inter(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey.shade600,
                                height: 1.5,
                              ),
                            ),
                            SizedBox(height: 16.h),
                            _buildTextField(
                              controller.streetAddress1Controller,
                              'Street address 1',
                            ),
                            SizedBox(height: 12.h),
                            _buildTextField(
                              controller.streetAddress2Controller,
                              'Street address 2 (optional)',
                            ),
                            SizedBox(height: 12.h),
                            _buildTextField(
                              controller.cityController,
                              'City or town',
                            ),
                            SizedBox(height: 12.h),
                            _buildTextField(
                              controller.stateController,
                              'State, province or region',
                            ),
                            SizedBox(height: 12.h),
                            _buildTextField(
                              controller.zipCodeController,
                              'Zip Code',
                            ),

                            SizedBox(height: 24.h),

                            // Business Identification Number (BIN)
                            _sectionTitle('Business Identification Number (BIN)'),
                            SizedBox(height: 8.h),
                            Text(
                              'By providing your BIN, you are confirming that you are registered for Value-Added Tax (VAT). VAT will not be charged. VAT will be charged VAT if the BIN you provide is invalid or incomplete.',
                              style: GoogleFonts.inter(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey.shade600,
                                height: 1.5,
                              ),
                            ),
                            SizedBox(height: 16.h),
                            _buildTextField(
                              controller.binController,
                              'Optional',
                            ),

                            SizedBox(height: 24.h),

                            // Radio buttons
                            Obx(() => _radioTile(
                              'Yes, I am buying ads for business purposes',
                              true,
                              controller.isBuyingForBusiness.value,
                                  (val) => controller.isBuyingForBusiness.value = val!,
                            )),
                            SizedBox(height: 12.h),
                            Obx(() => _radioTile(
                              'No, I am not buying ads for business purposes',
                              false,
                              controller.isBuyingForBusiness.value,
                                  (val) => controller.isBuyingForBusiness.value = val!,
                            )),

                            SizedBox(height: 32.h),
                          ],
                        ),
                      ),

                      // Next Button at bottom
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              offset: const Offset(0, -2),
                            ),
                          ],
                        ),
                        child: CustomElevatedButton(
                          ontap: () => controller.onNext(),
                          text: "Next",
                        ),
                      ),
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


  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
    );
  }

  Widget _buildDropdown(
      String label,
      String value,
      List<String> items,
      Function(String?) onChanged,
      ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11.sp,
              fontWeight: FontWeight.w400,
              color: Colors.grey.shade600,
            ),
          ),
          DropdownButton<String>(
            value: value,
            isExpanded: true,
            underline: const SizedBox(),
            icon: Icon(Icons.keyboard_arrow_down, size: 20.sp, color: Colors.grey.shade700),
            items: items
                .map((e) => DropdownMenuItem<String>(
              value: e,
              child: Text(
                e,
                style: GoogleFonts.inter(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ))
                .toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController textController, String hint) {
    return TextField(
      controller: textController,
      style: GoogleFonts.inter(
        fontSize: 13.sp,
        color: Colors.black,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.inter(
          fontSize: 13.sp,
          color: Colors.grey.shade500,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(color: Color(0xFF9333EA)),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      ),
    );
  }

  Widget _radioTile(String title, bool value, bool groupValue, Function(bool?) onChanged) {
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Row(
        children: [
          Radio<bool>(
            value: value,
            groupValue: groupValue,
            onChanged: onChanged,
            activeColor: const Color(0xFF9333EA),
          ),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }



}
