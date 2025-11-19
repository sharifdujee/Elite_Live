class AppUrls {
  static const String _baseUrl = 'http://206.162.244.144:5020/api/v1';

  //create

  //create
  static const String registerUrl = '$_baseUrl/users/create';
  static const String loginUrl = '$_baseUrl/auth/login';

  /// profile set up
  static const String setUpProfile = "$_baseUrl/auth/profile";
  static const String user = '$_baseUrl/auth/profile';
  /// setting flow
  static const String getMyEvent = "$_baseUrl/event/my-schedule/event";
  static const String getMyCrowdFund = "$_baseUrl/event/my-funding/event";

  static const String socialLogin = '$_baseUrl/auth/auth-login';
  static const String verifyOtp = '$_baseUrl/users/signup-verification';

  static const String sendOtp = '$_baseUrl/auth/send-otp';
  static const String verifyForgotOtp = '$_baseUrl/auth/verify-otp';
  static const String resetPass = '$_baseUrl/auth/reset-password';
  static const String changePassword = "$_baseUrl/auth/change-password";
  static const String deleteAccount = "$_baseUrl/auth/delete-account";

  static const String setProfile = '$_baseUrl/auth/set-profile';
  static const String setProfilePic = '$_baseUrl/auth/update-profile-image';

  static const String notifications =
      '$_baseUrl/notifications/my-notifications';

  /// event section
  static const String createEvent = "$_baseUrl/event";
  static String getAllEvent(int page, int limit) =>
      "$_baseUrl/event/schedule/event?page=$page&limit=$limit";
  static String getAllCrowdFunding(int page, int limit) =>
      "$_baseUrl/event/funding/event?page=$page&limit=$limit";
  /// like unlike
  static String createLike(String eventId) => "$_baseUrl/event/like-unlike/$eventId";
  static String createComment(String eventId) => "$_baseUrl/event/comment/$eventId";
  static String getComment(String eventId) => "$_baseUrl/event/comment/$eventId";
  static String createReply (String commentId) => "$_baseUrl/event/reply-comment/$commentId";

  /// Group flow
  static const String createGroup = "$_baseUrl/group/create";
  static const String discoverGroup = "$_baseUrl/group/discover-groups";
  static String joinGroup(String groupId) => "$_baseUrl/group/join-group/$groupId";
  static const String joinedGroup = "$_baseUrl/group/joined-groups";
  static String groupInfo(String groupId) => "$_baseUrl/group/$groupId";
  static String groupUser(String groupId) => "$_baseUrl/group/all-users/invite/$groupId";

  static String searchUser(String groupId, String search) => "$_baseUrl/group/all-users/invite/$groupId?search=$search";
  static String leaveGroup(String groupId) => "$_baseUrl/group/leave-group/$groupId";
  static String inviteGroup(String groupId, String userId) => "$_baseUrl/group/invite-group/$groupId/$userId";
  static String updateGroup(String groupId) => "$_baseUrl/group/$groupId";
  static String deleteGroup(String groupId) => "$_baseUrl/group/$groupId";
  static String createGroupPost(String groupId) => "$_baseUrl/group/create/post/$groupId";
  static String deleteGroupPost(String postId) => "$_baseUrl/group/post/$postId";
  static String getPostInfo(String postId) => "$_baseUrl/group/postinfo/$postId";
  static String createPostComment(String postId) => "$_baseUrl/group/comment/post/$postId";
  static String likePost (String postId) => "$_baseUrl/group/like/post/$postId";
  static String replyComment(String commentId) => "$_baseUrl/group/reply-comment/post/$commentId";




  static const String googleAuth = '$_baseUrl/auth/google-login';
}
