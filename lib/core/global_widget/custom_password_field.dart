import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomPasswordField extends StatelessWidget {
  final RxBool isVisible = true.obs;

  final String hints;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  CustomPasswordField({
    super.key,
    required this.hints,
    this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() => TextFormField(
      validator: validator,
      controller: controller,
      obscureText: isVisible.value,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFF9F9FB),
        hintText: hints,
        hintStyle: GoogleFonts.andika(
          color: const Color(0xFF9BA4B0),
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
        ),
        errorStyle: GoogleFonts.andika(
          color: Colors.red,
          fontSize: 12.sp,
          fontWeight: FontWeight.w400,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        suffixIcon: InkWell(
          onTap: () {
            isVisible.value = !isVisible.value;
          },
          child: Icon(
            isVisible.value ? Icons.visibility_off : Icons.visibility,
            color: const Color(0xFF9BA4B0),
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Color(0xFFEDEEF4), width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Color(0xFFEDEEF4), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Color(0xFFB0B0B0), width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
      ),
      style: GoogleFonts.andika(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: Colors.black,
      ),
    ));
  }
}
