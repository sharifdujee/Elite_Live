import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import '../../../../core/global_widget/custom_text_field.dart';
import '../../../../core/global_widget/custom_text_view.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/image_path.dart';



class AddContributorDialog {
  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          contentPadding: const EdgeInsets.all(20),
          backgroundColor: Colors.white,
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.arrow_back, color: AppColors.textBody, size: 24.sp),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: CustomTextView(
                        "Add Contributor",
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textHeader,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Icon(Icons.close, color: AppColors.textBody, size: 24.sp),
                  ],
                ),
                SizedBox(height: 20.h),
                Divider(),

                CustomTextField(
                  hintText: "Search by Name",
                ),

                SizedBox(height: 24.h),

                // Use Flexible with ListView instead of SingleChildScrollView
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Aligns children to left and right
                          children: [
                            // Left side: Avatar and Name
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage: AssetImage(ImagePath.user),
                                  radius: 24.r,
                                ),
                                SizedBox(width: 8.w),
                                CustomTextView(
                                  "Guy Hawkins",
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.sp,
                                  color: AppColors.textHeader,
                                ),
                              ],
                            ),
                            // Right side: Add button
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40.r),
                                gradient: LinearGradient(colors: [
                                  AppColors.secondaryColor,
                                  AppColors.primaryColor,
                                ]),
                              ),
                              child: CustomTextView(
                                "Add",
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textWhite,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}