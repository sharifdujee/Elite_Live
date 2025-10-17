import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/global/custom_text_view.dart';
import '../../../../core/utils/constants/app_colors.dart';
class LiveDescriptionSection extends StatelessWidget {
  const LiveDescriptionSection({
    super.key,
    required this.description,
  });

  final String description;

  @override
  Widget build(BuildContext context) {
    return CustomTextView(
      description,
      fontSize: 14.sp,
      fontWeight: FontWeight.w400,
      color: AppColors.textBody,
    );
  }
}