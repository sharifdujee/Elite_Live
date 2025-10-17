import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/global/custom_text_view.dart';
import '../../../../core/utils/constants/app_colors.dart';

class VideoInteractionSection extends StatelessWidget {
  const VideoInteractionSection({super.key});

  @override
  Widget build(BuildContext context) {
  return  SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildItem(Icons.favorite, "4.5M", Colors.red),
          SizedBox(width: 19.w),
          _buildItem(Icons.comment, "25.2k"),
          SizedBox(width: 19.w),
          _buildItem(Icons.redeem, "Donate"),
          SizedBox(width: 19.w),
          _buildItem(Icons.share, "Share"),
        ],
      ),
    );

  }

  Widget _buildItem(IconData icon, String text, [Color? color]) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 20.sp),
        SizedBox(width: 4.w),
        CustomTextView(
          text,
          fontWeight: FontWeight.w500,
          fontSize: 14.sp,
          color: AppColors.followText,
        ),
      ],
    );
  }
}
