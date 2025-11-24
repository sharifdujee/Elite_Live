import 'package:elites_live/core/global_widget/custom_text_view.dart';
import 'package:elites_live/core/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DesignationSection extends StatelessWidget {
  final String? designation;
  final String? timeAgo;

  const DesignationSection({
    super.key,
    this.designation,
    this.timeAgo,
  });

  @override
  Widget build(BuildContext context) {
    // Safe strings
    final String des = (designation ?? "N/A").trim();
    final String time = (timeAgo ?? "${DateTime.now().day}").trim();

    final bool hasDesignation = des.isNotEmpty;
    final bool hasTimeAgo = time.isNotEmpty;

    return Row(
      children: [
        /// DESIGNATION
        if (hasDesignation)
          Expanded(
            child: CustomTextView(
            text:   des,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,

                fontSize: 10.sp,
                color: AppColors.textHeader,

            ),
          ),

        /// SPACING between items
        if (hasDesignation && hasTimeAgo)
          SizedBox(width: 8.w),

        /// TIME AGO
        if (hasTimeAgo)
          Expanded(
            child: CustomTextView(
             text:  time,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,

                fontSize: 10.sp,
                color: AppColors.textHeader,

            ),
          ),
      ],
    );
  }
}
