import 'package:get/get.dart';

class ProfileController extends GetxController {
  RxBool isDiscoveryVisible = false.obs;

  void toggleDiscoveryVisibility() {
    isDiscoveryVisible.value = !isDiscoveryVisible.value;
  }
}
