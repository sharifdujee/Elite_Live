import 'package:get/get.dart';

class LogoutController extends GetxController {
  void logout() {
    // Handle logout logic here
    Get.back(); // Close the bottom sheet after logout
  }
}
