import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

import '../../../../core/utils/constants/app_colors.dart';
import '../../controller/search_controller.dart';

class UserTabWidget extends StatelessWidget {
  UserTabWidget({super.key});

  final controller = Get.find<SearchScreenController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final users = controller.userList;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20.h),
          Text(
            'User',
            style: GoogleFonts.poppins(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 16.h),

          // User cards
          Column(
            children: List.generate(users.length, (index) {
              final item = users[index];
              return UserCard(
                imagePath: item.image,
                name: item.name,
                username: item.username,
                followers: item.followers,
              );
            }),
          ),
        ],
      );
    });
  }
}

class UserCard extends StatelessWidget {
  final String imagePath;
  final String name;
  final String username;
  final String followers;

  const UserCard({
    super.key,
    required this.imagePath,
    required this.name,
    required this.username,
    required this.followers,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      child: Row(
        children: [
          // Profile Image
          ClipRRect(
            borderRadius: BorderRadius.circular(50.r),
            child: Image.asset(
              imagePath,
              height: 50.h,
              width: 50.w,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 5.w),

          // Name & Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.poppins(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  '$username | $followers',
                  style: GoogleFonts.poppins(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF636F85),
                  ),
                ),
              ],
            ),
          ),
SizedBox(width: 4.w,),
          // Follow Button
          Container(
            height: 32.h,
            width: 68.w,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(20.r),
            ),
            alignment: Alignment.center,
            child: Text(
              'Follow',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 12.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
