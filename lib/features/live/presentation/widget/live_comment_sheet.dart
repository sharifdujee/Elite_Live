import 'dart:io';

import 'package:elites_live/features/home/controller/live_controller.dart';
import 'package:elites_live/features/home/presentation/widget/vote_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/global_widget/custom_text_view.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../home/controller/home_controller.dart';
import '../../../home/data/comment_data_model.dart';
import '../../../home/presentation/widget/comment_input_box.dart';

class LiveCommentSheet extends StatelessWidget {
  final HomeController controller = Get.find<HomeController>();
  final liveController = Get.put(LiveController());
  final RxString replyingToId = ''.obs;
  final RxString replyingToName = ''.obs;

  LiveCommentSheet({super.key});

  void show(BuildContext context) {
    Get.bottomSheet(
      this,
      isScrollControlled: true,
    );
  }

  Widget _buildCommentTile(Comment comment) {
    return GestureDetector(
      onTap: () {
        replyingToId.value = comment.id;
        replyingToName.value = comment.userName;
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Image
            CircleAvatar(
              backgroundImage: AssetImage(comment.userImage),
              radius: 20.r,
            ),
            SizedBox(width: 12.w),

            // Comment content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Username and time
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomTextView(
                        comment.userName,
                        fontWeight: FontWeight.w600,
                        fontSize: 12.sp,
                        color: AppColors.textHeader,
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),

                  // Comment text
                  if (comment.text.isNotEmpty)
                    CustomTextView(
                      comment.text,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textBody,
                    ),

                  // Image (if exists)
                  if (comment.imagePath != null)
                    Padding(
                      padding: EdgeInsets.only(top: 8.h),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.r),
                        child: Image.file(
                          File(comment.imagePath!),
                          height: 120.h,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                  SizedBox(height: 8.h),

                  // Like and Reply
                  Row(
                    children: [
                      CustomTextView(
                        _getTimeAgo(comment.timestamp),
                        fontWeight: FontWeight.w400,
                        fontSize: 10.sp,
                        color: AppColors.textHeader,
                      ),
                      SizedBox(width: 16.w),
                      GestureDetector(
                        onTap: () => controller.toggleLike(comment.id),
                        child: CustomTextView(
                          comment.isLiked.value ? "Liked" : "Like",
                          color: AppColors.textHeader,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      GestureDetector(
                        onTap: () {
                          replyingToId.value = comment.id;
                          replyingToName.value = comment.userName;
                        },
                        child: CustomTextView(
                          "Reply",
                          color: AppColors.textHeader,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          VoteDetailsBottomSheet(controller: liveController),
          // Header
          Container(
            margin:  EdgeInsets.all(16.sp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() => replyingToId.value.isNotEmpty
                    ? Text(
                  "Replying to ${replyingToName.value}",
                  style: const TextStyle(fontWeight: FontWeight.w600),
                )
                    : const SizedBox.shrink()),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
          ),
          Divider(height: 1.h),

          // Comments List
          Expanded(
            child: Obx(() => ListView.builder(
              padding:  EdgeInsets.all(16.sp),
              itemCount: controller.comments.length,
              itemBuilder: (context, index) {
                final comment = controller.comments[index];
                return _buildCommentTile(comment);
              },
            )),
          ),

          /// Comment Input
          CommentInputBox(),

        ],
      ),
    );
  }
  String _getTimeAgo(DateTime timestamp) {
    final Duration diff = DateTime.now().difference(timestamp);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    if (diff.inDays < 7) return '${diff.inDays}d';
    return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
  }
}