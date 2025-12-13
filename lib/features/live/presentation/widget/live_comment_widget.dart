

// lib/features/live/presentation/widget/live_comment_widget.dart

import 'package:elites_live/core/global_widget/custom_loading.dart';
import 'package:elites_live/core/global_widget/custom_text_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:elites_live/core/utils/constants/app_colors.dart';
import '../../controller/live_comment_controller.dart';
import '../../data/live_comment_data_model.dart';




/*
class LiveCommentWidget extends StatefulWidget {
  final String? eventId;
  final String? streamId;
  final bool isFromEvent;

  const LiveCommentWidget({
    Key? key,
    this.eventId,
    this.streamId,
    required this.isFromEvent,
  }) : super(key: key);

  @override
  State<LiveCommentWidget> createState() => _LiveCommentWidgetState();
}

class _LiveCommentWidgetState extends State<LiveCommentWidget> {
  final LiveCommentController commentController = Get.put(LiveCommentController());
  final TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initializeComments();
  }

  Future<void> _initializeComments() async {
    try {
      if (widget.isFromEvent && widget.eventId != null) {
        await commentController.initializeForEvent(widget.eventId!);
      } else if (!widget.isFromEvent && widget.streamId != null) {
        await commentController.initializeForFreeLive(widget.streamId!);
      }
    } catch (e) {
      debugPrint("Error initializing comments: $e");
    }
  }

  void _sendComment() {
    final text = textController.text.trim();
    if (text.isEmpty) return;

    commentController.sendComment(text).then((_) {
      textController.clear();
    }).catchError((e) {
      // Error already shown by controller
    });
  }

  @override
  void dispose() {
    textController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black.withValues(alpha: 0.3),
            Colors.black.withValues(alpha: 0.7),
          ],
        ),
      ),
      child: Column(
        children: [
          // ✅ NEW: Connection Status Bar
          Obx(() {
            if (commentController.isConnecting.value) {
              return _buildConnectionStatus(
                icon: Icons.hourglass_empty,
                text: "Connecting to chat...",
                color: Colors.orange,
              );
            } else if (commentController.connectionError.value.isNotEmpty) {
              return _buildConnectionStatus(
                icon: Icons.error_outline,
                text: "Connection failed",
                color: Colors.red,
                showRetry: true,
              );
            } else if (!commentController.isJoined.value) {
              return _buildConnectionStatus(
                icon: Icons.info_outline,
                text: "Not connected to chat",
                color: Colors.grey,
              );
            }
            return SizedBox.shrink();
          }),

          // Comments List
          Expanded(
            child: Obx(() {
              // ✅ Show loading state
              if (commentController.isConnecting.value) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomLoading(color: AppColors.primaryColor),
                      SizedBox(height: 12.h),
                      Text(
                        'Connecting to chat...',
                        style: TextStyle(color: Colors.white70, fontSize: 14.sp),
                      ),
                    ],
                  ),
                );
              }

              // ✅ Show error state with retry
              if (commentController.connectionError.value.isNotEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, color: Colors.red, size: 48.sp),
                      SizedBox(height: 12.h),
                      Text(
                        'Failed to connect to chat',
                        style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        commentController.connectionError.value,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white70, fontSize: 12.sp),
                      ),
                      SizedBox(height: 16.h),
                      ElevatedButton.icon(
                        onPressed: () => commentController.retryConnection(),
                        icon: Icon(Icons.refresh),
                        label: Text('Retry'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                );
              }

              // ✅ Show empty state
              if (commentController.comments.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.chat_bubble_outline, color: Colors.white54, size: 48.sp),
                      SizedBox(height: 12.h),
                      Text(
                        'No comments yet',
                        style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Be the first to comment!',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white70, fontSize: 14.sp),
                      ),
                    ],
                  ),
                );
              }

              // ✅ Show comments
              return ListView.builder(
                controller: scrollController,
                reverse: true,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                itemCount: commentController.comments.length,
                itemBuilder: (context, index) {
                  final comment = commentController.comments[index];
                  return _buildCommentItem(comment);
                },
              );
            }),
          ),

          // Comment Input Box
          _buildCommentInput(),
        ],
      ),
    );
  }

  // ✅ NEW: Connection Status Widget
  Widget _buildConnectionStatus({
    required IconData icon,
    required String text,
    required Color color,
    bool showRetry = false,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      color: color.withValues(alpha: 0.2),
      child: Row(
        children: [
          Icon(icon, color: color, size: 16.sp),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: color, fontSize: 12.sp, fontWeight: FontWeight.w500),
            ),
          ),
          if (showRetry)
            GestureDetector(
              onTap: () => commentController.retryConnection(),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  'Retry',
                  style: TextStyle(color: Colors.white, fontSize: 11.sp, fontWeight: FontWeight.w600),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCommentItem(LiveComment comment) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Avatar
          CircleAvatar(
            radius: 16.r,
            backgroundImage: comment.userImage.isNotEmpty
                ? NetworkImage(comment.userImage)
                : null,
            backgroundColor: AppColors.primaryColor,
            child: comment.userImage.isEmpty
                ? Text(
              comment.userName[0].toUpperCase(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            )
                : null,
          ),
          SizedBox(width: 10.w),

          // Comment Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User Name
                Text(
                  comment.userName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4.h),

                // Comment Text
                CustomTextView(
                 text:  comment.comment,

                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 13.sp,

                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentInput() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.6),
        border: Border(
          top: BorderSide(
            color: Colors.white.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Obx(() {
          // ✅ Disable input if not connected
          final isDisabled = !commentController.isJoined.value ||
              commentController.isConnecting.value;

          return Row(
            children: [
              // Text Input
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(isDisabled ? 0.05 : 0.1),
                    borderRadius: BorderRadius.circular(24.r),
                    border: Border.all(
                      color: Colors.white.withOpacity(isDisabled ? 0.1 : 0.2),
                      width: 1,
                    ),
                  ),
                  child: TextField(
                    controller: textController,
                    enabled: !isDisabled,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                    ),
                    decoration: InputDecoration(
                      hintText: isDisabled ? 'Connecting...' : 'Add a comment...',
                      hintStyle: TextStyle(
                        color: Colors.white.withValues(alpha: 0.5),
                        fontSize: 14.sp,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 10.h,
                      ),
                    ),
                    maxLines: 1,
                    textInputAction: TextInputAction.send,
                    onSubmitted: isDisabled ? null : (_) => _sendComment(),
                  ),
                ),
              ),

              SizedBox(width: 8.w),

              // Send Button
              GestureDetector(
                onTap: (commentController.isSending.value || isDisabled)
                    ? null
                    : _sendComment,
                child: Container(
                  width: 44.w,
                  height: 44.h,
                  decoration: BoxDecoration(
                    gradient: (commentController.isSending.value || isDisabled)
                        ? LinearGradient(
                      colors: [Colors.grey, Colors.grey.shade700],
                    )
                        : LinearGradient(
                      colors: [
                        AppColors.primaryColor,
                        AppColors.secondaryColor,
                      ],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: isDisabled ? [] : [
                      BoxShadow(
                        color: AppColors.primaryColor.withValues(alpha: 0.3),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: commentController.isSending.value
                      ? Center(
                    child: SizedBox(
                      width: 18.w,
                      height: 18.h,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    ),
                  )
                      : Icon(
                    Icons.send,
                    color: Colors.white,
                    size: 20.sp,
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}*/


class LiveCommentWidget extends StatefulWidget {
  final String? eventId;
  final String? streamId;
  final bool isFromEvent;

  const LiveCommentWidget({
    Key? key,
    this.eventId,
    this.streamId,
    required this.isFromEvent,
  }) : super(key: key);

  @override
  State<LiveCommentWidget> createState() => _LiveCommentWidgetState();
}

class _LiveCommentWidgetState extends State<LiveCommentWidget> {
  final LiveCommentController commentController = Get.put(LiveCommentController());
  final TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initializeComments();
  }

  Future<void> _initializeComments() async {
    try {
      if (widget.isFromEvent && widget.eventId != null) {
        await commentController.initializeForEvent(widget.eventId!);
      } else if (!widget.isFromEvent && widget.streamId != null) {
        await commentController.initializeForFreeLive(widget.streamId!);
      }
    } catch (e) {
      debugPrint("Error initializing comments: $e");
    }
  }

  void _sendComment() {
    final text = textController.text.trim();
    if (text.isEmpty) return;

    commentController.sendComment(text).then((_) {
      textController.clear();
    }).catchError((e) {
      // Error already shown by controller
    });
  }

  @override
  void dispose() {
    textController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black.withValues(alpha: 0.3),
            Colors.black.withValues(alpha: 0.7),
          ],
        ),
      ),
      child: Column(
        children: [
          // Connection Status Bar
          Obx(() {
            if (commentController.isConnecting.value) {
              return _buildConnectionStatus(
                icon: Icons.hourglass_empty,
                text: "Connecting to chat...",
                color: Colors.orange,
              );
            } else if (commentController.connectionError.value.isNotEmpty) {
              return _buildConnectionStatus(
                icon: Icons.error_outline,
                text: "Connection failed",
                color: Colors.red,
                showRetry: true,
              );
            } else if (!commentController.isJoined.value) {
              return _buildConnectionStatus(
                icon: Icons.info_outline,
                text: "Not connected to chat",
                color: Colors.grey,
              );
            }
            // NEW: Show warning count if user has violations
            else if (commentController.warningCount.value > 0) {
              return _buildWarningBanner();
            }
            return SizedBox.shrink();
          }),

          // Comments List
          Expanded(
            child: Obx(() {
              // Show loading state
              if (commentController.isConnecting.value) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomLoading(color: AppColors.primaryColor),
                      SizedBox(height: 12.h),
                      Text(
                        'Connecting to chat...',
                        style: TextStyle(color: Colors.white70, fontSize: 14.sp),
                      ),
                    ],
                  ),
                );
              }

              // Show error state with retry
              if (commentController.connectionError.value.isNotEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, color: Colors.red, size: 48.sp),
                      SizedBox(height: 12.h),
                      Text(
                        'Failed to connect to chat',
                        style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        commentController.connectionError.value,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white70, fontSize: 12.sp),
                      ),
                      SizedBox(height: 16.h),
                      ElevatedButton.icon(
                        onPressed: () => commentController.retryConnection(),
                        icon: Icon(Icons.refresh),
                        label: Text('Retry'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                );
              }

              // Show empty state
              if (commentController.comments.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.chat_bubble_outline, color: Colors.white54, size: 48.sp),
                      SizedBox(height: 12.h),
                      Text(
                        'No comments yet',
                        style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Be the first to comment!',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white70, fontSize: 14.sp),
                      ),
                    ],
                  ),
                );
              }

              // Show comments
              return ListView.builder(
                controller: scrollController,
                reverse: true,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                itemCount: commentController.comments.length,
                itemBuilder: (context, index) {
                  final comment = commentController.comments[index];
                  return _buildCommentItem(comment);
                },
              );
            }),
          ),

          // Comment Input Box
          _buildCommentInput(),
        ],
      ),
    );
  }

  // Connection Status Widget
  Widget _buildConnectionStatus({
    required IconData icon,
    required String text,
    required Color color,
    bool showRetry = false,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      color: color.withValues(alpha: 0.2),
      child: Row(
        children: [
          Icon(icon, color: color, size: 16.sp),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: color, fontSize: 12.sp, fontWeight: FontWeight.w500),
            ),
          ),
          if (showRetry)
            GestureDetector(
              onTap: () => commentController.retryConnection(),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  'Retry',
                  style: TextStyle(color: Colors.white, fontSize: 11.sp, fontWeight: FontWeight.w600),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // NEW: Warning Banner Widget
  Widget _buildWarningBanner() {
    return Obx(() {
      final count = commentController.warningCount.value;
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange.shade700, Colors.red.shade600],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.orange.withOpacity(0.3),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.warning_amber_rounded,
                color: Colors.white,
                size: 18.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Community Guidelines Warning',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    '$count violation${count > 1 ? 's' : ''} detected',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildCommentItem(LiveComment comment) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Avatar
          CircleAvatar(
            radius: 16.r,
            backgroundImage: comment.userImage.isNotEmpty
                ? NetworkImage(comment.userImage)
                : null,
            backgroundColor: AppColors.primaryColor,
            child: comment.userImage.isEmpty
                ? Text(
              comment.userName[0].toUpperCase(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            )
                : null,
          ),
          SizedBox(width: 10.w),

          // Comment Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User Name
                Text(
                  comment.userName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4.h),

                // Comment Text
                CustomTextView(
                  text: comment.comment,
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 13.sp,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentInput() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.6),
        border: Border(
          top: BorderSide(
            color: Colors.white.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Obx(() {
          // Disable input if not connected or banned
          final isDisabled = !commentController.isJoined.value ||
              commentController.isConnecting.value ||
              commentController.isBanned.value;

          // NEW: Check if user is banned
          final isBanned = commentController.isBanned.value;

          return Row(
            children: [
              // Text Input
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(
                        isBanned ? 0.03 : (isDisabled ? 0.05 : 0.1)
                    ),
                    borderRadius: BorderRadius.circular(24.r),
                    border: Border.all(
                      color: isBanned
                          ? Colors.red.withOpacity(0.3)
                          : Colors.white.withOpacity(isDisabled ? 0.1 : 0.2),
                      width: 1,
                    ),
                  ),
                  child: TextField(
                    controller: textController,
                    enabled: !isDisabled,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                    ),
                    decoration: InputDecoration(
                      hintText: isBanned
                          ? 'You are banned from commenting'
                          : (isDisabled ? 'Connecting...' : 'Add a comment...'),
                      hintStyle: TextStyle(
                        color: isBanned
                            ? Colors.red.withValues(alpha: 0.6)
                            : Colors.white.withValues(alpha: 0.5),
                        fontSize: 14.sp,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 10.h,
                      ),
                    ),
                    maxLines: 1,
                    textInputAction: TextInputAction.send,
                    onSubmitted: isDisabled ? null : (_) => _sendComment(),
                  ),
                ),
              ),

              SizedBox(width: 8.w),

              // Send Button
              GestureDetector(
                onTap: (commentController.isSending.value || isDisabled)
                    ? null
                    : _sendComment,
                child: Container(
                  width: 44.w,
                  height: 44.h,
                  decoration: BoxDecoration(
                    gradient: (commentController.isSending.value || isDisabled)
                        ? LinearGradient(
                      colors: [Colors.grey, Colors.grey.shade700],
                    )
                        : LinearGradient(
                      colors: [
                        AppColors.primaryColor,
                        AppColors.secondaryColor,
                      ],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: isDisabled ? [] : [
                      BoxShadow(
                        color: AppColors.primaryColor.withValues(alpha: 0.3),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: commentController.isSending.value
                      ? Center(
                    child: SizedBox(
                      width: 18.w,
                      height: 18.h,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    ),
                  )
                      : Icon(
                    isBanned ? Icons.block : Icons.send,
                    color: Colors.white,
                    size: 20.sp,
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
