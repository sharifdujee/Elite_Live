import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/global_widget/custom_text_view.dart';
import '../../../../core/utils/constants/app_colors.dart';

class SubscriptionFeature extends StatelessWidget {
  final String feature;
  final bool isSelected;

  const SubscriptionFeature({
    super.key,
    required this.feature,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          FontAwesomeIcons.checkDouble,
          color: isSelected ? AppColors.primaryColor : AppColors.textBody,
          size: 18.sp,
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: CustomTextView(
            feature,
            fontWeight: FontWeight.w400,
            fontSize: 14.sp,
            color: AppColors.textBody,
          ),
        ),
      ],
    );
  }
}