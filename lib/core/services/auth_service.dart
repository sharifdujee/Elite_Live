import 'package:shared_preferences/shared_preferences.dart';


/*
class AuthService {
  static const String _tokenKey = 'token';
  static const String _userRoleKey = "userRole";
  static const String _isSetUp = "isSetUp";
  static const String _userId = "userId";

  // Singleton instance for SharedPreferences
  static late SharedPreferences _preferences;

  // Private variables to hold token and userId
  static String? _token;
  static String? _userRole;
  static bool? _userSetUp;
  static String? _id;

  // Initialize SharedPreferences (call this during app startup)
  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
    // Load token and userId from SharedPreferences into private variables
    _token = _preferences.getString(_tokenKey);
    _userRole = _preferences.getString(_userRoleKey);
    _userSetUp = _preferences.getBool(_isSetUp);
    _id = _preferences.getString(_userId);
  }

  // Check if a token exists in local storage
  static bool hasToken() {
    return _preferences.containsKey(_tokenKey);
  }

  // Save the token and user ID to local storage
  static Future<void> saveToken(String token) async {
    try {
      await _preferences.setString(_tokenKey, token);
      // Update private variables
      _token = token;
    } catch (e) {
      log('Error saving token: $e');
    }
  }

  /// save id
  static Future<void> saveId(String id) async {
    try {
      await _preferences.setString(_userId, id);
      // Update private variables
      _id = id;
    } catch (e) {
      log('Error saving token: $e');
    }
  }

  //Save user role
  static Future<void> saveRole(String role) async {
    try {
      await _preferences.setString(_userRoleKey, role);
      // Update private variables
      _userRole = role;
    } catch (e) {
      log('Error saving token: $e');
    }
  }
  static Future<void> saveStatus(bool setUp) async {
    try {
      await _preferences.setBool(_isSetUp, setUp);
      // Update private variables
      _userSetUp = setUp;
    } catch (e) {
      log('Error saving token: $e');
    }
  }

  // Clear authentication data (for logout or clearing auth data)
  static Future<void> logoutUser() async {
    try {
      // Clear all data from SharedPreferences
      await deleteTokenRole();
      /// await GoogleSignInService().signOutFromGoogle();
      // Reset private variables
      _token = null;
      // Redirect to the login screen
      await goToLogin();
    } catch (e) {
      log('Error during logout: $e');
    }
  }

  static Future<void> deleteTokenRole() async {
    try {
      await _preferences.remove(_tokenKey);
      await _preferences.remove(_userRoleKey);
      await _preferences.remove(_isSetUp);
      _token = null;
      _userRole = null;
    } catch (e) {
      log('Error deleting token and role: $e');
    }
  }

  // Navigate to the login screen (e.g., after logout or token expiry)
  static Future<void> goToLogin() async {
    ///Get.offAllNamed(Routes.login);
  }

  // Getter for token
  static String? get token => _token;
  static String? get userRole => _userRole;
  static bool? get userSetUp => _userSetUp;
  static String?id = _id;
}*/





class AuthService {
  static final AuthService _instance =
  AuthService._internal();

  factory AuthService() => _instance;

  AuthService._internal();

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<bool> setString(String key, String value) async {
    return await _prefs?.setString(key, value) ?? false;
  }

  String? getString(String key) {
    return _prefs?.getString(key);
  }

  Future<void> setBoolList(String key, List<bool> value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(key, value.map((e) => e.toString()).toList());
  }

  Future<List<bool>> getBoolList(String key) async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? stringList = prefs.getStringList(key);
    if (stringList != null) {
      return stringList.map((e) => e == 'true').toList();
    }
    return [];
  }

  Future<bool> setInt(String key, int value) async {
    return await _prefs?.setInt(key, value) ?? false;
  }

  int? getInt(String key) {
    return _prefs?.getInt(key);
  }

  Future<bool> setBool(String key, bool value) async {
    return await _prefs?.setBool(key, value) ?? false;
  }

  bool? getBool(String key) {
    return _prefs?.getBool(key);
  }

  Future<bool> setDouble(String key, double value) async {
    return await _prefs?.setDouble(key, value) ?? false;
  }

  double? getDouble(String key) {
    return _prefs?.getDouble(key);
  }

  Future<bool> setStringList(String key, List<String> value) async {
    return await _prefs?.setStringList(key, value) ?? false;
  }

  List<String>? getStringList(String key) {
    return _prefs?.getStringList(key);
  }

  Future<bool> remove(String key) async {
    return await _prefs?.remove(key) ?? false;
  }

  Future<bool> clear() async {
    return await _prefs?.clear() ?? false;
  }
}

