import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_colors.dart';

Widget customCircularProgressIndicator({Color? background}) {
  return Container(
    height: 80.h,
    width: 80.w,
    alignment: Alignment.center,
    child: CircularProgressIndicator(
      color: background ?? AppColors.primaryColor,
      strokeWidth: 2,
    ),
  );
}