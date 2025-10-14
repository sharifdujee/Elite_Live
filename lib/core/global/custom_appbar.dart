import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';


class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;
  final bool? lead;
  final bool? center;
  final String? title;
  final Function? ontap;

  CustomAppBar({
    super.key,
    this.title,
    this.lead,
    this.center = false,
    this.ontap,
  }) : preferredSize = Size.fromHeight(56.h);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: center,
      scrolledUnderElevation: 0,
      title: Text(
        title ?? "",
        style: GoogleFonts.poppins(
          fontSize: 18.sp,
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
      ),
      leading: lead == false
          ? const SizedBox.shrink()
          : InkWell(
        onTap: () {
          if (ontap != null) {
            ontap!();
          } else {
            Get.back();
          }
        },
        child: const Icon(Icons.arrow_back, color: Colors.black),
      ),
    );
  }
}