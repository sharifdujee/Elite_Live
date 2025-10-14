import 'package:elite_lives/routes/app_routing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';


import 'core/binding/app_binding.dart';

final navigatorkey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return GetMaterialApp(
          title: 'Learn it',
          debugShowCheckedModeBanner: false,
          // themeMode: ThemeMode.system,
          darkTheme: ThemeData(
            // cardColor: Colors.black,
            // appBarTheme: AppBarTheme(
            //   backgroundColor: Colors.black,
            //   titleTextStyle: TextStyle(color: Colors.white),
            // ),
            // brightness: Brightness.dark,
            // applyElevationOverlayColor: true,
            // bottomNavigationBarTheme: BottomNavigationBarThemeData(
            //   backgroundColor: Colors.black,
            //   unselectedLabelStyle: TextStyle(
            //     // backgroundColor: Colors.black,
            //     color: Colors.black,
            //     decorationColor: Colors.black,
            //   ),
            // ),
            // primaryTextTheme: TextTheme(
            //   bodySmall: TextStyle(color: Colors.white),
            //   bodyLarge: TextStyle(color: Colors.white),
            //   bodyMedium: TextStyle(color: Colors.white),
            //   displayLarge: TextStyle(color: Colors.white),
            //   displayMedium: TextStyle(color: Colors.white),
            //   displaySmall: TextStyle(color: Colors.white),
            //   headlineLarge: TextStyle(color: Colors.white),
            //   headlineMedium: TextStyle(color: Colors.white),
            //   headlineSmall: TextStyle(color: Colors.white),
            //   labelLarge: TextStyle(color: Colors.white),
            //   labelMedium: TextStyle(color: Colors.white),
            //   labelSmall: TextStyle(color: Colors.white),
            //   titleLarge: TextStyle(color: Colors.white),
            //   titleMedium: TextStyle(color: Colors.white),
            //   titleSmall: TextStyle(color: Colors.white),
            // ),
            // bottomAppBarTheme: BottomAppBarTheme(color: Colors.black),
            // useMaterial3: true,
          ),
          theme: ThemeData(
            // cardColor: Colors.white,
            brightness: Brightness.light,
            // scaffoldBackgroundColor: Colors.white,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          getPages: AppRoute.pages,
          navigatorKey: navigatorkey,
          initialBinding: AppBinding(),
          initialRoute: AppRoute.init,
          // locale: const Locale('en', 'US'),
          /*locale: Get.deviceLocale,
          translations: Language(),
          fallbackLocale: const Locale("en", "US"),*/
        );
      },
    );
  }
}
