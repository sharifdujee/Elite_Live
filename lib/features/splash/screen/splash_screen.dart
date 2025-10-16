import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import '../../../core/utility/app_colors.dart';
import '../../../core/utility/image_path.dart';
import '../controller/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});

  final SplashController splashController = Get.find();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(color: AppColors.white),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(ImagePath.splash, width: 160.w, height: 160.h),
              ],
            ),
          ),
          Positioned(
            bottom: screenHeight * 0.05,
            left: 0,
            right: 0,
            child: Center(
              child: SpinKitCircle(
                color: AppColors.white,
                size: _getResponsiveSize(screenWidth, 50),
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _getResponsiveSize(double screenWidth, double baseSize) {
    if (screenWidth < 320) {
      return baseSize * 0.8;
    } else if (screenWidth < 360) {
      return baseSize * 0.9;
    } else if (screenWidth > 414) {
      return baseSize * 1.1;
    }
    return baseSize;
  }
}
