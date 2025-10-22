


import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter/material.dart';


import '../../../../core/global/custom_text_field.dart';
import '../../../../core/global/custom_text_view.dart';
import '../../../../core/utils/constants/app_colors.dart';



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
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    Icon(Icons.arrow_back, color: AppColors.textBody,size: 24.sp,),
                    SizedBox(width: 10.w,),
                    CustomTextView(
                      "Add Contributor",
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textHeader,
                    ),
                    SizedBox(width: 10.w,),
                    Icon(Icons.close, color: AppColors.textBody,size: 24.sp,),
                  ],
                ),
                SizedBox(height: 20.h),
                Divider(),

                CustomTextField(
                  hintText: "Search by Name",
                ),



                SizedBox(height: 24.h),

                // Confirm Button

              ],
            ),
          ),
        );
      },
    );
  }
}