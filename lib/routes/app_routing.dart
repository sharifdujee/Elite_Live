

import 'package:elites_live/features/group/presentation/screen/create_group.dart';
import 'package:elites_live/features/group/presentation/screen/create_post_screen.dart';
import 'package:elites_live/features/group/presentation/screen/discover_group.dart';
import 'package:elites_live/features/group/presentation/screen/group_post_screen.dart';
import 'package:elites_live/features/group/presentation/screen/group_screen.dart';
import 'package:elites_live/features/group/presentation/screen/invite_people_screen.dart';
import 'package:elites_live/features/notification/presentation/screen/notification.dart';
import 'package:get/get_navigation/get_navigation.dart';

import '../features/authentication/forgot_pass/presentation/screen/create_new_pass_screen.dart';
import '../features/authentication/forgot_pass/presentation/screen/forgot_otp_screen.dart';
import '../features/authentication/forgot_pass/presentation/screen/forgot_pass_screen.dart';
import '../features/authentication/forgot_pass/presentation/screen/pass_changed_screen.dart';
import '../features/authentication/set_up_profile/presentation/screen/set_up_profile.dart';
import '../features/authentication/sign_in/presentation/screen/sign_in_screen.dart';
import '../features/authentication/sign_up/presentation/screen/sign_up_otp_screen.dart';
import '../features/authentication/sign_up/presentation/screen/sign_up_screen.dart';
import '../features/main_view/presentation/screen/main_view_screen.dart';
import '../features/onboarding/presentation/screen/slider_screen.dart';
import '../features/splash/presentation/splash_screen.dart';





class AppRoute {
  static const String splash = '/SplashScreen';
  static const String slider = '/SliderScreen';
  static const String signIn = '/SignInScreen';
  static const String signUp = '/SignUpScreen';
  static const String signOtp = '/SignOtpScreen';
  static const String forgotPassword = '/ForgotPasswordScreen';
  static const String forgotPasswordOtp = '/ForgotPasswordOtpScreen';
  static const String resetPassword = '/ResetPasswordScreen';
  static const String passwordChanged = '/PasswordChangedScreen';
  static const String setupProfile = '/SetupProfileScreen';
  static const String mainView = '/MainViewScreen';
  /// added by sharif 
  static const String group = "/group";
  static const String notification = "/notification";
  static const String invite = "/invite";
  static const String createGroup = "/createGroup";
  static const String discoverGroup = "/discoverGroup";
  static const String groupPost = "/groupPost";
  static const String createPost = "/createPost";

  static final route = [
    GetPage(
      name: splash,
      page: () => SplashScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: slider,
      page: () => SliderScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: signIn,
      page: () => SignInScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: signUp,
      page: () => SignUpScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: signOtp,
      page: () => SignUpOtpScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: forgotPassword,
      page: () => ForgotPassScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: forgotPasswordOtp,
      page: () => ForgotOtpScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: resetPassword,
      page: () => CreateNewPassScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: passwordChanged,
      page: () => PasswordChangedScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: setupProfile,
      page: () => SetUpProfileScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: mainView,
      page: () => MainViewScreen(),
      transition: Transition.rightToLeft,
    ),
    
    /// added by sharif
    GetPage(name: group, page: ()=>GroupScreen(), transition: Transition.rightToLeft), 
    GetPage(name: notification, page: ()=>NotificationScreen(), transition: Transition.rightToLeft),
    GetPage(name: invite, page: ()=>InvitePeopleScreen(), transition: Transition.rightToLeft),
    GetPage(name: createGroup, page: ()=>CreateGroupScreen(), transition: Transition.rightToLeft),
    GetPage(name: discoverGroup, page: ()=>DiscoverGroup(), transition: Transition.rightToLeft),
    GetPage(name: groupPost, page: ()=>GroupPostScreen(), transition: Transition.rightToLeft),
    GetPage(name: createPost, page: ()=>CreatePostScreen(), transition: Transition.rightToLeft),
  ];
}
