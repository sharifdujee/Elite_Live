import 'package:elites_live/features/live/presentation/widget/subscription_feature.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/global_widget/custom_text_view.dart';
import '../../../../core/utils/constants/app_colors.dart';


class SubscriptionPlanCard extends StatelessWidget {
  final String planName;
  final String price;
  final bool isSelected;
  final List<String> features;

  const SubscriptionPlanCard({
    super.key,
    required this.planName,
    required this.price,
    required this.isSelected,
    required this.features,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          width: isSelected ? 2.w : 1.w,
          color: isSelected ? AppColors.primaryColor : Color(0xFFE3E3E9),
        ),
        gradient: isSelected
            ? LinearGradient(
          colors: [
            AppColors.primaryColor.withValues(alpha: 0.05),
            AppColors.secondaryColor.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )
            : null,
        color: isSelected ? null : Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 20.w,
                    height: 20.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primaryColor
                            : Color(0xFFE3E3E9),
                        width: 2.w,
                      ),
                    ),
                    child: isSelected
                        ? Center(
                      child: Container(
                        width: 10.w,
                        height: 10.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    )
                        : null,
                  ),
                  SizedBox(width: 8.w),
                  CustomTextView(
                      text:      planName,
                    fontWeight: FontWeight.w600,
                    fontSize: 18.sp,
                    color: AppColors.textBody,
                  )
                ],
              ),
              CustomTextView(
                     text:   price,
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textBody,
              ),
            ],
          ),
          ///SizedBox(height: 16.h),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: features.length,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.only(bottom: 8.h),
                child: SubscriptionFeature(
                  feature: features[index],
                  isSelected: isSelected,
                ),
              );
            },
          )
        ],
      ),
    );
  }
}