import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/constants/app_colors.dart';

class SocialLoginButton extends StatelessWidget {
  final Widget icon;
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final TextStyle? textStyle;
  final double? width;
  final double? height;
  final double borderRadius;

  const SocialLoginButton({
    super.key,
    required this.icon,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textStyle,
    this.width,
    this.height = 50,
    this.borderRadius = 10,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? Colors.white,
        minimumSize: Size(width ?? double.infinity, height!),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius.r),
          side: BorderSide(color: AppColors.primaryColor), 
        ),
        elevation: 0, 
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          SizedBox(width: 10.w),
          Text(
            text,
            style: textStyle ?? TextStyle(
              color: Colors.black87,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}