
import 'package:elites_live/features/event/controller/event_controller.dart';
import 'package:elites_live/features/group/controller/group_controller.dart';
import 'package:elites_live/features/home/controller/home_controller.dart';
import 'package:elites_live/features/home/controller/live_controller.dart';
import 'package:elites_live/features/home/controller/video_player_controller.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../../features/authentication/forgot_pass/controller/create_new_pass_controller.dart';
import '../../features/authentication/forgot_pass/controller/forgot_otp_controller.dart';
import '../../features/authentication/forgot_pass/controller/forgot_pass_controller.dart';
import '../../features/authentication/sign_in/controller/sign_in_controller.dart';
import '../../features/authentication/sign_up/controller/sign_up_controller.dart';
import '../../features/authentication/sign_up/controller/sign_up_otp_controller.dart';
import '../../features/main_view/controller/main_view_controller.dart';
import '../../features/onboarding/controller/slider_controller.dart';
import '../../features/profile/controller/set_up_profile_controller.dart';
import '../../features/splash/controller/splash_controller.dart';
import '../global/controller/custom_date_time_dialog.dart';


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
    Get.lazyPut(()=>HomeController(), fenix: true);
    Get.lazyPut(()=>VideoController(), fenix: true);
    Get.lazyPut(()=>LiveController(), fenix: true);
    Get.lazyPut(()=>GroupController(), fenix: true);
    Get.lazyPut(()=>EventController(), fenix: true);
  }
}