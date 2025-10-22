import 'package:get/get.dart';

import '../data/user_tab_data_model.dart';

import '../data/video _tab_model.dart';


import '../data/video_tab_model.dart';


class SearchScreenController extends GetxController {
  var searchText = ''.obs;
  var selectedTab = 0.obs; // 0 = All, 1 = Live, 2 = Video, 3 = User


  // Tab control
  void onTabSelected(int index) => selectedTab.value = index;
  void onSearchChanged(String value) => searchText.value = value;

  // Recent actions
  void removeRecentItem(String name) => recentList.remove(name);
  void clearHistory() => recentList.clear();



  // Recent and Suggested
  var recentList = <String>[
    "Theresa Webb",
    "Cameron Williamson",
    "Floyd Miles",
    "Savannah Nguyen",
    "Savannah Nguyen",
    "Savannah Nguyen",
  ].obs;

  var suggestedList = <String>[
    "Theresa Webb",
    "Cameron Williamson",
    "Savannah Nguyen",
    "Floyd Miles"
  ].obs;



  // Live Tab Data
  var liveList = <Map<String, dynamic>>[
    {
      'image': 'assets/images/live1.png',
      'viewers': '5.6k',
    },
    {
      'image': 'assets/images/live2.png',
      'viewers': '5.8k',
    },
    {
      'image': 'assets/images/live3.png',
      'viewers': '5.1k',
    },
    {
      'image': 'assets/images/live4.png',
      'viewers': '5.9k',
    },
    {
      'image': 'assets/images/live5.png',
      'viewers': '6.2k',
    },
    {
      'image': 'assets/images/live6.png',
      'viewers': '6.5k',
    },
    {
      'image': 'assets/images/live6.png',
      'viewers': '6.5k',
    },
    {
      'image': 'assets/images/live6.png',
      'viewers': '6.5k',
    },
    {
      'image': 'assets/images/live6.png',
      'viewers': '6.5k',
    },
    {
      'image': 'assets/images/live6.png',
      'viewers': '6.5k',
    },
  ].obs;


  // Video tab data using model
  var videoList = <VideoModel>[
    VideoModel(
      name: 'Ariana Grande',
      username: '@arianagrande',
      views: '728.5k',
      time: '05:00',
      image: 'assets/images/live1.png',
    ),
    VideoModel(
      name: 'Taylor Swift',
      username: '@taylorswift',
      views: '1.2M',
      time: '08:20',
      image: 'assets/images/live2.png',
    ),
    VideoModel(
      name: 'Selena Gomez',
      username: '@selenagomez',
      views: '985.3k',
      time: '03:50',
      image: 'assets/images/live3.png',
    ),
    VideoModel(
      name: 'Justin Bieber',
      username: '@justinbieber',
      views: '875.1k',
      time: '06:40',
      image: 'assets/images/live4.png',
    ),
    VideoModel(
      name: 'Justin Bieber',
      username: '@justinbieber',
      views: '875.1k',
      time: '06:40',
      image: 'assets/images/live5.png',
    ),
    VideoModel(
      name: 'Justin Bieber',
      username: '@justinbieber',
      views: '875.1k',
      time: '06:40',
      image: 'assets/images/live6.png',
    ),
  ].obs;


  //user_tab_data
  var userList = <UserTabDataModel>[
    UserTabDataModel(
      name: 'Marvin McKinney',
      username: 'Arianagrande',
      followers: '200k Followers',
      image: 'assets/images/live6.png',
    ),
    UserTabDataModel(
      name: 'Darrell Steward',
      username: 'Arianagrande',
      followers: '200k Followers',
      image: 'assets/images/live5.png',
    ),
    UserTabDataModel(
      name: 'Darlene Robertson',
      username: 'Arianagrande',
      followers: '200k Followers',
      image: 'assets/images/live2.png',
    ),
    UserTabDataModel(
      name: 'Guy Hawkins',
      username: 'Arianagrande',
      followers: '200k Followers',
      image: 'assets/images/live4.png',
    ),
    UserTabDataModel(
      name: 'Savannah Nguyen',
      username: 'Arianagrande',
      followers: '200k Followers',
      image: 'assets/images/live1.png',
    ),
    UserTabDataModel(
      name: 'Devon Lane',
      username: 'Arianagrande',
      followers: '200k Followers',
      image: 'assets/images/live3.png',
    ),
    UserTabDataModel(
      name: 'Jacob Jones',
      username: 'Arianagrande',
      followers: '200k Followers',
      image: 'assets/images/live2.png',
    ),
    UserTabDataModel(
      name: 'Dianne Russell',
      username: 'Arianagrande',
      followers: '200k Followers',
      image: 'assets/images/live1.png',
    ),
  ].obs;

}



