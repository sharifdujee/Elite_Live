import 'package:elites_live/core/global_widget/custom_text_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/constants/app_colors.dart';

class SocialLoginButton extends StatelessWidget {
  final Widget icon;
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final TextStyle? textStyle;
  final Color? borderColor;
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
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 20.r),
        backgroundColor: backgroundColor ?? Colors.white,
        minimumSize: Size(width ?? double.infinity, height!),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius.r),
          side: BorderSide(
            color: borderColor ?? AppColors.primaryColor,
            width: 0.5,
          ),
        ),
        elevation: 0,
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          SizedBox(width: 10.w),
          CustomTextView(
            color: Colors.black87,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            text: text,
          ),
        ],
      ),
    );
  }
}
