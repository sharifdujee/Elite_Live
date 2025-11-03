import 'package:get/get.dart';

import '../../../routes/app_routing.dart';

class BillingPaymentController extends GetxController {

  void addPaymentMethod() {
    Get.toNamed(AppRoute.carddetails);
  }

  void getStarted() {
    Get.toNamed(AppRoute.bankDetails);
  }
}