import 'package:elites_live/core/global_widget/custom_loading.dart';
import 'package:elites_live/core/global_widget/custom_text_view.dart';
import 'package:elites_live/core/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';


import '../../controller/schedule_controller.dart';

class RecordedLiveSession extends StatelessWidget {
  RecordedLiveSession({super.key, required this.userId});

  final String userId;
  final ScheduleController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    Future.microtask(() => controller.getOthersUserScheduleEvent(userId));

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Obx(() {
        // Loading State
        if (controller.isLoading.value) {
          return Center(
            child: CustomLoading(color: AppColors.primaryColor),
          );
        }

        // Empty State
        if (controller.otherScheduleEvent.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.video_library_outlined,
                  size: 80.sp,
                  color: Colors.grey.shade400,
                ),
                SizedBox(height: 16.h),
                CustomTextView(
                  text: "No Recorded Sessions Found",
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade600,
                ),
              ],
            ),
          );
        }

        final result = controller.otherScheduleEvent.first;
        final events = result.events;

        // Empty events list
        if (events.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.video_library_outlined,
                  size: 80.sp,
                  color: Colors.grey.shade400,
                ),
                SizedBox(height: 16.h),
                CustomTextView(
                  text: "No Recorded Videos Available",
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade600,
                ),
              ],
            ),
          );
        }

        // Grid View with Videos
        return GridView.builder(
          padding: EdgeInsets.all(8.w),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8.w,
            mainAxisSpacing: 8.h,
            childAspectRatio: 0.7,
          ),
          itemCount: events.length,
          itemBuilder: (context, index) {
            final event = events[index];
            // Use default video if recordedLink is null or empty
            final videoUrl = (event.recordedLink.isEmpty ||
                event.recordedLink == null)
                ? 'https://cdn.pixabay.com/video/2016/08/16/4841-180474205_large.mp4'
                : event.recordedLink;

            return VideoThumbnailCard(
              videoUrl: videoUrl,
              title: event.title,
              duration: event.scheduleDate,
              onTap: () {
                // Navigate to full screen video player
                Get.to(() => FullScreenVideoPlayer(
                  videoUrl: videoUrl,
                  title: event.title,
                  description: event.text,
                ));
              },
            );
          },
        );
      }),
    );
  }
}

class VideoThumbnailCard extends StatelessWidget {
  final String videoUrl;
  final String title;
  final DateTime duration;
  final VoidCallback onTap;

  const VideoThumbnailCard({
    super.key,
    required this.videoUrl,
    required this.title,
    required this.duration,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.r),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Video Thumbnail (using first frame)
              VideoThumbnail(videoUrl: videoUrl),

              // Gradient Overlay
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(6.w),
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
                  child: CustomTextView(
                    text: title,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    maxLines: 2,
                  ),
                ),
              ),

              // Play Button
              Center(
                child: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 30.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class VideoThumbnail extends StatefulWidget {
  final String videoUrl;

  const VideoThumbnail({super.key, required this.videoUrl});

  @override
  State<VideoThumbnail> createState() => _VideoThumbnailState();
}

class _VideoThumbnailState extends State<VideoThumbnail> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
      await _controller!.initialize();
      await _controller!.seekTo(const Duration(seconds: 1)); // Get frame at 1 second
      if (mounted) setState(() {});
    } catch (e) {
      debugPrint('Error loading video thumbnail: $e');
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller != null && _controller!.value.isInitialized) {
      return VideoPlayer(_controller!);
    }

    return Container(
      color: Colors.grey.shade800,
      child: Center(
        child: Icon(
          Icons.video_library,
          size: 40.sp,
          color: Colors.grey.shade600,
        ),
      ),
    );
  }
}

class FullScreenVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final String title;
  final String description;

  const FullScreenVideoPlayer({
    super.key,
    required this.videoUrl,
    required this.title,
    required this.description,
  });

  @override
  State<FullScreenVideoPlayer> createState() => _FullScreenVideoPlayerState();
}

class _FullScreenVideoPlayerState extends State<FullScreenVideoPlayer> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;
  bool _isInitialized = false;
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
      await _controller.initialize();
      setState(() {
        _isInitialized = true;
      });
      _controller.addListener(() {
        if (mounted) {
          setState(() {
            _isPlaying = _controller.value.isPlaying;
          });
        }
      });
      // Auto play
      _controller.play();
    } catch (e) {
      debugPrint('Error initializing video: $e');
      Get.snackbar(
        'Error',
        'Failed to load video',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
    });
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    if (duration.inHours > 0) {
      return '$hours:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              color: Colors.black.withValues(alpha: 0.8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Get.back(),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextView(
                          text: widget.title,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          maxLines: 1,
                        ),
                        SizedBox(height: 2.h),
                        CustomTextView(
                          text: widget.description,
                          fontSize: 12.sp,
                          color: Colors.grey.shade400,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Video Player
            Expanded(
              child: Center(
                child: _isInitialized
                    ? GestureDetector(
                  onTap: _toggleControls,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      ),

                      // Play/Pause Overlay
                      if (_showControls)
                        GestureDetector(
                          onTap: _togglePlayPause,
                          child: Container(
                            color: Colors.black.withValues(alpha: 0.3),
                            child: Center(
                              child: Container(
                                padding: EdgeInsets.all(20.w),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.6),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  _isPlaying ? Icons.pause : Icons.play_arrow,
                                  color: Colors.white,
                                  size: 50.sp,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                )
                    : Center(
                  child: CustomLoading(color: AppColors.primaryColor),
                ),
              ),
            ),

            // Video Controls
            if (_isInitialized)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                color: Colors.black.withValues(alpha: 0.8),
                child: Column(
                  children: [
                    // Progress Bar
                    VideoProgressIndicator(
                      _controller,
                      allowScrubbing: true,
                      colors: VideoProgressColors(
                        playedColor: AppColors.primaryColor,
                        bufferedColor: Colors.grey.shade700,
                        backgroundColor: Colors.grey.shade800,
                      ),
                    ),
                    SizedBox(height: 8.h),

                    // Time and Controls
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomTextView(
                          text: _formatDuration(_controller.value.position),
                          fontSize: 12.sp,
                          color: Colors.white,
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                _isPlaying ? Icons.pause : Icons.play_arrow,
                                color: Colors.white,
                              ),
                              onPressed: _togglePlayPause,
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.replay_10,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                final newPosition = _controller.value.position -
                                    const Duration(seconds: 10);
                                _controller.seekTo(newPosition);
                              },
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.forward_10,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                final newPosition = _controller.value.position +
                                    const Duration(seconds: 10);
                                _controller.seekTo(newPosition);
                              },
                            ),
                          ],
                        ),
                        CustomTextView(
                          text: _formatDuration(_controller.value.duration),
                          fontSize: 12.sp,
                          color: Colors.white,
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
}