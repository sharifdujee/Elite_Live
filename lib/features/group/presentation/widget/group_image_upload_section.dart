

import 'package:elites_live/core/utils/constants/app_colors.dart';
import 'package:elites_live/core/utils/constants/image_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';


import '../../../../core/global_widget/custom_elevated_button.dart';
import '../../controller/create_group_controller.dart';


class GroupImageUploadSection extends StatelessWidget {
  const GroupImageUploadSection({
    super.key,
    required this.controller,
  });

  final CreateGroupController controller;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DottedBorderPainter(
        color: AppColors.primaryColor,
        strokeWidth: 1.w,
        gap: 5,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 40.h, horizontal: 30.w),
        child: Center(
          child: Obx(() {
            return controller.selectedImage.value != null
                ? Stack(
              children: [
                // Selected Image
                Container(
                  width: 120.w,
                  height: 120.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF8E2DE2),
                      width: 3,
                    ),
                    image: DecorationImage(
                      image: FileImage(controller.selectedImage.value!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // Remove Button
                Positioned(
                  right: 0,
                  top: 0,
                  child: GestureDetector(
                    onTap: controller.removeImage,
                    child: Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 18.sp,
                      ),
                    ),
                  ),
                ),

                // Edit Button
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: GestureDetector(
                    onTap: controller.showImagePickerBottomSheet,
                    child: Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 18.sp,
                      ),
                    ),
                  ),
                ),
              ],
            )
                : GestureDetector(
              onTap: controller.showImagePickerBottomSheet,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Circular gradient icon background
                  Container(
                      width: 64.w,
                      height: 64.w,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: Image.asset(ImagePath.upload)
                  ),

                  SizedBox(height: 16.h),

                  // Upload text
                  Text(
                    'Upload image',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.black87,
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  SizedBox(height: 16.h),

                  // Gradient bordered button
                  CustomElevatedButton(
                    ontap: controller.showImagePickerBottomSheet,
                    text: "Choose a file",
                    widths: 160.w,
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}

// Custom Painter for Dotted Border
class DottedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;

  DottedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.gap,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(
      _createDottedPath(path, gap),
      paint,
    );
  }

  Path _createDottedPath(Path source, double dashLength) {
    final path = Path();
    for (final metric in source.computeMetrics()) {
      double distance = 0.0;
      bool draw = true;
      while (distance < metric.length) {
        final double length = dashLength;
        if (draw) {
          path.addPath(
            metric.extractPath(distance, distance + length),
            Offset.zero,
          );
        }
        distance += length;
        draw = !draw;
      }
    }
    return path;
  }

  @override
  bool shouldRepaint(DottedBorderPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.gap != gap;
  }
}
