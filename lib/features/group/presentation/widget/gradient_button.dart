import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GradientButton extends StatelessWidget {
  const GradientButton({super.key, this.isGroup = false, required this.title, this.onTap});
  final bool isGroup;
  final String title;
  final VoidCallback? onTap;


  @override
  Widget build(BuildContext context) {
    final gradient = LinearGradient(
      colors: [Color(0xFF591AD4), Color(0xFFC121A0)],
    );

    return GestureDetector(
      onTap: () {
        onTap!();
       /// Get.toNamed(AppRoute.invite);

      },
      child: Container(
        padding: EdgeInsets.all(1.5.w), // Border thickness
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ShaderMask(
                shaderCallback: (bounds) => gradient.createShader(
                  Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                ),
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(width: 6.w),
              ShaderMask(
                shaderCallback: (bounds) => gradient.createShader(
                  Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                ),
                child: isGroup?Icon(
                  Icons.group_add,
                  size: 18.sp,
                  color: Colors.white,
                ):SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}