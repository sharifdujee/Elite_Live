import 'dart:developer';
import 'package:get/get.dart';

import '../../../core/helper/shared_prefarenses_helper.dart';
import '../../../core/services/network_caller/repository/network_caller.dart';
import '../../../core/utils/constants/app_urls.dart';
import '../data/my_crowd_funding_data_model.dart';


class MyCrowdFundController extends GetxController{
  var isLoading = false.obs;
  final NetworkCaller networkCaller = NetworkCaller();
  final SharedPreferencesHelper helper = SharedPreferencesHelper();

  RxList<MyCrowdResult> myEventScheduleList = <MyCrowdResult>[].obs;

  @override
  void onInit() {
    super.onInit();
    getMyCrowdFunding();
  }

  /// get my schedule event
  Future<void> getMyCrowdFunding() async {
    isLoading.value = true;
    String? token = helper.getString("userToken");

    try {
      var response = await networkCaller.getRequest(AppUrls.getMyCrowdFund, token: token);

      if (response.isSuccess) {
        log("=== RAW RESPONSE ===");
        log("${response.responseData}");

        Map<String, dynamic> data = response.responseData;

        // Parse API directly into your model
        final scheduleResult = MyCrowdResult.fromJson(data);

        // Assign to your list
        myEventScheduleList.assignAll([scheduleResult]);

        log("Parsed events count: ${scheduleResult.events.length}");
      } else {
        log("API Failed: ${response.errorMessage}");
      }
    } catch (e) {
      log("Exception: $e");
    } finally {
      isLoading.value = false;
    }
  }

}