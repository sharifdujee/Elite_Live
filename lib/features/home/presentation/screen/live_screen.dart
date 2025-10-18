
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/live_controller.dart';
import '../widget/live_content_section.dart';
import '../widget/pool_bottom_sheet.dart';
import '../widget/vote_bottom_sheet.dart';


class LiveScreen extends StatelessWidget {
  const LiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LiveController());

    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.grey.shade800,
                  Colors.grey.shade600,
                ],
              ),
            ),
          ),

          // Main Content
          LiveContentSection(controller: controller),

          // Ad Widget (Overlay)
          Obx(() => controller.showAd.value
              ? AdWidget(onDismiss: controller.dismissAd)
              : const SizedBox.shrink()),

          // Poll Bottom Sheet
          Obx(() => controller.showPollSheet.value
              ? PollBottomSheet(controller: controller)
              : const SizedBox.shrink()),

          // Vote Bottom Sheet
          Obx(() => controller.showVoteSheet.value
              ? VoteDetailsBottomSheet(controller: controller)
              : const SizedBox.shrink()),
        ],
      ),
    );

  }
}




class AdWidget extends StatelessWidget {
  final VoidCallback onDismiss;

  const AdWidget({
    super.key,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 40,
      left: 16,
      child: Container(
        width: 62,
        height: 62,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(31),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Ad label
            Center(
              child: Text(
                'Ad',
                style: TextStyle(
                  color: Colors.grey.shade800,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            // Close button
            Positioned(
              right: 0,
              top: 0,
              child: GestureDetector(
                onTap: onDismiss,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade800,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}




























