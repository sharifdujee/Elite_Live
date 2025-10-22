
import 'package:get/get.dart';

import '../../../../core/helper/shared_prefarenses_helper.dart';
import '../../../../core/route/app_route.dart';
import '../../../routes/app_routing.dart';

class SliderController extends GetxController {
  SharedPreferencesHelper preferencesHelper = SharedPreferencesHelper();
  RxInt currentIndex = 0.obs;

  void updatePage(int index) {
    currentIndex.value = index;
  }

  @override
  Future<void> onInit() async {
    await preferencesHelper.init();
    super.onInit();
  }

  void completeOnBoarding() {
    preferencesHelper.setBool("onBoarding", true);
    Get.offAllNamed(AppRoute.signIn);
  }
}
