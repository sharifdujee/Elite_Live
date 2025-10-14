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
