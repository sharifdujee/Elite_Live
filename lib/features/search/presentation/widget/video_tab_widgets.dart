import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../controller/search_controller.dart';

class VideoTabWidget extends StatelessWidget {
  const VideoTabWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final SearchScreenController controller = Get.find<SearchScreenController>();

    return Obx(() {
      final videos = controller.videoList;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20.h),
          Text(
            'Video',
            style: GoogleFonts.poppins(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 16.h),
          Column(
            children: List.generate(videos.length, (index) {
              final item = videos[index];
              return VideoCard(
                imagePath: item.image,
                name: item.name,
                username: item.username,
                views: item.views,
                time: item.time,
              );
            }),
          ),
        ],
      );
    });
  }
}

class VideoCard extends StatelessWidget {
  final String imagePath;
  final String name;
  final String username;
  final String views;
  final String time;

  const VideoCard({
    super.key,
    required this.imagePath,
    required this.name,
    required this.username,
    required this.views,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: Image.asset(
              imagePath,
              height: 60.h,
              width: 60.w,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.poppins(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF191919),
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  username,
                  style: GoogleFonts.poppins(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF636F85),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  time,
                  style: GoogleFonts.poppins(
                    fontSize: 12.sp,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
          Text(
            views,
            style: GoogleFonts.poppins(
              fontSize: 12.sp,
              color: const Color(0xFF636F85),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
