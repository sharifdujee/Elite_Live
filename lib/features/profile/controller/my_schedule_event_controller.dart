
import 'dart:developer';

import 'package:elites_live/core/helper/shared_prefarenses_helper.dart';
import 'package:elites_live/core/services/network_caller/repository/network_caller.dart';
import 'package:elites_live/core/utils/constants/app_urls.dart';
import 'package:elites_live/features/profile/data/my_schedule_event_data_model.dart';
import 'package:get/get.dart';


class MyScheduleEventController extends GetxController {
  var isLoading = false.obs;
  final NetworkCaller networkCaller = NetworkCaller();
  final SharedPreferencesHelper helper = SharedPreferencesHelper();

  RxList<MyScheduleEventResult> myEventScheduleList = <MyScheduleEventResult>[].obs;

  @override
  void onInit() {
    super.onInit();
    getMyScheduleEvent();
  }

  /// get my schedule event
  Future<void> getMyScheduleEvent() async {
    isLoading.value = true;
    String? token = helper.getString("userToken");
    log("token during fetch my event is $token");

    try {
      var response = await networkCaller.getRequest(AppUrls.getMyEvent, token: token);

      if (response.isSuccess) {
        log("=== RAW API RESPONSE ===");
        log("${response.responseData}");
        log("Response type: ${response.responseData.runtimeType}");


        Map<String, dynamic> data = response.responseData;

        MyScheduleEventResult scheduleResult;


        if (data.containsKey('result')) {
          log("Response has 'result' wrapper");
          final schedule = MyScheduleEventDataModel.fromJson(data);
          scheduleResult = schedule.result;
        } else if (data.containsKey('events')) {

          log("Response is direct result object");
          scheduleResult = MyScheduleEventResult.fromJson(data);
        } else {
          log("ERROR: Unknown response structure");
          log("Keys in response: ${data.keys.toList()}");
          return;
        }




        for (var i = 0; i < scheduleResult.events.length && i < 3; i++) {
          final event = scheduleResult.events[i];
          log("Event $i:");
          log("  - ID: ${event.id}");
          log("  - Type: ${event.eventType}");
          log("  - Text: ${event.text}");
          log("  - User: ${event.user.firstName} ${event.user.lastName}");
        }

        // Assign the result
        myEventScheduleList.assignAll([scheduleResult]);

        log("=== ASSIGNMENT COMPLETE ===");
        log("myEventScheduleList length: ${myEventScheduleList.length}");
        if (myEventScheduleList.isNotEmpty) {
          log("First item events count: ${myEventScheduleList.first.events.length}");
        }
      } else {
        log("API request failed: ${response.errorMessage}");
      }
    } catch (e, stackTrace) {
      log("=== EXCEPTION ===");
      log("Exception: ${e.toString()}");
      log("Stack trace: $stackTrace");
    } finally {
      isLoading.value = false;
      log("Loading complete. Final list length: ${myEventScheduleList.length}");
    }
  }

  /// get others user information

}