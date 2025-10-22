import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProfileController extends GetxController {
  final RxString selectedGender = 'Female'.obs;
  final Rx<DateTime?> selectedDate = Rx<DateTime?>(DateTime(2004, 2, 12));
  final TextEditingController professionController = TextEditingController();

  void selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value ?? DateTime(2004, 2, 12),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      selectedDate.value = picked;
    }
  }

  void updateProfile() {
    // TODO: handle profile update API or logic
    Get.snackbar('Success', 'Profile Updated');
  }

  @override
  void onInit() {
    super.onInit();
    // professionController.text = 'Professional Model';
  }

  @override
  void onClose() {
    professionController.dispose();
    super.onClose();
  }
}
