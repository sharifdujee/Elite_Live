import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class ScheduleTab extends StatelessWidget {
  const ScheduleTab({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Date and Time Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Date: 25-08-2025",
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF191919),
              ),
            ),
            Text(
              "11:00 PM",
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF191919),
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),

        Text(
          "Event Schedule is Live!",
          style: GoogleFonts.inter(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF191919),
          ),
        ),
        SizedBox(height: 8.h),

        Text(
          "We’re excited to announce the official schedule for our upcoming Event.\n\n"
              "Mark your calendars and get ready — it’s going to be an amazing experience! "
              "Stay tuned for more updates and don’t forget to share with your friends!",
          style: GoogleFonts.inter(
            fontSize: 13.sp,
            color: const Color(0xFF636F85),
            height: 1.5,
          ),
        ),
        SizedBox(height: 15.h),

        Text(
          "Pay \$2",
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF191919),
          ),
        ),
        SizedBox(height: 6.h),

        RichText(
          text: TextSpan(
            text: "Go to Live Event: ",
            style: GoogleFonts.inter(
              fontSize: 13.sp,
              color: const Color(0xFF191919),
            ),
            children: [
              TextSpan(
                text: "https://fiverrzoom.zoom.us/j/86189047244?",
                style: GoogleFonts.inter(
                  fontSize: 13.sp,
                  color: const Color(0xFF007AFF),
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20.h),

        // Reactions Row
        Row(
          children: [
            Icon(Icons.favorite_border, size: 22.sp, color: Colors.black),
            SizedBox(width: 4.w),
            Text("4.5M", style: GoogleFonts.inter(fontSize: 13.sp)),

            SizedBox(width: 20.w),
            Icon(Icons.chat_bubble_outline, size: 22.sp, color: Colors.black),
            SizedBox(width: 4.w),
            Text("25.2K", style: GoogleFonts.inter(fontSize: 13.sp)),

            SizedBox(width: 20.w),
            Icon(Icons.share_outlined, size: 22.sp, color: Colors.black),
            SizedBox(width: 4.w),
            Text("Share", style: GoogleFonts.inter(fontSize: 13.sp)),
          ],
        ),
      ],
    );
  }
}