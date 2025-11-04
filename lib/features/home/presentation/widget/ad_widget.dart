
import 'package:elites_live/core/global_widget/custom_text_view.dart';
import 'package:elites_live/core/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdWidget extends StatelessWidget {
  final VoidCallback onDismiss;
  final int secondsRemaining;
  final String backgroundImagePath;

  const AdWidget({
    super.key,
    required this.onDismiss,
    required this.secondsRemaining,
    required this.backgroundImagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Stack(
        fit: StackFit.expand,
        children: [
          // 🔹 Background image
          Image.asset(
            backgroundImagePath,
            fit: BoxFit.cover,
            color: Colors.black.withValues(alpha: 0.3), // Optional dark overlay
            colorBlendMode: BlendMode.darken,
          ),

          // 🔹 Close button (top-right)
          Positioned(
            right: 16,
            top: 40,
            child: GestureDetector(
              onTap: onDismiss,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey.shade800,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.close,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          // 🔹 "Ad" label (top-left)
          Positioned(
            top: 40,
            left: 16,
            child: Container(
              width: 62,
              height: 62,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(31),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  'Ad',
                  style: TextStyle(
                    color: Colors.grey.shade800,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),

          // 🔹 Timer at bottom center
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: Center(
              child: Column(
                children: [
                  CustomTextView('00:${secondsRemaining.toString().padLeft(2, '0')}',fontWeight: FontWeight.w600,fontSize: 18.sp,color: AppColors.white,),
                  SizedBox(height: 4.h,),
                  CustomTextView('Remaining',fontWeight: FontWeight.w600,fontSize: 18.sp,color: AppColors.white,),
                ],
              )

            ),
          ),
        ],
      ),
    );
  }
}