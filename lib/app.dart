import 'package:elites_live/routes/app_routing.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/binding/app_binding.dart';
import 'core/theme/dark_theme_data.dart';
import 'core/theme/light_theme_data.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          initialBinding: AppBinding(),
          debugShowCheckedModeBanner: false,
          title: 'Elite Live',
          theme: lightThemeData(),
          darkTheme: darkThemeData(),
          themeMode: ThemeMode.light,
          initialRoute: AppRoute.splash,
          getPages: AppRoute.route,
          locale: const Locale("en", "US"),
          fallbackLocale: const Locale("en", "US"),
        );
      },
    );
  }
}