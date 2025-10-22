

import 'package:elites_live/core/utils/constants/app_colors.dart';
import 'package:elites_live/core/utils/constants/image_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/global/custom_elevated_button.dart';
import '../../controller/create_group_controller.dart';


class GroupImageUploadSection extends StatelessWidget {
  const GroupImageUploadSection({
    super.key,
    required this.controller,
  });

  final CreateGroupController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 1.w,
          color: AppColors.primaryColor
        )
      ),

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
                  ///backgroundColor: AppColors.primaryColor,
                  widths: 160.w,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
