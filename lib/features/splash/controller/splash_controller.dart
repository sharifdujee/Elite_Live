import 'dart:async';

import 'package:elites_live/core/services/auth_service.dart';
import 'package:get/get.dart';


import '../../../routes/app_routing.dart';

class SplashController extends GetxController {
  final AuthService preferencesHelper = AuthService();

  @override
  Future<void> onInit() async {
    super.onInit();

    await AuthService().init();

    // final String? token = preferencesHelper.getString("userToken");
    // final isOnBoarding = preferencesHelper.getBool("onBoarding") ?? false;
    // final isSetup = preferencesHelper.getBool("isSetup") ?? false;
    await Future.delayed(const Duration(seconds: 1));

    Get.offAllNamed(AppRoute.slider);


    // if (token != null && token.isNotEmpty) {
    //   if (isSetup) {
    //     Get.offAllNamed(AppRoute.mainView);
    //   } else {
    //     Get.offAllNamed(AppRoute.settingGoalScreen);
    //   }
    // } else {
    //   if (isOnBoarding) {
    //     Get.offAllNamed(AppRoute.signIn);
    //   } else {
    //     Get.offAllNamed(AppRoute.slider);
    //   }
    // }
  }
}