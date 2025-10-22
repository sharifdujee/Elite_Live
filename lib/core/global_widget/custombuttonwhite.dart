import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/constants/app_colors.dart';

class CustomButtonWhite extends StatelessWidget {
  final double? width;
  final double? height;
  final String text;
  final VoidCallback? onPressed;
  final bool loading;

  const CustomButtonWhite({
    super.key,
    this.width,
    this.height,
    required this.text,
    this.onPressed,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          width: width ?? 335.w,
          height: height ?? 44.h,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient, // gradient border
            borderRadius: BorderRadius.circular(50.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(1.5), // border thickness
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white, // inner background
                borderRadius: BorderRadius.circular(50.r),
              ),
              child: Center(
                child: ShaderMask(
                  shaderCallback: (bounds) =>
                      AppColors.primaryGradient.createShader(
                        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                      ),
                  child: Text(
                    text,
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white, // gradient mask applies here
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
