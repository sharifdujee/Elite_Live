import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../controller/notification_controller.dart';
import '../../data/notification_data_model.dart';

class NotificationItem extends StatelessWidget {
  final NotificationModel notification;
  final NotificationController controller;

  const NotificationItem({
    super.key,
    required this.notification,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        controller.markAsRead(notification.id);
        // Navigate to relevant screen
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        color: notification.isRead ? Colors.white : Colors.purple[50]?.withOpacity(0.3),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// User Avatar
            CircleAvatar(
              radius: 24.r,
              backgroundImage: NetworkImage(notification.userImage),
            ),
            SizedBox(width: 12.w),

            /// Notification Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Text(
                              notification.userName,
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            if (notification.isVerified) ...[
                              SizedBox(width: 4.w),
                              Icon(
                                Icons.verified,
                                size: 16.sp,
                                color: const Color(0xFF8E2DE2),
                              ),
                            ],
                          ],
                        ),
                      ),
                      Text(
                        controller.getTimeAgo(notification.timestamp),
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    notification.message,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}