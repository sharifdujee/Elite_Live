import 'package:get/get.dart';

import '../../../routes/app_routing.dart';

class PaymentInfoController extends GetxController {
  // Payment method selection
  RxBool isCardSelected = true.obs;
  RxBool hasAdCredit = false.obs;

  void selectCard(bool value) {
    isCardSelected.value = value;
  }

  void toggleAdCredit(bool value) {
    hasAdCredit.value = value;
  }

  void onNext() {
 Get.toNamed(AppRoute.carddetails);
  }
}
