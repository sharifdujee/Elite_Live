import 'package:get/get.dart';

class PaymentController extends GetxController {
  var selectedIndex = 0.obs;

  void selectPayment(int index) {
    selectedIndex.value = index;
  }
}
