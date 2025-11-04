import 'package:flutter/material.dart';
import 'package:get/get.dart';


class CardDetailsController extends GetxController {


  final passwordController = TextEditingController();

  @override
  Future<void> onInit() async {
    super.onInit();
  }




  @override
  void dispose() {
    passwordController.clear();
    super.dispose();
  }
}
