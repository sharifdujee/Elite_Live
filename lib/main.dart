
import 'package:elites_live/core/services/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'app.dart';
import 'core/binding/app_binding.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthService().init();
  // Get.put(NotificationService());
  AppBinding().dependencies();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);

  runApp(MyApp());
}

