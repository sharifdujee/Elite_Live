import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TaxInfdialogController extends GetxController {
  TextEditingController einController = TextEditingController();

  void onNext() {
    // String ein = einController.text.trim();
    // Perform validation or save logic here
    Get.back(); // Close dialog for now
  }

  @override
  void onClose() {
    einController.dispose();
    super.onClose();
  }
}
