
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/utils/constants/icon_path.dart';
import '../../controller/search_controller.dart';

class LiveTabBody extends StatelessWidget {
  LiveTabBody({super.key});

  final controller = Get.find<SearchScreenController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20.h,),
        Text(
          'Live',
          style: GoogleFonts.poppins(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        Obx(
              () => GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.liveList.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 14.h,
              crossAxisSpacing: 14.w,
              childAspectRatio: 0.78,
            ),
            itemBuilder: (context, index) {
              final item = controller.liveList[index];
              return LiveCardWidget(
                imagePath: item['image'],
                viewers: item['viewers'],
              );
            },
          ),
        ),
      ],
    );
  }
}

class LiveCardWidget extends StatelessWidget {
  final String imagePath;
  final String viewers;

  const LiveCardWidget({
    super.key,
    required this.imagePath,
    required this.viewers,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.r),
      child: Stack(
        children: [
          // Image
          Positioned.fill(
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
            ),
          ),

          // Gradient overlay (for text readability)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.1),
                    Colors.black.withOpacity(0.25),
                  ],
                ),
              ),
            ),
          ),

          // Top overlay badges
          Positioned(
            top: 8.h,
            left: 8.w,
            right: 8.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    'Live',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(width: 7.w,),

                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Row(
                    children: [
                      Image.asset(IconPath.livegroup, // eye PNG icon
                        height: 10.h,
                        width: 10.w,
                        color: Colors.white,
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        viewers,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
