import 'dart:developer';

import 'package:elites_live/core/helper/shared_prefarenses_helper.dart';
import 'package:elites_live/core/services/network_caller/repository/network_caller.dart';
import 'package:elites_live/core/utils/constants/app_urls.dart';
import 'package:elites_live/features/profile/data/connected_account_balance_data_model.dart';
import 'package:get/get.dart';

class EarningsController extends GetxController {
  // 0 = Ads Revenue, 1 = Funding
  var selectedTab = 0.obs;

  // Example summary data (these can be fetched later)
  final double totalEarnings = 16.18;
  final int transactions = 12;
  final int progress = 8;
  final int waiting = 4;
  final NetworkCaller networkCaller = NetworkCaller();
  final SharedPreferencesHelper helper = SharedPreferencesHelper();
  var isLoading = false.obs;
  RxList<ConnectedAccountBalanceResult> balanceHistory = <ConnectedAccountBalanceResult>[].obs;

  @override
  void onInit() {
    // TODO: implement onInit
    getConnectedAccountBalance();
    super.onInit();
  }


  /// get Connected Account Balance
  Future<void> getConnectedAccountBalance() async {
    isLoading.value = true;
    String? token = helper.getString('userToken');

    log("token during fetch connected Balance: $token");

    try {
      var response = await networkCaller.getRequest(
        AppUrls.getConnectedAccountBalance,
        token: token,
      );

      if (!response.isSuccess) {
        log("❌ API returned error: ${response.errorMessage}");
        return;
      }

      if (response.responseData == null) {
        log("❌ responseData is NULL");
        return;
      }

      // SAFETY CHECK → ensure result exists
      if (response.responseData is! Map<String, dynamic>) {
        log("❌ Invalid response format");
        return;
      }

      final Map<String, dynamic> resultMap = response.responseData;

      if (!resultMap.containsKey("available") ||
          !resultMap.containsKey("withdrawable")) {
        log("❌ Missing balance keys — API changed?");
        return;
      }

      // Parse safely
      final currentBalance =
      ConnectedAccountBalanceResult.fromJson(resultMap);

      // SAFETY CHECK → ensure list is not null
      currentBalance.transactionHistory =
          currentBalance.transactionHistory ?? [];

      // Update observable list
      balanceHistory.assignAll([currentBalance]);

      log("✅ Balance updated successfully");

    } catch (e) {
      log("❌ Exception inside getConnectedAccountBalance(): $e");
    } finally {
      isLoading.value = false;
    }
  }


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


  void changeTab(int index) {
    selectedTab.value = index;
  }
}
