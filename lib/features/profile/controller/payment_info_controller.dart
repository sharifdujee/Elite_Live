import 'package:get/get.dart';
import '../../../routes/app_routing.dart';

class PaymentInfopageController extends GetxController {
  RxString selectedPaymentMethod = 'card'.obs;

  // Track ad credit checkbox
  RxBool hasAdCredit = false.obs;

  void selectPaymentMethod(String method) {
    selectedPaymentMethod.value = method;
  }

  void toggleAdCredit(bool value) {
    hasAdCredit.value = value;
  }

  void onNext() {
    Get.toNamed(AppRoute.carddetails);
  }
}
