import 'package:elites_live/core/helper/shared_prefarenses_helper.dart';
import 'package:elites_live/core/services/network_caller/repository/network_caller.dart';
import 'package:elites_live/features/event/data/crowd_funding_data_model.dart';
import 'package:elites_live/features/event/data/others_user_data_model.dart';
import 'package:elites_live/features/event/data/others_user_schedule_event.dart';
import 'package:elites_live/routes/app_routing.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'dart:developer';
import '../../../core/global_widget/custom_date_time_dialogue.dart';
import '../../../core/global_widget/custom_loading.dart';
import '../../../core/utils/constants/app_colors.dart';
import '../../../core/utils/constants/app_urls.dart';
import 'package:intl/intl.dart';
import '../data/event_comment_data_model.dart';
import 'dart:convert';
import 'package:uuid/uuid.dart';

import '../data/others_user_funding_data_model.dart';

class ScheduleController extends GetxController {
  var selectedDate = ''.obs;
  var selectedTime = ''.obs;
  var isLoading = false.obs;
  RxInt page = 1.obs;
  RxInt limit = 10.obs;
  final Uuid uuid = Uuid();
  final TextEditingController commentController = TextEditingController();
  TextEditingController replyController = TextEditingController();
  RxList<CrowdFundingEvent> crowdFundList = <CrowdFundingEvent>[].obs;
  RxList<EventCommentResult> commentResult = <EventCommentResult>[].obs;
  RxList<EventComment> commentList = <EventComment>[].obs;
  final TextEditingController amountController = TextEditingController();
  final TextEditingController eventTitleController = TextEditingController();
  final TextEditingController crowdFundTitleController = TextEditingController();
  RxList<OthersUserResult> othersUserInfo = <OthersUserResult>[].obs;
  RxList<OthersUserScheduleEventResult> otherScheduleEvent = <OthersUserScheduleEventResult>[].obs;
  RxList<OthersUserFundingResult> othersUserFundingResult = <OthersUserFundingResult>[].obs;

  RxInt currentPage = 1.obs;
  RxInt totalPages = 1.obs;
  RxBool hasMoreData = true.obs;
  RxBool isPaginationLoading = false.obs;

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

  String generateHostLink() {
    return 'host_${uuid.v4()}';
  }

  String generateCoHostLink() {
    return 'cohost_${uuid.v4()}';
  }

  String generateAudienceLink() {
    return 'audience_${uuid.v4()}';
  }

  Future<void> createLiveEvent({String eventType = "Schedule"}) async {
    isLoading.value = true;
    Get.dialog(
      CustomLoading(color: AppColors.primaryColor),
      barrierDismissible: false,
    );

    String? token = sharedPreferencesHelper.getString('userToken');

    try {
      String hostLink = generateHostLink();
      String coHostLink = generateCoHostLink();
      String audienceLink = generateAudienceLink();
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

      final formattedDate = DateFormat(
        "yyyy-MM-dd'T'HH:mm:ss.SSS'+00:00'",
      ).format(parsedDate.toUtc());

      final Map<String, dynamic> bodyData = {
        "eventType": eventType,
        "title": eventTitleController.text.trim(),
        "text": text,
        "hostLink": hostLink,
        'coHostLink': coHostLink,
        'audienceLink': audienceLink,
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

      log("Response status: ${response.statusCode}");
      log("Response success: ${response.isSuccess}");

      if (response.statusCode == 201 && response.isSuccess) {
        log("Event created successfully.");
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
      String hostLink = generateHostLink();
      String coHostLink = generateCoHostLink();
      String audienceLink = generateAudienceLink();
      final text = descriptionController.text.trim();

      final Map<String, dynamic> bodyData = {
        "eventType": eventType,
        'title': crowdFundTitleController.text.trim(),
        "hostLink": hostLink,
        'coHostLink': coHostLink,
        'audienceLink': audienceLink,
        "text": text,
      };

      log("Sending request with body: $bodyData");

      final response = await networkCaller.postRequest(
        AppUrls.createEvent,
        body: bodyData,
        token: token,
      );

      log("Response status: ${response.statusCode}");
      log("Response success: ${response.isSuccess}");

      if (response.statusCode == 201 && response.isSuccess) {
        // ✅ Close loading dialog
        if (Get.isDialogOpen ?? false) {
          Get.back();
        }

        // ✅ Clear form
        crowdFundTitleController.clear();
        descriptionController.clear();

        // ✅ Show success message
        Get.snackbar(
          "Success",
          "The event was successfully created",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // ✅ Refresh data
        await getAllCrowdFunding(currentPage.value, limit.value);

        // ✅ Navigate back
        Get.back();

      } else {
        log("Event creation failed: ${response.responseData}");

        // ✅ Close loading dialog
        if (Get.isDialogOpen ?? false) {
          Get.back();
        }

        // ✅ Show error
        Get.snackbar(
          "Error",
          "Failed to create event",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e, s) {
      log("Exception during event creation: ${e.toString()}");
      log("Stack trace: $s");

      // ✅ Close loading dialog
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      // ✅ Show error
      Get.snackbar(
        "Error",
        "Something went wrong",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }



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

  Future<void> createComment(String eventId) async {
    isLoading.value = true;
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

      log("Comment Response: ${response.responseData}");

      if (response.statusCode == 200 && response.isSuccess) {
        final resultData = EventCommentResult.fromJson(response.responseData);

        if (resultData.eventComment.isNotEmpty) {
          commentList.assignAll(resultData.eventComment);
          log("${commentList.length} comments");
        } else {
          commentList.clear();
          log("No comments found");
        }
      } else {
        log("Failed to get comments: ${response.statusCode}");
      }
    } catch (e, stackTrace) {
      log("getComment Exception: ${e.toString()}");
      log("Stack trace: $stackTrace");
      commentList.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createReply(String commentId) async {
    isLoading.value = true;
    String? token = sharedPreferencesHelper.getString('userToken');

    try {
      var response = await networkCaller.postRequest(
        AppUrls.createReply(commentId),
        body: {"replyComment": replyController.text.trim()},
        token: token,
      );

      if (response.isSuccess) {
        log("the api response is ${response.responseData}");
        Get.snackbar("Success", "The Reply is created");
      }
    } catch (e) {
      log("the exception is ${e.toString()}");
    } finally {
      if (Get.isDialogOpen ?? false) Get.back();
      isLoading.value = false;
    }
  }

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

        crowdFundList.assignAll(events);
      }
    } catch (e) {
      log("Exception: ${e.toString()}");
      Get.snackbar('Error', 'Failed to load events');
    } finally {
      isLoading.value = false;
    }
  }

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

  /// get others user information
  Future<void> getSingleUser(String userId) async {
    isLoading.value = true;
    String? token = sharedPreferencesHelper.getString('userToken');
    log("the token during get single user $token");
    try {
      var response = await networkCaller.getRequest(
          AppUrls.getOtherUserInfo(userId),
          token: token);

      log("Response isSuccess: ${response.isSuccess}");
      log("Response data type: ${response.responseData.runtimeType}");

      if (response.isSuccess && response.responseData != null) {
        log("Raw API response: ${response.responseData}");

        // Handle both String and Map response types
        Map<String, dynamic> resultData;

        if (response.responseData is String) {
          log("Response is String, decoding...");
          resultData = json.decode(response.responseData);
        } else if (response.responseData is Map) {
          log("Response is already a Map");
          resultData = Map<String, dynamic>.from(response.responseData);
        } else {
          log("Unexpected response type: ${response.responseData.runtimeType}");
          throw Exception("Unexpected response type");
        }

        log("Result data: $resultData");

        // IMPORTANT: Your network caller already extracts the 'result' field!
        // So resultData IS the user object, not the full response
        final userResult = OthersUserResult.fromJson(resultData);
        log("Parsed user: ${userResult.firstName} ${userResult.lastName}");

        othersUserInfo.value = [userResult];
        log("othersUserInfo updated, length: ${othersUserInfo.length}");
        log("First user: ${othersUserInfo.isNotEmpty ? othersUserInfo[0]
            .firstName : 'empty'}");
      } else {
        log("Response not successful or data is null");
      }
    } catch (e, stackTrace) {
      log("Exception: ${e.toString()}");
      log("Stack trace: $stackTrace");
    } finally {
      isLoading.value = false;
      log("Loading completed, isLoading: ${isLoading.value}");
    }
  }

  /// others user schedule event
  Future<void>getOthersUserScheduleEvent(String userId)async{
    String? token = sharedPreferencesHelper.getString('userToken');
    log("the token during get single user $token");
    try {
      var response = await networkCaller.getRequest(
          AppUrls.getOthersUserScheduleEvent(userId),
          token: token);

      log("Response isSuccess: ${response.isSuccess}");
      log("Response data type: ${response.responseData.runtimeType}");

      if (response.isSuccess && response.responseData != null) {
        log("Raw API response: ${response.responseData}");

        // Handle both String and Map response types
        Map<String, dynamic> resultData;

        if (response.responseData is String) {
          log("Response is String, decoding...");
          resultData = json.decode(response.responseData);
        } else if (response.responseData is Map) {
          log("Response is already a Map");
          resultData = Map<String, dynamic>.from(response.responseData);
        } else {
          log("Unexpected response type: ${response.responseData.runtimeType}");
          throw Exception("Unexpected response type");
        }

        log("Result data: $resultData");

        // IMPORTANT: Your network caller already extracts the 'result' field!
        // So resultData IS the user object, not the full response
        final userResult = OthersUserScheduleEventResult.fromJson(resultData);


        otherScheduleEvent.value = [userResult];
        log("othersUserInfo updated, length: ${othersUserInfo.length}");

      } else {
        log("Response not successful or data is null");
      }
    } catch (e, stackTrace) {
      log("Exception: ${e.toString()}");
      log("Stack trace: $stackTrace");
    } finally {
      isLoading.value = false;
      log("Loading completed, isLoading: ${isLoading.value}");
    }
  }

  /// get others crowd Fund
  Future<void>getOthersUserCrowdEvent(String userId)async{
    String? token = sharedPreferencesHelper.getString('userToken');
    log("the token during get single user $token");
    try {
      var response = await networkCaller.getRequest(
          AppUrls.getOthersUserFundingEvent(userId),
          token: token);

      log("Response isSuccess: ${response.isSuccess}");
      log("Response data type: ${response.responseData.runtimeType}");

      if (response.isSuccess && response.responseData != null) {
        log("Raw API response: ${response.responseData}");

        // Handle both String and Map response types
        Map<String, dynamic> resultData;

        if (response.responseData is String) {
          log("Response is String, decoding...");
          resultData = json.decode(response.responseData);
        } else if (response.responseData is Map) {
          log("Response is already a Map");
          resultData = Map<String, dynamic>.from(response.responseData);
        } else {
          log("Unexpected response type: ${response.responseData.runtimeType}");
          throw Exception("Unexpected response type");
        }

        log("Result data: $resultData");

        // IMPORTANT: Your network caller already extracts the 'result' field!
        // So resultData IS the user object, not the full response
        final userResult = OthersUserFundingResult.fromJson(resultData);


        othersUserFundingResult.value = [userResult];
        log("othersUserInfo updated, length: ${othersUserInfo.length}");

      } else {
        log("Response not successful or data is null");
      }
    } catch (e, stackTrace) {
      log("Exception: ${e.toString()}");
      log("Stack trace: $stackTrace");
    } finally {
      isLoading.value = false;
      log("Loading completed, isLoading: ${isLoading.value}");
    }
  }




    /// ✅ UPDATED: Create donation and open WebView
    Future<void> createDonation(String eventId) async {
      String? token = sharedPreferencesHelper.getString("userToken");
      log("token during create donation payment: $token");

      try {
        var response = await networkCaller.postRequest(
          AppUrls.giveDonation(eventId),
          body: {"amount": double.tryParse(amountController.text.trim())},
          token: token,
        );

        if (Get.isDialogOpen ?? false) {
          Get.back();
        }

        if (response.isSuccess && response.statusCode == 201) {
          log("Full response: ${response.responseData}");

          // If responseData already contains checkoutUrl directly
          final checkoutUrl = response.responseData['checkoutUrl'];

          if (checkoutUrl != null) {
            Get.offAllNamed(AppRoute.paymentWebView, arguments: {
              'url': checkoutUrl.toString(),
              'title': 'Complete Payment'
            });
          }
        }
      } catch (e, stackTrace) {
        log("Exception: $e");
        log("Stack: $stackTrace");
        if (Get.isDialogOpen ?? false) Get.back();
      } finally {
        isLoading.value = false;
        amountController.clear();
      }
    }

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
                  "${selectedDateValue.day.toString().padLeft(
                  2, '0')}-${selectedDateValue.month.toString().padLeft(
                  2, '0')}-${selectedDateValue.year}";
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
        helpText: 'Select Event Time',
        cancelText: 'Cancel',
        confirmText: 'OK',
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: AppColors.primaryColor,
                onPrimary: Colors.white,
                onSurface: Colors.black,
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

