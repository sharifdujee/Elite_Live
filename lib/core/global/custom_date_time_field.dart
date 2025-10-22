
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomDateOfBirthFiled extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onTap;
  final String? hint;

  const CustomDateOfBirthFiled({super.key, required this.controller, required this.onTap, this.hint});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      height: 50.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: TextField(
        controller: controller,
        textAlign: TextAlign.start,
        style: Theme.of(
          context,
        ).textTheme.labelMedium?.copyWith(color: Colors.grey),
        readOnly: true,
        onTap: onTap,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding:
          EdgeInsets.symmetric(vertical: 12.h),
          hintText: hint ??  "Date of birth",
          hintStyle: Theme.of(
            context,
          ).textTheme.labelMedium?.copyWith(color: Colors.grey),
          suffixIcon: Icon(
            Icons.calendar_today,
            color: Colors.grey.shade600,
            size: 20.sp,
          ),
        ),
      ),
    );
  }
}