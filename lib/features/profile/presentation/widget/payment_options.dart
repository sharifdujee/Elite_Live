import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/global_widget/gradient_radio.dart';

class PaymentOptionTile extends StatelessWidget {

  final int index;
  final String image;
  final bool isSelected;
  final VoidCallback onTap;
  final Gradient gradient;

  const PaymentOptionTile({
    Key? key,
    required this.index,
    required this.image,
    required this.isSelected,
    required this.onTap,
    required this.gradient,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.r),
          gradient: isSelected ? gradient : null,
        ),
        padding: EdgeInsets.all(1), // for the gradient border effect
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: Colors.white, // inner container background
            borderRadius: BorderRadius.circular(15.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(image),
              GradientRadio(
                selected: isSelected,
                onTap: onTap,
                gradient: gradient,
              ),
            ],
          ),
        ),
      ),
    );
  }
}