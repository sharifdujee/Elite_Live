

import 'package:elites_live/core/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class ShareSheet extends StatelessWidget {
  const ShareSheet({super.key});

  void show(BuildContext context) {
    Get.bottomSheet(
      this,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }

  Widget _buildShareOption(IconData icon, String label, VoidCallback onTap, Color iconColor) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 28.sp, color: iconColor,),
          ),
           SizedBox(height: 8.h),
          Text(
            label,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Share',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildShareOption(
                Icons.link,
                'Copy link',
                    () {
                  Get.back();
                  Get.snackbar('Link Copied', 'Link copied to clipboard');
                },
                AppColors.textHeader,
              ),
              _buildShareOption(
                FontAwesomeIcons.tiktok,
                'TikTok',
                    () {
                  Get.back();
                  Get.snackbar('Share', 'Opening TikTok...');
                },
                AppColors.textHeader,
              ),
              _buildShareOption(
                FontAwesomeIcons.facebook,
                'Facebook',
                    () {
                  Get.back();
                  Get.snackbar('Share', 'Opening Facebook...');
                },
                Color(0xFF1877F2),
              ),
              _buildShareOption(
                FontAwesomeIcons.instagram,
                'Instagram',
                    () {
                  Get.back();
                  Get.snackbar('Share', 'Opening Instagram...');
                },
                AppColors.primaryColor,
              ),
            ],
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
