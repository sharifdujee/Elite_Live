import 'dart:developer';
import 'package:get/get.dart';

import '../../../core/helper/shared_prefarenses_helper.dart';
import '../../../core/services/network_caller/repository/network_caller.dart';
import '../../../core/utils/constants/app_urls.dart';
import '../data/my_crowd_funding_data_model.dart';




class MyCrowdFundController extends GetxController {
  var isLoading = false.obs;

  // THIS IS THE KEY: We store only the List<Event> directly!
  // No more wrapping in MyCrowdResult → eliminates all confusion
  var events = <Event>[].obs;

  @override
  void onInit() {
    super.onInit();
    log("Controller initialized → calling API");
    getMyCrowdFunding();
  }

  Future<void> getMyCrowdFunding() async {
    log("getMyCrowdFunding() STARTED");

    isLoading.value = true;
    events.clear(); // Start fresh

    String? token = SharedPreferencesHelper().getString("userToken");

    try {
      final response = await NetworkCaller().getRequest(
        AppUrls.getMyCrowdFund,
        token: token,
      );

      log("API CALL SUCCESS: ${response.isSuccess}");

      if (!response.isSuccess || response.responseData == null) {
        log("API FAILED or null data");
        return;
      }

      // FULL RAW RESPONSE LOG
      log("RAW JSON RESPONSE:");
      log("${response.responseData}");

      final model = MyCrowdFundingDataModel.fromJson(
          response.responseData as Map<String, dynamic>);

      log("Parsed success: ${model.success}");
      log("Message: ${model.message}");
      log("Total events in result: ${model.result.events.length}");

      // DIRECTLY assign events — this triggers Obx perfectly
      events.assignAll(model.result.events);

      log("events list updated → length: ${events.length}");
      if (events.isNotEmpty) {
        log("First event text: ${events.first.text}");
        log("First event user: ${events.first.user.firstName} ${events.first.user.lastName}");
      }
    } catch (e, s) {
      log("EXCEPTION in getMyCrowdFunding", error: e, stackTrace: s);
      events.clear();
    } finally {
      isLoading.value = false;
      log("getMyCrowdFunding() FINISHED | isLoading = false | events.length = ${events.length}");
    }
  }
}