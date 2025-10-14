
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'app.dart';
import 'core/binding/binding.dart';
import 'core/helper/shared_prefarenses_helper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesHelper().init();
  // Get.put(NotificationService());
  AppBinding().dependencies();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);

  runApp(MyApp());
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  ///await AuthService.init();

  SharedPreferences.getInstance();

  ///await PushNotificationService().initialize();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MyApp());
}


