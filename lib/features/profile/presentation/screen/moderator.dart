import 'package:elites_live/core/global_widget/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../controller/moderator_controller.dart';

class ModeratorPage extends StatelessWidget {
  final ModeratorController controller = Get.put(ModeratorController());

  ModeratorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor, // Yellow background
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top header + profile image
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
                      Text('Moderator',
                        style: GoogleFonts.inter(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                // White section with rounded corners
                Container(
                  height: 650.h,
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
                      SizedBox(height: 30.h), // for profile image overlap


                      _labelText("Add Moderator"),
                      SizedBox(height: 8.h),
                      Obx(() => _buildDropdown(
                        controller.selectedModerator.value.isEmpty
                            ? null
                            : controller.selectedModerator.value,
                        controller.moderators,
                            (val) => controller.selectedModerator.value = val!,
                      )),
                      SizedBox(height: 24.h),

                      _labelText("Moderator Access"),
                      SizedBox(height: 8.h),
                      Obx(() => _buildDropdown(
                        controller.selectedSlowMode.value.isEmpty
                            ? null
                            : controller.selectedSlowMode.value,
                        controller.slowModes,
                            (val) => controller.selectedSlowMode.value = val!,
                      )),
                      SizedBox(height: 24.h),

                      _labelText("Keyword"),
                      SizedBox(height: 8.h),
                      TextField(

                        controller: controller.keywordController,
                        onSubmitted: (val) => controller.addKeyword(val),
                        decoration: InputDecoration(
                          hintText: "Type your keyword...",
                          hintStyle: TextStyle(color: Colors.grey, fontSize: 14.sp),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          contentPadding:
                          EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Obx(() => Wrap(
                        spacing: 8.w,
                        runSpacing: 8.h,
                        children: controller.keywords
                            .map((keyword) => Chip(
                          label: Text(keyword,
                              style: TextStyle(
                                  fontSize: 13.sp, color: Colors.black)),
                          backgroundColor: Colors.grey.shade200,
                          deleteIcon: Icon(Icons.close, size: 18.sp),
                          onDeleted: () =>
                              controller.removeKeyword(keyword),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r)),
                        ))
                            .toList(),
                      )),
                      SizedBox(height: 30.h),

                      // Toggles
                      _toggleTile("User Banned", controller.userBanned),
                      _toggleTile("Sub_Only", controller.subOnly),
                      SizedBox(height: 40.h),

                      // Save Button
                      CustomElevatedButton(ontap: (){}, text: "Save"),


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

  Widget infoTile(String iconPath, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(iconPath, height: 24.h, width: 24.w),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  text,
                  style: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF191919)
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 15.h,),
          Container(height: 1.5.h, width: 310, color: Color(0xFFF8F8FB),),
        ],
      ),
    );
  }


  Widget settingTile(
      String iconPath,
      String title, {
        Color color = AppColors.bgColor,
        Color textColor = Colors.black,
        VoidCallback? onTap,
        bool showArrow = false,
      }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Column(
          children: [
            Row(
              children: [
                Image.asset(iconPath, height: 20.h, width: 20.w, color: color),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: textColor,
                    ),
                  ),
                ),
                if (showArrow)
                  Icon(Icons.arrow_forward_ios, size: 20.sp, color: Color(0xFF334155)),
              ],
            ),
            SizedBox(height: 15.h,),
            Container(height: 1.5.h, width: 310, color: Color(0xFFF8F8FB),),
          ],
        ),
      ),
    );
  }
  Widget _labelText(String title) => Text(
    title,
    style: TextStyle(
      fontSize: 15.sp,
      fontWeight: FontWeight.w600,
      color: Colors.black87,
    ),
  );

  Widget _buildDropdown(String? value, List<String> items, Function(String?) onChanged) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: DropdownButton<String>(
        value: value,
        isExpanded: true,
        underline: const SizedBox(),
        hint: Text(
          "Select...",
          style: TextStyle(color: Colors.grey.shade500, fontSize: 14.sp),
        ),
        items: items
            .map((e) => DropdownMenuItem<String>(
          value: e,
          child: Text(e, style: TextStyle(fontSize: 14.sp)),
        ))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _toggleTile(String title, RxBool value) {
    return Obx(
          () => Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title,
                style: TextStyle(
                    fontSize: 15.sp,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500)),
            Switch(
              value: value.value,
              onChanged: (val) => value.value = val,
              activeColor: const Color(0xFFFFFFFF),
              activeTrackColor: AppColors.primaryColor,
            ),
          ],
        ),
      ),
    );
  }

}
