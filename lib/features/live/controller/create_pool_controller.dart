import 'package:get/get.dart';
import 'package:flutter/material.dart';

class CreatePollController extends GetxController {
  final questionController = TextEditingController();
  final newOptionController = TextEditingController();
  final RxList<String> options = <String>[].obs;

  void addOption(String option) {
    if (option.trim().isNotEmpty) {
      options.add(option.trim());
      newOptionController.clear();
    }
  }

  void removeOption(int index) {
    options.removeAt(index);
  }

  void savePoll() {
    if (questionController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter a question',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (options.length < 2) {
      Get.snackbar(
        'Error',
        'Please add at least 2 options',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Handle save logic here
    Get.back();
    Get.snackbar(
      'Success',
      'Poll created successfully',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  @override
  void onClose() {
    questionController.clear();
    newOptionController.clear();
    super.onClose();
  }
}