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

