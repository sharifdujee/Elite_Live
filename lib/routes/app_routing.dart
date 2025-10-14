
import 'package:elite_lives/features/home/presentation/screen/home_screen.dart';
import 'package:get/get_navigation/get_navigation.dart';


class AppRoute {
  static const String splash = "/splash";
  static const String init = "/";



  static final List<GetPage> pages = [
    GetPage(name: init, page: (()=>HomeScreen()))

  ];
}
