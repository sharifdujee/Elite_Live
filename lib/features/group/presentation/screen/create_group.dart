
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/global/custom_elevated_button.dart';
import '../../../../core/global/custom_text_field.dart';
import '../../../../core/global/custom_text_view.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../controller/create_group_controller.dart';
import '../widget/group_image_upload_section.dart';



class CreateGroupScreen extends StatelessWidget {
  const CreateGroupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CreateGroupController());

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Column(
        children: [
          /// Gradient Header
          Container(
            height: 130.h,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Icon(Icons.arrow_back,
                          color: Colors.white, size: 24.sp),
                    ),
                    SizedBox(width: 12.w),
                    CustomTextView(
                      "Create Group",
                      fontWeight: FontWeight.w600,
                      fontSize: 20.sp,
                      color: AppColors.white,
                    )
                  ],
                ),
              ),
            ),
          ),

          /// White Card Container
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                  BorderRadius.vertical(top: Radius.circular(24.r)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Group Name Field
                    CustomTextView(
                      "Group name",
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                      color: AppColors.textHeader,
                    ),
                    SizedBox(height: 12.h),
                    CustomTextField(
                      controller: controller.groupNameController,
                      hintText: "Enter group name",
                    ),
                    SizedBox(height: 24.h),

                    /// Upload Photo Section
                    CustomTextView(
                      "Upload Photo",
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                      color: AppColors.textHeader,
                    ),
                    SizedBox(height: 12.h),

                    /// Image Preview and Upload Button


                    GroupImageUploadSection(controller: controller),




                    SizedBox(height: 24.h),

                    /// Description Field
                    CustomTextView(
                      "Description",
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                      color: AppColors.textHeader,
                    ),
                    SizedBox(height: 12.h),
                    CustomTextField(
                      controller: controller.descriptionController,
                      maxLines: 5,
                      hintText: "Enter group description",
                    ),

                    SizedBox(height: 24.h),

                    /// Make Group Public Toggle
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: Color(0xFFF5F3FF),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Icon(
                            Icons.public,
                            size: 20.sp,
                            color: Color(0xFF8E2DE2),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Make this group public',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                'Anyone can join this group',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Obx(() => Switch(
                          value: controller.isPublic.value,
                          onChanged: (value) {
                            controller.isPublic.value = value;
                          },
                          activeThumbColor: Color(0xFF8E2DE2),
                        )),
                      ],
                    ),

                    SizedBox(height: 32.h),

                    /// Create Button
                    CustomElevatedButton(
                      ontap: controller.createGroup,
                      text: "Create",
                      gradient: AppColors.primaryGradient,
                    ),

                    SizedBox(height: 16.h),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}




