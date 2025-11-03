import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/global/custom_elevated_button.dart';
import '../../../../core/global/custom_text_view.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../routes/app_routing.dart';

class UpgradePremiumScreen extends StatelessWidget {
  const UpgradePremiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: AppColors.bgColor,
            body: Column(
              children: [
                /// Gradient Header
                Container(
                  height: 130.h,
                  width: double.infinity,
                  decoration:  BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.secondaryColor, AppColors.primaryColor],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: SafeArea(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                      child: Row(
                        children: [
                          GestureDetector(
                              onTap: (){
                                Get.back();
                              },
                              child: Icon(Icons.arrow_back, color: Colors.white, size: 24.sp)),
                          SizedBox(width: 12.w),
                          CustomTextView(
                            "Upgrade",
                            fontWeight: FontWeight.w600,
                            fontSize: 20.sp,
                            color: AppColors.white,
                          )
                        ],
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 157.h,),
                        /// Search Bar
                        CustomTextView("Upgrade to Premium", fontWeight: FontWeight.w600,fontSize: 24.sp,textAlign: TextAlign.center,color: AppColors.liveText,),
                        SizedBox(height: 20.h,),
                        CustomTextView("Access all features with a single purchase plan.", textAlign: TextAlign.center,fontSize: 16.sp,fontWeight: FontWeight.w400,color: AppColors.textBody,),
                        SizedBox(height: 24.h,),

                        /// Bottom Buttons

                        CustomElevatedButton(

                          ontap: () {
                            Get.toNamed(AppRoute.subscription);
                          },
                          text: "Upgrade Now ",
                          gradient: AppColors.primaryGradient,
                        ),
                        SizedBox(height: 12.w),
                        CustomElevatedButton(
                          ontap: () {
                            Get.back();
                          },
                          text: "Not Now",
                          backgroundColor: Colors.white,
                          gradient: LinearGradient(colors: [Colors.white, Colors.white]),
                          textStyle: GoogleFonts.andika(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF8E2DE2),
                          ),
                        ),


                        SizedBox(height: 16.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }
    );
  }
}
