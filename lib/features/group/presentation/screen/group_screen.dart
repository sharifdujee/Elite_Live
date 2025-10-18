import 'package:elites_live/core/global/custom_text_field.dart';
import 'package:elites_live/core/global/custom_text_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/constants/app_colors.dart';


class GroupScreen extends StatelessWidget {
  const GroupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // light background
      body: Stack(
        children: [
          // Gradient Header
          Container(
            height: 160.h,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  children: [
                    Icon(Icons.arrow_back, color: Colors.white),
                    SizedBox(width: 12.w),
                    CustomTextView("Group", fontWeight: FontWeight.w600,fontSize: 20.sp,color: AppColors.white,)
                  ],
                ),
              ),
            ),
          ),

          // White Card Container
          Positioned(
            top: 120.h,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
              ),
              child: Column(
                children: [
                  SizedBox(height: 13.h,),
                  // Search Bar
                  CustomTextField(
                    hintText: "Search By Group",
                  ),
                  SizedBox(height: 20.h),

                  // Group List


                  // Bottom Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF5D2CEC),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.r),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            child: Text("Discover Group"),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF5D2CEC)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.r),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            child: Text(
                              "Create Group",
                              style: TextStyle(color: Color(0xFF5D2CEC)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


}

