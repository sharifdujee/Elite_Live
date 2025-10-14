class AppUrls {
  static const String _baseUrl = '';

  //create
  static const String registerUrl = '$_baseUrl/users/create';
  static const String loginUrl = '$_baseUrl/auth/login';
  static const String socialLogin = '$_baseUrl/auth/auth-login';
  static const String verifyOtp = '$_baseUrl/users/signup-verification';

  static const String sendOtp = '$_baseUrl/auth/send-otp';
  static const String verifyForgotOtp = '$_baseUrl/auth/verify-otp';
  static const String resetPass = '$_baseUrl/auth/reset-password';

  static const String setProfile = '$_baseUrl/auth/set-profile';
  static const String setProfilePic = '$_baseUrl/auth/update-profile-image';
  static const String user = '$_baseUrl/auth/profile';

  static const String notifications = '$_baseUrl/notifications/my-notifications';


}