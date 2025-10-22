import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LiveScreenController extends GetxController {
  var isCameraOn = true.obs;
  var isMicOn = true.obs;
  var isScreenSharing = false.obs;
  var showMenu = false.obs;
  var viewerCount = 234.obs;

  void toggleCamera() {
    isCameraOn.value = !isCameraOn.value;
  }

  void toggleMic() {
    isMicOn.value = !isMicOn.value;
  }

  void toggleScreenShare() {
    isScreenSharing.value = !isScreenSharing.value;
    showMenu.value = false;
  }

  void toggleMenu() {
    showMenu.value = !showMenu.value;
  }

  void closeMenu() {
    showMenu.value = false;
  }

  void addContributor() {
    showMenu.value = false;
    Get.snackbar(
      'Add Contributor',
      'Opening contributor selection...',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black87,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  void openComments() {
    showMenu.value = false;
    Get.snackbar(
      'Comments',
      'Opening comments section...',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black87,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  void openPolls() {
    showMenu.value = false;
    Get.snackbar(
      'Polls',
      'Opening polls...',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black87,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  void endCall() {
    Get.defaultDialog(
      title: 'End Live Session',
      middleText: 'Are you sure you want to end this live session?',
      textConfirm: 'End',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () {
        Get.back();
        Get.back();
      },
    );
  }
}