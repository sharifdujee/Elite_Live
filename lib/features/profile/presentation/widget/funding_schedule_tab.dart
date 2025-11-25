import 'package:elites_live/features/profile/controller/my_crowd_funding_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'dart:developer';
import '../../../../core/global_widget/custom_loading.dart';

import '../../../../core/utils/constants/app_colors.dart';



import '../../data/my_crowd_funding_data_model.dart';



class FundingScheduleTab extends StatelessWidget {
  const FundingScheduleTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MyCrowdFundController>();

    return Obx(() {
      log("UI REBUILD → isLoading: ${controller.isLoading.value} | events: ${controller.events.length}");

      if (controller.isLoading.value) {
        return SizedBox(
          height: 200.h,
          child: Center(child: CustomLoading(color: AppColors.primaryColor)),
        );
      }

      if (controller.events.isEmpty) {
        log("UI: No events → showing empty state");
        return _buildEmptyState();
      }

      log("UI: Rendering ${controller.events.length} event(s)");

      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        itemCount: controller.events.length,
        separatorBuilder: (_, __) => SizedBox(height: 16.h),
        itemBuilder: (context, index) {
          final event = controller.events[index];
          log("Building card for: ${event.text}");

          return EventCard(event: event); // Extracted for clarity
        },
      );
    });
  }

  Widget _buildEmptyState() {
    return SizedBox(
      height: 200.h,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_busy, size: 64.sp, color: Colors.grey[400]),
            SizedBox(height: 16.h),
            Text("No Schedule Available",
                style: GoogleFonts.inter(fontSize: 16.sp, fontWeight: FontWeight.w500)),
            SizedBox(height: 8.h),
            Text("Your scheduled events will appear here",
                style: GoogleFonts.inter(fontSize: 14.sp, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

// Optional: Extract card into widget to avoid rebuild logs spam
class EventCard extends StatelessWidget {
  final Event event;
  const EventCard({required this.event, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      margin: EdgeInsets.only(bottom: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Color(0xFFE8E8E8)),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20.r,
                backgroundImage: event.user.profileImage != null
                    ? NetworkImage(event.user.profileImage!)
                    : null,
                child: event.user.profileImage == null
                    ? Text(event.user.firstName[0].toUpperCase())
                    : null,
              ),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${event.user.firstName} ${event.user.lastName}",
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14.sp)),
                  Text(event.user.profession, style: TextStyle(fontSize: 12.sp, color: Colors.grey[600])),
                ],
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Text(event.eventType, style: TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.w600)),
          ),
          SizedBox(height: 12.h),
          Text(event.text),
          SizedBox(height: 16.h),
          Row(
            children: [
              _reactionIcon(Icons.favorite_border, event.count.eventLike),
              SizedBox(width: 24.w),
              _reactionIcon(Icons.chat_bubble_outline, event.count.eventComment),
              SizedBox(width: 24.w),
              _reactionIcon(Icons.share_outlined, 0, text: "Share"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _reactionIcon(IconData icon, int count, {String text = ""}) {
    return Row(
      children: [
        Icon(icon, size: 20.sp, color: Color(0xFF191919)),
        SizedBox(width: 6.w),
        Text(text.isNotEmpty ? text : count.toString(), style: TextStyle(fontSize: 13.sp)),
      ],
    );
  }
}
