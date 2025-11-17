import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../utils/constants/app_colors.dart';

class CustomLoading extends StatelessWidget {
  final Color color;
  final double size;
  final Duration duration;

  const CustomLoading({
    super.key,
    this.color = AppColors.textColor,
    this.size = 60.0,
    this.duration = const Duration(milliseconds: 1200),
  });

  @override
  Widget build(BuildContext context) {
    return SpinKitCircle(color: color, size: size, duration: duration);
  }
}