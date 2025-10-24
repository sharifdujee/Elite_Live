import 'package:get/get.dart';

import '../../../routes/app_routing.dart';

class BillingPaymentController extends GetxController {

  void addPaymentMethod() {
Get.toNamed(AppRoute.bankDetails);
  }

  void getStarted() {
    Get.toNamed(AppRoute.carddetails);
  }
}