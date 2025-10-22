import 'package:elites_live/features/live/presentation/widget/contributor_dialog.dart';
import 'package:elites_live/features/live/presentation/widget/live_comment_sheet.dart';
import 'package:elites_live/features/live/presentation/widget/pool_create_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/live_screen_controller.dart';




class MyLiveScreen extends StatelessWidget {
  MyLiveScreen({super.key});

  final LiveScreenController controller = Get.put(LiveScreenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background video feed or screen share
          Obx(() => controller.isScreenSharing.value
              ? Container(
            color: Colors.grey[800],
            child: const Center(
              child: Text(
                'Screen Sharing Content',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
              : Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.grey[900]!,
                  Colors.black,
                ],
              ),
            ),
            child: Obx(() => controller.isCameraOn.value
                ? Container(
              width: double.infinity,
              height: double.infinity,
              child: Image.network(
                'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[800],
                          child: const Center(
                  child: Icon(
                  Icons.person,
                    size: 100,
                    color: Colors.white54,
                  ),
                  ),
                  );
                },
              ),
            )
                : Container(
              color: Colors.black,
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.videocam_off,
                      size: 80,
                      color: Colors.white54,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Camera is off',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            )),
          )),

          // Video feed in top-left corner when screen sharing
          Obx(() => controller.isScreenSharing.value
              ? Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            child: Container(
              width: 120,
              height: 160,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white54, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: controller.isCameraOn.value
                    ? Image.network(
                  'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[800],
                      child: const Center(
                        child: Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.white54,
                        ),
                      ),
                    );
                  },
                )
                    : Container(
                  color: Colors.black,
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.videocam_off,
                          size: 40,
                          color: Colors.white54,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Camera off',
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
              : const SizedBox.shrink()),

          // Top bar with viewer count and back button
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 8,
                left: 16,
                right: 16,
                bottom: 8,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.7),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      _buildControlButton(
                        icon: Icons.arrow_back,
                        onPressed: (){
                          controller.goBack(context);
                        }
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.circle,
                              color: Colors.white,
                              size: 8,
                            ),
                            const SizedBox(width: 6),
                            Obx(() => Text(
                              '${controller.viewerCount.value}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            )),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      '00:45',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom control panel
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom + 16,
                top: 16,
                left: 16,
                right: 16,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.8),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildControlButton(
                    icon: Icons.flip_camera_ios,
                    onPressed: () {
                      Get.snackbar(
                        'Camera',
                        'Switching camera...',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.black87,
                        colorText: Colors.white,
                        duration: const Duration(seconds: 1),
                      );
                    },
                  ),
                  Obx(() => _buildControlButton(
                    icon: controller.isMicOn.value
                        ? Icons.mic
                        : Icons.mic_off,
                    onPressed: controller.toggleMic,
                  )),
                  Obx(() => _buildControlButton(
                    icon: controller.isCameraOn.value
                        ? Icons.videocam
                        : Icons.videocam_off,
                    onPressed: controller.toggleCamera,
                  )),
                  _buildControlButton(
                    icon: Icons.more_vert,
                    onPressed: controller.toggleMenu,
                  ),
                  _buildControlButton(
                    icon: Icons.call_end,
                    backgroundColor: Colors.red,
                    onPressed: (){
                      controller.endCall(context);
                    }
                  ),
                ],
              ),
            ),
          ),

          // Popup menu
          Obx(() => controller.showMenu.value
              ? GestureDetector(
            onTap: controller.closeMenu,
            child: Container(
              color: Colors.black54,
              child: Stack(
                children: [
                  Positioned(
                    bottom: MediaQuery.of(context).padding.bottom + 90,
                    right: 16,
                    child: TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0, end: 1),
                      duration: const Duration(milliseconds: 200),
                      builder: (context, double value, child) {
                        return Transform.scale(
                          scale: value,
                          alignment: Alignment.bottomRight,
                          child: Opacity(
                            opacity: value,
                            child: child,
                          ),
                        );
                      },
                      child: Container(
                        width: 200,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1C1C1E),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.3),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildMenuItem(
                              icon: Icons.person_add_outlined,
                              text: 'Add Contributor',
                              onTap: () {
                                AddContributorDialog.show(context);
                              },
                            ),
                            const Divider(
                              color: Colors.white12,
                              height: 1,
                            ),
                            _buildMenuItem(
                              icon: Icons.chat_bubble_outline,
                              text: 'Comment',
                              onTap: () {
                                LiveCommentSheet().show(context);
                              },
                            ),
                            const Divider(
                              color: Colors.white12,
                              height: 1,
                            ),
                            Obx(() => _buildMenuItem(
                              icon: Icons.screen_share_outlined,
                              text: 'Screen Share',
                              onTap: controller.toggleScreenShare,
                              trailing: Switch(
                                value: controller.isScreenSharing.value,
                                onChanged: (value) {
                                  controller.toggleScreenShare();
                                },
                                activeThumbColor: Colors.blue,
                              ),
                            )),
                            const Divider(
                              color: Colors.white12,
                              height: 1,
                            ),
                            _buildMenuItem(
                              icon: Icons.poll_outlined,
                              text: 'Polls',
                              onTap: () {
                                CreatePollDialog.show(context);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
              : const SizedBox.shrink()),

          // Screen sharing indicator
          Obx(() => controller.isScreenSharing.value
              ? Positioned(
            top: MediaQuery.of(context).padding.top + 60,
            left: 150,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.screen_share,
                    color: Colors.white,
                    size: 18,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Screen Sharing',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          )
              : const SizedBox.shrink()),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onPressed,
    Color backgroundColor = const Color(0xFF2C2C2E),
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: backgroundColor,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 28,
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: 22,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              if (trailing != null) trailing,
            ],
          ),
        ),
      ),
    );
  }
}



