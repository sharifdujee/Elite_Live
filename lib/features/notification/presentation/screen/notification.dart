import 'package:elites_live/core/global/custom_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../controller/notification_controller.dart';
import '../widget/notification_item.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NotificationController());

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          /// Gradient Header
        Container(
        height: 190.h,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppColors.primaryGradient,
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
                    SizedBox(width: 12.w),
                    Text(
                      "Notification",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20.sp,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          /// Notification List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return Center(
                  child: CustomLoading(color: AppColors.primaryColor),
                );
              }

              if (controller.notifications.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.notifications_none,
                        size: 64.sp,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'No notifications yet',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                );
              }

              final groupedNotifications = controller.groupedNotifications;
              final dateKeys = groupedNotifications.keys.toList();

              return ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: dateKeys.length,
                itemBuilder: (context, index) {
                  final dateKey = dateKeys[index];
                  final notificationList = groupedNotifications[dateKey]!;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Date Header
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 12.h,
                        ),
                        color: Colors.grey[100],
                        child: Text(
                          dateKey,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                          ),
                        ),
                      ),

                      /// Notification Items
                      Container(
                        color: Colors.white,
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: notificationList.length,
                          separatorBuilder:
                              (context, index) => Divider(
                                height: 1,
                                thickness: 1,
                                color: Colors.grey[200],
                                indent: 80.w,
                              ),
                          itemBuilder: (context, notifIndex) {
                            final notification = notificationList[notifIndex];
                            return NotificationItem(
                              notification: notification,
                              controller: controller,
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 12.h),
                    ],
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
