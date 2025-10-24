
import 'package:get/get.dart';

class SubscriptionController extends GetxController {
  var selectedPlan = 'basic'.obs;

  void selectPlan(String plan) {
    selectedPlan.value = plan;
  }
}
