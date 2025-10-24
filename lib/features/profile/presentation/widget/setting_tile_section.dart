import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/utils/constants/app_colors.dart';



class SettingTile extends StatelessWidget {
  final String iconPath;
  final String title;
  final Color color;
  final Color textColor;
  final VoidCallback? onTap;
  final bool showArrow;

  const SettingTile({
    super.key,
    required this.iconPath,
    required this.title,
    this.color = AppColors.bgColor,
    this.textColor = Colors.black,
    this.onTap,
    this.showArrow = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Column(
          children: [
            Row(
              children: [
                Image.asset(
                  iconPath,
                  height: 20.h,
                  width: 20.w,
                  color: color,
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: textColor,
                    ),
                  ),
                ),
                if (showArrow)
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 20.sp,
                    color: Colors.grey,
                  ),
              ],
            ),
            SizedBox(height: 15.h),
            Container(
              height: 1.5.h,
              width: 310.w,
              color: const Color(0xFFF8F8FB),
            ),
          ],
        ),
      ),
    );
  }
}
