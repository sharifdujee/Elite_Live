import 'package:elites_live/core/global_widget/custombuttonwhite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/global_widget/custom_elevated_button.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../routes/app_routing.dart';
import '../../controller/edit_profile_controller.dart';

class PremiumPage extends StatelessWidget {
  const PremiumPage({super.key});

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
                      Text('Premium',
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
                  width: double.maxFinite,
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 90.h),
                      Text('Upgrade to Premium',
                        style: GoogleFonts.poppins(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2D2D2D)
                        ),
                        textAlign: TextAlign.center,
                      ),

                  SizedBox(height: 20.h,),

                  Text('Access all features with a single\npurchase plan.',
                    style: GoogleFonts.poppins(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF636F85)
                    ),
                    textAlign: TextAlign.center,
                  ),

                      SizedBox(height: 45.h,),
                      CustomElevatedButton(ontap: (){Get.toNamed(AppRoute.subscription);}, text: "Upgrade Now"),
                      SizedBox(height: 25.h,),
                      CustomButtonWhite(text: "Not Now", onPressed: (){Get.back();},)
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
