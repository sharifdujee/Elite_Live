import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/constants/app_colors.dart';


class CustomElevatedButton extends StatelessWidget {
  final String text;
  final Color? backgroundColor;
  final Gradient gradient;
  final TextStyle? textStyle;
  final VoidCallback ontap;
  final bool isLoading;
  final double? widths;
  final Color? textColor;

  const CustomElevatedButton({
    super.key,
    this.widths = 0,
    required this.ontap,
    required this.text,
    this.backgroundColor,
    this.gradient = AppColors.primaryGradient,
    this.textStyle,
    this.isLoading = false,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {

    final isWhiteButton = backgroundColor == Colors.white;

    return Container(
      width: widths == 0 ? double.infinity : widths,
      height: 50.h,
      decoration: BoxDecoration(
        gradient: isWhiteButton ? null : gradient,
        color: backgroundColor,
        border: isWhiteButton
            ? Border.all(color: Color(0xFF8E2DE2), width: 2)
            : null,
        borderRadius: BorderRadius.circular(25.r),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.r),
          ),
        ),
        onPressed: isLoading ? null : ontap,
         child: isLoading
        ? SizedBox(
        height: 24.h,
        width: 24.h,
        child: CircularProgressIndicator(
          color: Colors.white,
          strokeWidth: 2.5,
        ),
      )
          : Text(
      text,
      textAlign: TextAlign.center,
      style: textStyle ??
          GoogleFonts.andika(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: textColor ?? (isWhiteButton ? Color(0xFF8E2DE2) : Colors.white),
          ),
    ),

    ),
    );
  }
}