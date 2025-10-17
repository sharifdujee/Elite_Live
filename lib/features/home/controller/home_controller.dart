import 'package:elites_live/core/utils/constants/image_path.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  var searchText = ''.obs;
  var selectedTab = 0.obs; // 0 = All, 1 = Live, 2 = Video, 3 = User
  List<String> liveDescription = [
    "Tell me what excites you and makes you smile. Only good conversations—no bad texters!...",
    "Tell me what excites you and makes you smile. Only good conversations—no bad texters!...",
    "Tell me what excites you and makes you smile. Only good conversations—no bad texters!...",
    "Tell me what excites you and makes you smile. Only good conversations—no bad texters!...",
    "Tell me what excites you and makes you smile. Only good conversations—no bad texters!...",
  ];
  List<String> influencerName = [
    "Ethan Walker",
    "Ronald Richards",
    "Marvin",
    "Jerome Bell",
    "Marvin",
  ];
  List<String> influencerProfile = [ImagePath.two,ImagePath.one, ImagePath.user, ImagePath.three, ImagePath.one];
  List<bool> isLive = [true, false, true, true, true];
  // Tab control
  void onTabSelected(int index) => selectedTab.value = index;
  void onSearchChanged(String value) => searchText.value = value;
}
