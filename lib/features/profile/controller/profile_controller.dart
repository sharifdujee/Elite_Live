import 'package:get/get.dart';

class ProfileController extends GetxController {
  RxBool isDiscoveryVisible = false.obs;

  final List<String> imageList = [
    'assets/images/event1.png',
    'assets/images/live2.png',
    'assets/images/live3.png',
    'assets/images/live4.png',
    'assets/images/live5.png',
    'assets/images/live6.png',
  ];

  void toggleDiscoveryVisibility() {
    isDiscoveryVisible.value = !isDiscoveryVisible.value;
  }
}
