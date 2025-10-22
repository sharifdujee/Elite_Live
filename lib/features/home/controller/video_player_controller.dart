import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class VideoController extends GetxController {
  late VideoPlayerController videoPlayerController;
  var isPlaying = false.obs;
  var isMuted = false.obs;
  var position = Duration.zero.obs;
  var duration = Duration.zero.obs;

  @override
  void onInit() {
    super.onInit();
    videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse('https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4'),
    )
      ..initialize().then((_) {
        duration.value = videoPlayerController.value.duration;
        update();
      });

    videoPlayerController.addListener(() {
      position.value = videoPlayerController.value.position;
      duration.value = videoPlayerController.value.duration;
      isPlaying.value = videoPlayerController.value.isPlaying;
    });
  }

  void togglePlayPause() {
    if (isPlaying.value) {
      videoPlayerController.pause();
    } else {
      videoPlayerController.play();
    }
  }

  void toggleMute() {
    isMuted.value = !isMuted.value;
    videoPlayerController.setVolume(isMuted.value ? 0 : 1);
  }

  @override
  void onClose() {
    videoPlayerController.dispose();
    super.onClose();
  }
}
