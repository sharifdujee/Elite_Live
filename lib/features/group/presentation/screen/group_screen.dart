
import 'package:elites_live/core/global_widget/custom_text_field.dart';
import 'package:elites_live/core/global_widget/custom_text_view.dart';
import 'package:elites_live/features/group/controller/group_controller.dart';
import 'package:elites_live/routes/app_routing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/global_widget/custom_elevated_button.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../widget/group_section.dart';


class GroupScreen extends StatelessWidget {
  GroupScreen({super.key});

  final GroupController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
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
                          text:     "Group",
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
                        hintText: "Search by Group",
                      ),
                      SizedBox(height: 16.h),

                      /// Group List
                      Expanded(
                        child: ListView.builder(
                          itemCount: controller.groupName.length,
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            final groupName = controller.groupName[index];
                            final groupMember = controller.memberList[index];
                            final groupImage = controller.groupPicture[index];

                            return GroupSection(
                              groupName: groupName,
                              groupMember: groupMember,
                              groupImage: groupImage,
                              buttonText: "Invite",
                              groupStaus: true,

                            );
                          },
                        ),
                      ),

                      SizedBox(height: 16.h),

                      /// Bottom Buttons
                      Row(
                        children: [
                          Expanded(
                            child: CustomElevatedButton(
                              ontap: () {
                                Get.toNamed(AppRoute.discoverGroup);
                              },
                              text: "Discover Group",
                              gradient: AppColors.primaryGradient,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: CustomElevatedButton(
                              ontap: () {
                                Get.toNamed(AppRoute.createGroup);
                              },
                              text: "Create Group",
                              backgroundColor: Colors.white,
                              gradient: LinearGradient(colors: [Colors.white, Colors.white]),
                              textStyle: GoogleFonts.andika(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF8E2DE2),
                              ),
                            ),
                          ),
                        ],
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
    );
  }
}









