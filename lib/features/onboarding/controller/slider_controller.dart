
import 'package:elites_live/core/services/auth_service.dart';
import 'package:get/get.dart';

import '../../../routes/app_routing.dart';



class SliderController extends GetxController {
  AuthService preferencesHelper = AuthService();
  RxInt currentIndex = 0.obs;

  void updatePage(int index) {
    currentIndex.value = index;
  }

  @override
  Future<void> onInit() async {
    await AuthService().init();
    super.onInit();
  }

  void completeOnBoarding() {
    preferencesHelper.setBool("onBoarding", true);
    Get.offAllNamed(AppRoute.signIn);
  }
}
