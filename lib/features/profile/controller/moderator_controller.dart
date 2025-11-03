import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ModeratorController extends GetxController {
  // Selected values
  var selectedModerator = ''.obs;
  var selectedSlowMode = ''.obs;

  // Lists
  final moderators = ['Shamim Decosta', 'Ayman Rahman', 'Tanvir Hasan'];
  final slowModes = ['5 Minutes', '10 Minutes', '15 Minutes', '30 Minutes'];

  // Keywords
  var keywords = <String>[].obs;
  TextEditingController keywordController = TextEditingController();

  // Toggles
  var userBanned = false.obs;
  var subOnly = false.obs;

  void addKeyword(String value) {
    if (value.trim().isNotEmpty && !keywords.contains(value.trim())) {
      keywords.add(value.trim());
      keywordController.clear();
    }
  }

  void removeKeyword(String value) {
    keywords.remove(value);
  }

  void saveSettings() {
    Get.snackbar(
      'Saved',
      'Moderator settings have been updated successfully!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.shade600,
      colorText: Colors.white,
    );
  }
}
