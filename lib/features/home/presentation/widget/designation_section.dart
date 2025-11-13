import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/global_widget/custom_text_view.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/icon_path.dart';

class DesignationSection extends StatelessWidget {
  final String designation;
  final String? timeAgo;

  const DesignationSection({
    super.key,
    required this.designation,
    this.timeAgo,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          designation,
          style: TextStyle(
            fontSize: 10.sp,
            color: Colors.grey[600],
          ),
        ),
        if (timeAgo != null) ...[
          SizedBox(width: 8.w),
          Text(
            '• $timeAgo',
            style: TextStyle(
              fontSize: 10.sp,
              color: Colors.grey[600],
            ),
          ),
        ],
      ],
    );
  }
}