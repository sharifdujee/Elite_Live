import 'package:elites_live/features/profile/controller/following_follwer_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import '../../../../core/global_widget/custom_text_field.dart';
import '../../../../core/global_widget/custom_text_view.dart';
import '../../../../core/utils/constants/app_colors.dart';
import 'package:get/get.dart';

class AddContributorDialog {
  static void show(BuildContext context) {
    final FollowingFollwerController controller = Get.find();

    // Initialize filteredFollowing with full list if not already done
    if (controller.filteredFollowing.isEmpty) {
      controller.filteredFollowing.assignAll(controller.myFollowing);
    }

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          contentPadding: const EdgeInsets.all(20),
          backgroundColor: Colors.white,
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Icon(Icons.arrow_back, color: AppColors.textBody, size: 24.sp),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: CustomTextView(
                        text: "Add Contributor",
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textHeader,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Icon(Icons.close, color: AppColors.textBody, size: 24.sp),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Divider(),

                // Search Field
                CustomTextField(
                  hintText: "Search by Name",
                  onChanged: (value) {
                    controller.searchText.value = value;
                  },
                ),
                SizedBox(height: 24.h),

                // Contributors List
                Flexible(
                  child: Obx(() {
                    final followingList = controller.filteredFollowing;

                    if (followingList.isEmpty) {
                      return Center(
                        child: CustomTextView(
                          text: "No contributors found.",
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textBody,
                        ),
                      );
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: followingList.length,
                      itemBuilder: (context, index) {
                        final following = followingList[index];
                        final firstName = following.user.firstName ?? "";
                        final lastName = following.user.lastName ?? "";
                        final name = "$firstName $lastName";

                        return Container(
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Avatar + Name
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: following.user.profileImage != null
                                        ? NetworkImage(following.user.profileImage!)
                                        : null,
                                    radius: 24.r,
                                    backgroundColor: AppColors.lightGrey,
                                    child: following.user.profileImage == null
                                        ? Icon(Icons.person, size: 24.sp, color: Colors.white)
                                        : null,
                                  ),
                                  SizedBox(width: 8.w),
                                  CustomTextView(
                                    text: name,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.sp,
                                    color: AppColors.textHeader,
                                  ),
                                ],
                              ),

                              // Add Button
                              GestureDetector(
                                onTap: () {
                                  // TODO: implement contributor addition logic
                                  Get.snackbar(
                                    "Contributor Added",
                                    "$name has been added",
                                    snackPosition: SnackPosition.BOTTOM,
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(40.r),
                                    gradient: LinearGradient(
                                      colors: [
                                        AppColors.secondaryColor,
                                        AppColors.primaryColor,
                                      ],
                                    ),
                                  ),
                                  child: CustomTextView(
                                    text: "Add",
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textWhite,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
