import 'package:elites_live/core/global_widget/custom_text_view.dart';
import 'package:elites_live/core/services/duration_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../../controller/home_controller.dart';
import '../../controller/video_player_controller.dart';

class VideoPlayerSection extends StatelessWidget {
   VideoPlayerSection({super.key});
   final controller = Get.find<HomeController>();

   final VideoController videoController = Get.find();

  @override
  Widget build(BuildContext context) {
    return  Container(
      margin: EdgeInsets.symmetric(vertical: 16.h),
      /*height: 220.h,
                  width: 375.w,*/
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF000000).withValues(alpha: 0.1),
            const Color(0xFF000000),
          ],
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Obx(() {
        final controller = videoController;
        final isInitialized =
            controller.videoPlayerController.value.isInitialized;
        final isPlaying = controller.isPlaying.value;
        final isMuted = controller.isMuted.value;
        final pos = controller.position.value;
        final dur = controller.duration.value;
        final progress =
        dur.inMilliseconds > 0
            ? pos.inMilliseconds / dur.inMilliseconds
            : 0.0;

        return Stack(
          alignment: Alignment.center,
          children: [
            // Video Player
            if (isInitialized)
              AspectRatio(
                aspectRatio:
                controller
                    .videoPlayerController
                    .value
                    .aspectRatio,
                child: VideoPlayer(
                  controller.videoPlayerController,
                ),
              )
            else
              const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),

            // Play / Pause Button
            IconButton(
              iconSize: 60.sp,
              onPressed: controller.togglePlayPause,
              icon: Icon(
                isPlaying
                    ? Icons.pause_circle_filled_rounded
                    : Icons.play_circle_fill_rounded,
                color: Colors.white.withOpacity(0.9),
              ),
            ),

            // Bottom Controls
            Positioned(
              bottom: 2.h,
              left: 12.w,
              right: 12.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SliderTheme(
                    data: SliderThemeData(
                      trackHeight: 3.h,
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 5,
                      ),
                    ),
                    child: Slider(
                      value: progress.clamp(0.0, 1.0),
                      activeColor: Colors.blueAccent,
                      inactiveColor: Colors.white30,
                      onChanged: (value) {
                        final newPosition = dur * value;
                        controller.videoPlayerController.seekTo(
                          newPosition,
                        );
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      CustomTextView(       text: Format.formatDuration(pos)), 
                      Row(
                        children: [
                          GestureDetector(
                            onTap: controller.toggleMute,
                            child: Icon(
                              isMuted
                                  ? Icons.volume_off
                                  : Icons.volume_up,
                              color: Colors.white,
                              size: 20.sp,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          CustomTextView(       text: Format.formatDuration(dur))

                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
