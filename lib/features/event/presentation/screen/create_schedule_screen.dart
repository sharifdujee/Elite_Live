import 'dart:developer';

import 'package:elites_live/core/global/custom_elevated_button.dart';
import 'package:elites_live/core/utils/constants/image_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/global/custom_text_field.dart';
import '../../../../core/global/custom_text_view.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../controller/schedule_controller.dart';

class CreateScheduleScreen extends StatelessWidget {
  CreateScheduleScreen({super.key});

  final ScheduleController controller = Get.put(ScheduleController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Column(
        children: [
          /// Gradient Header
          Container(
            
            height: 140.h,
            width: double.infinity,
            decoration:  BoxDecoration(

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
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 24.sp,
                      ),
                    ),
                    SizedBox(width: 32.h),
                    CustomTextView(
                      "Create Schedule",
                      fontWeight: FontWeight.w600,
                      fontSize: 20.sp,
                      color: AppColors.white,
                    ),
                  ],
                ),
              ),
            ),
          ),

          /// White Card Container
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: AssetImage(ImagePath.user),
                        ),
                        SizedBox(width: 8.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextView(
                              "Jolie Topley",
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textHeader,
                            ),
                            SizedBox(height: 2.h),
                            CustomTextView(
                              "Model",
                              fontWeight: FontWeight.w400,
                              fontSize: 12.sp,
                              color: AppColors.textBody,
                            ),
                          ],
                        ),
                      ],
                    ),

                    // ... avatar and name ...
                    SizedBox(height: 32.h),
                    CustomTextField(
                      hintText: "Write something here",
                      maxLines: 10,
                    ),

                    SizedBox(height: 12.h),
                    CustomTextView(
                      "Schedule Date",
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.liveText,
                    ),
                    SizedBox(height: 8.h),
                    GestureDetector(
                      onTap: (){
                        log("The onTap is press");
                        controller.pickDate(context);
                      },
                      child: AbsorbPointer(
                        absorbing: true,
                        child: Obx(
                          () => CustomTextField(
                            hintText:
                                controller.selectedDate.value.isEmpty
                                    ? "Select Date"
                                    : "Date: ${controller.selectedDate.value}",
                            isReadonly: true,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 12.h),
                    CustomTextView(
                      "Time",
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.liveText,
                    ),
                    SizedBox(height: 8.h),

                    /*
                    Expanded(
                          child: GestureDetector(
                            onTap: () {

                              Get.toNamed(AppRoute.createPost);
                            },
                            child: AbsorbPointer(
                              absorbing: true,
                              child: CustomTextField(
                                hintText: "Write something",
                                isReadonly: true,
                              ),
                            ),
                          ),
                        )
                     */
                    GestureDetector(
                      onTap: (){
                        log("the button is press");
                        controller.pickTime(context);
                      },
                      child: AbsorbPointer(
                        absorbing: true,
                        child: Obx(
                          () => CustomTextField(
                            hintText:
                                controller.selectedTime.value.isEmpty
                                    ? "Select Time"
                                    : "Time: ${controller.selectedTime.value}",
                            isReadonly: true,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 12.h),
                    CustomTextView(
                      "Pay Amount",
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.liveText,
                    ),
                    SizedBox(height: 8.h),
                    CustomTextField(hintText: "\$2 Pay"),

                    SizedBox(height: 32.h),
                    CustomElevatedButton(
                      ontap: () {
                        // Access the selected values
                        log("Date: ${controller.selectedDate.value}");
                        log("Time: ${controller.selectedTime.value}");
                      },
                      text: "Post",
                    ),
                    SizedBox(height: 20.h),
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
