import 'package:get/get.dart';

class SettingsController extends GetxController {
  RxBool isDiscoveryVisible = false.obs;

  void toggleDiscoveryVisibility() {
    isDiscoveryVisible.value = !isDiscoveryVisible.value;
  }
}
