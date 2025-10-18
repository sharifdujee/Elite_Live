
import 'package:elites_live/core/utils/constants/image_path.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/live_controller.dart';
import '../widget/ad_widget.dart';
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
          Obx(() {
            final controller = Get.find<LiveController>();
            return controller.showAd.value
                ? AdWidget(
              onDismiss: controller.dismissAd,
              secondsRemaining: controller.adCountdown.value,
              backgroundImagePath: ImagePath.ad,
            )
                : const SizedBox.shrink();
          }),


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





































