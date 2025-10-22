import 'dart:async';


import 'package:get/get.dart';

import '../../../core/helper/shared_prefarenses_helper.dart';

import '../../../routes/app_routing.dart';

class SplashController extends GetxController {
  final SharedPreferencesHelper preferencesHelper = SharedPreferencesHelper();





  @override
  Future<void> onInit() async {
    super.onInit();


    await preferencesHelper.init();



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



