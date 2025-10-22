import 'package:elites_live/features/sign_in/controller/sign_in_controller.dart';
import 'package:elites_live/features/sign_up/controller/sign_up_controller.dart';
import 'package:elites_live/features/sign_up/controller/sign_up_otp_controller.dart';
import 'package:get/get.dart';
import '../../features/forgot_pass/controller/create_new_pass_controller.dart';
import '../../features/forgot_pass/controller/forgot_otp_controller.dart';
import '../../features/forgot_pass/controller/forgot_pass_controller.dart';
import '../../features/main_view/controller/main_view_controller.dart';
import '../../features/on_boarding/controller/slider_controller.dart';
import '../../features/search/controller/search_controller.dart';
import '../../features/set_up_profile/controller/set_up_profile_controller.dart';
import '../../features/splash/controller/splash_controller.dart';
import '../global_widget/controller/custom_date_time_dialogue.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SplashController(), fenix: true);
   // Get.lazyPut(() => SearchScreenController(), fenix: true);
    Get.lazyPut(() => SliderController(), fenix: true);
    Get.lazyPut(() => SignInController(), fenix: true);
    Get.lazyPut(() => SignUpController(), fenix: true);
    Get.lazyPut(() => SignUpOtpController(), fenix: true);
    Get.lazyPut(() => ForgotPassController(), fenix: true);
    Get.lazyPut(() => ForgotOtpController(), fenix: true);
    Get.lazyPut(() => CreateNewPassController(), fenix: true);
    Get.lazyPut(() => SetUpProfileController(), fenix: true);
    Get.lazyPut(() => CustomDateTimeController(), fenix: true);
    Get.lazyPut(() => MainViewController(), fenix: true);
  }
}
