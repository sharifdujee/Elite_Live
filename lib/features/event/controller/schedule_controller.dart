import 'package:elites_live/core/helper/shared_prefarenses_helper.dart';
import 'package:elites_live/core/services/network_caller/repository/network_caller.dart';
import 'package:elites_live/features/event/data/crowd_funding_data_model.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'dart:developer';
import '../../../core/global_widget/custom_date_time_dialogue.dart';
import '../../../core/global_widget/custom_loading.dart';
import '../../../core/utils/constants/app_colors.dart';
import '../../../core/utils/constants/app_urls.dart';

import 'package:intl/intl.dart';

import '../data/event_comment_data_model.dart';

class ScheduleController extends GetxController {
  var selectedDate = ''.obs;
  var selectedTime = ''.obs;
  var isLoading = false.obs;
  RxInt page = 1.obs;
  RxInt limit = 10.obs;
  final TextEditingController commentController = TextEditingController();
  TextEditingController replyController = TextEditingController();
  RxList<CrowdFundingEvent> crowdFundList = <CrowdFundingEvent>[].obs;
  RxList<EventCommentResult> commentResult = <EventCommentResult>[].obs;
  RxList<EventComment> commentList = <EventComment>[].obs;

  RxInt currentPage = 1.obs;

  RxInt totalPages = 1.obs;
  RxBool hasMoreData = true.obs;
  RxBool isPaginationLoading = false.obs;

  // Scroll controller for pagination
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    getAllCrowdFunding(currentPage.value, limit.value);
    scrollController.addListener(_scrollListener);
    super.onInit();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  // Scroll listener for pagination
  void _scrollListener() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent * 0.9) {
      if (!isPaginationLoading.value && hasMoreData.value) {
        loadMoreEvents();
      }
    }
  }

  final SharedPreferencesHelper sharedPreferencesHelper =
      SharedPreferencesHelper();
  final NetworkCaller networkCaller = NetworkCaller();

  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  Future<void> createLiveEvent({String eventType = "Schedule"}) async {
    isLoading.value = true;
    Get.dialog(
      CustomLoading(color: AppColors.primaryColor),
      barrierDismissible: false,
    );

    String? token = sharedPreferencesHelper.getString('userToken');

    try {
      final text = descriptionController.text.trim();

      final double? payAmount = double.tryParse(amountController.text.trim());

      DateTime parsedDate = DateTime.now();
      if (selectedDate.isNotEmpty && selectedTime.isNotEmpty) {
        try {
          final dateParts = selectedDate.value.split('-');
          final timeOfDay = TimeOfDay(
            hour: int.parse(selectedTime.value.split(':')[0]),
            minute: int.parse(selectedTime.value.split(':')[1].split(' ')[0]),
          );
          parsedDate = DateTime(
            int.parse(dateParts[2]),
            int.parse(dateParts[1]),
            int.parse(dateParts[0]),
            timeOfDay.hour,
            timeOfDay.minute,
          );
        } catch (e) {
          log("Date parsing failed: ${e.toString()}");
        }
      }

      ///Convert date to ISO format with timezone (+00:00)
      final formattedDate = DateFormat(
        "yyyy-MM-dd'T'HH:mm:ss.SSS'+00:00'",
      ).format(parsedDate.toUtc());

      final Map<String, dynamic> bodyData = {
        "eventType": eventType,
        "text": text,
        if (eventType == "Schedule") "scheduleDate": formattedDate,
        if (eventType == "Schedule" && payAmount != null)
          "payAmount": payAmount,
      };

      log("Sending request with body: $bodyData");

      final response = await networkCaller.postRequest(
        AppUrls.createEvent,
        body: bodyData,
        token: token,
      );

      log(" Response status: ${response.statusCode}");
      log("Response success: ${response.isSuccess}");

      if (response.statusCode == 201 && response.isSuccess) {
        log(" Event created successfully.");
        Get.back();
      } else {
        log("Event creation failed: ${response.responseData}");
      }
    } catch (e, s) {
      log("Exception during event creation: ${e.toString()}");
      log("Stack trace: $s");
    } finally {
      if (Get.isDialogOpen ?? false) Get.back();
      isLoading.value = false;
    }
  }

  Future<void> createCrowdFunding({String eventType = "Funding"}) async {
    isLoading.value = true;
    Get.dialog(
      CustomLoading(color: AppColors.primaryColor),
      barrierDismissible: false,
    );

    String? token = sharedPreferencesHelper.getString('userToken');

    try {
      final text = descriptionController.text.trim();

      final Map<String, dynamic> bodyData = {
        "eventType": eventType,
        "text": text,
      };

      log("Sending request with body: $bodyData");

      final response = await networkCaller.postRequest(
        AppUrls.createEvent,
        body: bodyData,
        token: token,
      );

      log(" Response status: ${response.statusCode}");
      log("Response success: ${response.isSuccess}");

      if (response.statusCode == 201 && response.isSuccess) {
        Get.snackbar("Success", "The event was successfully Created");
        getAllCrowdFunding(currentPage.value, limit.value);
        Get.back();
      } else {
        log("Event creation failed: ${response.responseData}");
      }
    } catch (e, s) {
      log("Exception during event creation: ${e.toString()}");
      log("Stack trace: $s");
    } finally {
      if (Get.isDialogOpen ?? false) Get.back();
      isLoading.value = false;
    }
  }

  /// create Like Unlike
  Future<void> createLike(String eventId) async {
    isLoading.value = true;
    Get.dialog(
      CustomLoading(color: AppColors.primaryColor),
      barrierDismissible: false,
    );
    String? token = sharedPreferencesHelper.getString('userToken');
    try {
      var response = await networkCaller.postRequest(
        AppUrls.createLike(eventId),
        body: {},
        token: token,
      );

      if (response.statusCode == 200 && response.isSuccess) {}
    } catch (e) {
      log("the exception is ${e.toString()}");
    } finally {
      if (Get.isDialogOpen ?? false) Get.back();
      isLoading.value = false;
    }
  }

  /// create comment
  Future<void> createComment(String eventId) async {
    isLoading.value = true;
    /*Get.dialog(
      CustomLoading(color: AppColors.primaryColor),
      barrierDismissible: false,
    );*/
    String? token = sharedPreferencesHelper.getString('userToken');
    try {
      var response = await networkCaller.postRequest(
        AppUrls.createComment(eventId),
        body: {"comment": commentController.text.trim()},
        token: token,
      );
      if (response.statusCode == 201 && response.isSuccess) {
        getComment(eventId);
        Get.back();
      }
    } catch (e) {
      log("the exception is ${e.toString()}");
    } finally {
      if (Get.isDialogOpen ?? false) Get.back();
      isLoading.value = false;
    }
  }

  Future<void> getComment(String eventId) async {
    isLoading.value = true;
    String? token = sharedPreferencesHelper.getString('userToken');

    try {
      var response = await networkCaller.getRequest(
        AppUrls.getComment(eventId),
        token: token,
      );

      log("Comment Response: ${response.responseData}"); // ← Debug log

      if (response.statusCode == 200 && response.isSuccess) {
        final resultData = EventCommentResult.fromJson(response.responseData);

        if (resultData.eventComment.isNotEmpty) {
          commentList.assignAll(resultData.eventComment);
          log(" ${commentList.length} comments"); // ← Debug log
        } else {
          commentList.clear();
          log("No comments found"); // ← Debug log
        }
      } else {
        log("Failed to get comments: ${response.statusCode}");
      }
    } catch (e, stackTrace) {
      log("getComment Exception: ${e.toString()}");
      log("Stack trace: $stackTrace");
      commentList.clear(); // Clear on error
    } finally {
      isLoading.value = false;
    }
  }

  /// create Reply
   Future<void> createReply(String commentId) async{
     isLoading.value = true;
     /*Get.dialog(
       CustomLoading(color: AppColors.primaryColor),
       barrierDismissible: false,
     );*/
     String? token = sharedPreferencesHelper.getString('userToken');

     try{
       var response = await networkCaller.postRequest(AppUrls.createReply(commentId), body: {
         "replyComment": replyController.text.trim()
       }, token: token);

       if(response.isSuccess){
         log("the api response is ${response.responseData}");
         Get.snackbar("Success", "The Reply is created");

       }

     }
     catch (e) {
       log("the exception is ${e.toString()}");
     } finally {
       if (Get.isDialogOpen ?? false) Get.back();
       isLoading.value = false;
     }


   }

  /// Get all events (initial load)
  Future<void> getAllCrowdFunding(int page, int limit) async {
    isLoading.value = true;
    String? token = sharedPreferencesHelper.getString("userToken");

    try {
      var response = await networkCaller.getRequest(
        AppUrls.getAllCrowdFunding(page, limit),
        token: token,
      );

      if (response.statusCode == 200 && response.isSuccess) {
        final data = response.responseData;

        final List<dynamic> eventsJson = data['events'] ?? [];

        final List<CrowdFundingEvent> events =
            eventsJson.map((json) => CrowdFundingEvent.fromJson(json)).toList();
        log("the event Data is $events");

        totalPages.value = data['totalPages'] ?? 1;
        currentPage.value = data['currentPage'] ?? 1;
        hasMoreData.value = currentPage.value < totalPages.value;

        // FIXED: Assign individual events, not wrapped result
        crowdFundList.assignAll(events);
      }
    } catch (e) {
      log("Exception: ${e.toString()}");
      Get.snackbar('Error', 'Failed to load events');
    } finally {
      isLoading.value = false;
    }
  }

  /// Load more events (pagination)
  Future<void> loadMoreEvents() async {
    if (!hasMoreData.value || isPaginationLoading.value) return;

    isPaginationLoading.value = true;
    final nextPage = currentPage.value + 1;
    String? token = sharedPreferencesHelper.getString("userToken");

    try {
      var response = await networkCaller.getRequest(
        AppUrls.getAllCrowdFunding(nextPage, limit.value),
        token: token,
      );

      if (response.statusCode == 200 && response.isSuccess) {
        final data = response.responseData;
        final List<dynamic> eventsJson = data['events'] ?? [];

        final List<CrowdFundingEvent> newEvents =
            eventsJson.map((json) => CrowdFundingEvent.fromJson(json)).toList();

        totalPages.value = data['totalPages'] ?? 1;
        currentPage.value = data['currentPage'] ?? 1;
        hasMoreData.value = currentPage.value < totalPages.value;

        crowdFundList.addAll(newEvents);
      }
    } catch (e) {
      log("Pagination exception: ${e.toString()}");
    } finally {
      isPaginationLoading.value = false;
    }
  }

  Future<void> refreshEvents() async {
    currentPage.value = 1;
    hasMoreData.value = true;
    await getAllCrowdFunding(currentPage.value, limit.value);
  }

  // ---------------- Date & Time Pickers ---------------- //

  void pickDate(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return CustomDatePicker(
          selectedDateCallback: (DateTime selectedDateValue) {
            final formattedDate =
                "${selectedDateValue.day.toString().padLeft(2, '0')}-${selectedDateValue.month.toString().padLeft(2, '0')}-${selectedDateValue.year}";
            selectedDate.value = formattedDate;

            Get.snackbar(
              "Date Selected",
              formattedDate,
              backgroundColor: Colors.white,
              colorText: Colors.black,
              snackPosition: SnackPosition.BOTTOM,
              duration: const Duration(seconds: 2),
            );
          },
        );
      },
    );
  }

  void pickTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      helpText: 'Select Event Time', // 🕒 Top title text
      cancelText: 'Cancel',
      confirmText: 'OK',

      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryColor, // header background color
              onPrimary: Colors.white, // header text color
              onSurface: Colors.black, // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primaryColor,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      selectedTime.value = picked.format(context);
      Get.snackbar(
        "Time Selected",
        selectedTime.value,
        backgroundColor: Colors.white,
        colorText: Colors.black,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
  }
}
