import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/global_widget/custom_elevated_button.dart';

import '../../../../core/utils/constants/app_colors.dart';
import '../../controller/edit_profile_controller.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditProfileController());

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
                      SizedBox(height: 30.h),
                      20.verticalSpace,
                      _labelText('Gender'),
                      Obx(() => _dropdownField(
                        value: controller.selectedGender.value,
                        items: ['Male', 'Female', 'Others'],
                        onChanged: (value) {
                          controller.selectedGender.value = value!;
                        },
                      )),
                      20.verticalSpace,
                      _labelText('Date of Birth'),
                      Obx(() => _dateField(
                        controller.selectedDate.value,
                        onTap: () => controller.selectDate(context),
                      )),
                      20.verticalSpace,
                      _labelText('Profession'),
                      _textField(controller.professionController,hintText: 'Professional Model' ),
                      20.verticalSpace,
                      _labelText('Location'),
                      _textField(controller.professionController, hintText:'Dhaka, Bangladesh' ),
                      20.verticalSpace,
                      _labelText('Bio'),
                      _textField3(controller.professionController),
                      30.verticalSpace,
                      CustomElevatedButton(
                        text: 'Save Changes',
                        ontap: controller.updateProfile,
                      ),
                      40.verticalSpace,
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


  Widget _labelText(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
        color: Color(0xFF2D2D2D),
      ),
    );
  }

  Widget _dropdownField({
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.only(top: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          icon: const Icon(Icons.keyboard_arrow_down),
          items: items.map((String val) {
            return DropdownMenuItem<String>(
              value: val,
              child: Text(
                val,
                style: GoogleFonts.poppins(fontSize: 14.sp, color:Color(0xFF686666)),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _dateField(DateTime? selectedDate, {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(top: 8.h),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              selectedDate != null
                  ? "${selectedDate.day.toString().padLeft(2, '0')}/${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.year}"
                  : "Select Date",
              style: GoogleFonts.poppins(fontSize: 14.sp, color:Color(0xFF686666)),
            ),
            const Icon(Icons.calendar_today_outlined, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _textField(TextEditingController controller,{String hintText = 'Bio '}) {
    return Container(
      margin: EdgeInsets.only(top: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: TextField(
        controller: controller,
        style: GoogleFonts.poppins(fontSize: 14.sp),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.poppins(fontSize: 14.sp, color: const Color(
              0xFF686666)),
          border: InputBorder.none,
        ),
      ),
    );
  }


  Widget _textField3(TextEditingController controller, {String hintText = 'Bio '}) {
    return Container(
      height: 113.h,
      margin: EdgeInsets.only(top: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: TextField(
        maxLines: 5,
        controller: controller,
        style: GoogleFonts.poppins(fontSize: 14.sp),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.poppins(fontSize: 14.sp, color: const Color(
              0xFF686666)),
          border: InputBorder.none,
        ),
      ),
    );
  }



}
