import 'package:get/get.dart';

class EarningsController extends GetxController {
  // 0 = Ads Revenue, 1 = Funding
  var selectedTab = 0.obs;

  // Example summary data (these can be fetched later)
  final double totalEarnings = 16.18;
  final int transactions = 12;
  final int progress = 8;
  final int waiting = 4;

  // Ads Revenue data list
  final List<Map<String, dynamic>> adsRevenueList = [
    {
      "image": "assets/images/live1.png",
      "title": "Art In Motion - Hold",
      "subtitle": "Tell me what excites..",
      "amount": "\$1.00",
    },
    {
      "image": "assets/images/live2.png",
      "title": "Day 3",
      "subtitle": "Tell me what excites..",
      "amount": "\$0.00",
    },
    {
      "image": "assets/images/live3.png",
      "title": "Joe Barone",
      "subtitle": "Tell me what excites..",
      "amount": "\$5.00",
    },
  ];

  // Funding data list
  final List<Map<String, dynamic>> fundingList = [
    {
      "image": "assets/images/live1.png",
      "title": "Masters Camp",
      "subtitle": "Tell me what excites..",
      "amount": "\$500",
    },
    {
      "image": "assets/images/live2.png",
      "title": "RIT - Hold",
      "subtitle": "Tell me what excites..",
      "amount": "\$100",
    },
    {
      "image": "assets/images/live3.png",
      "title": "Toyota",
      "subtitle": "Tell me what excites..",
      "amount": "\$1000",
    },
  ];

  void changeTab(int index) {
    selectedTab.value = index;
  }
}
