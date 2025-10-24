import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/helper/shared_prefarenses_helper.dart';
import '../../../core/service_class/google_signin_helper.dart';
import '../../../core/service_class/network_caller/repository/network_caller.dart';
import '../../../core/utility/app_urls.dart';

class ChangePasswordController extends GetxController {


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
