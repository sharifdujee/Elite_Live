
import 'package:elites_live/features/group/presentation/widget/user_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/global_widget/custom_text_field.dart';
import '../../../../core/global_widget/custom_text_view.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../controller/group_controller.dart';


class InvitePeopleScreen extends StatelessWidget {
  InvitePeopleScreen({super.key});

  final GroupController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Column(
        children: [
          /// Gradient Header
          Container(
            height: 130.h,
            width: double.infinity,
            decoration: const BoxDecoration(
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
                      onTap: (){
                        Get.back();
                      },
                        child: Icon(Icons.arrow_back, color: Colors.white, size: 24.sp)),
                    SizedBox(width: 12.w),
                    CustomTextView(
                       text:    "Invite People",
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
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
              ),
              child: Column(
                children: [
                  /// Search Bar
                  CustomTextField(
                    hintText: "Search by Name",
                  ),
                  SizedBox(height: 16.h),

                  /// Group List
                  Expanded(
                    child: ListView.builder(
                      itemCount: controller.groupName.length,
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        final userName = controller.userName[index];
                        final userProfession = controller.userDescription[index];
                        final groupImage = controller.userPicture[index];

                        return UserSection(
                          groupName: userName,
                          groupImage: groupImage,
                          userProfession: userProfession,
                        );
                      },
                    ),
                  ),

                  SizedBox(height: 16.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}