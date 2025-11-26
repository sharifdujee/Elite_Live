import 'dart:developer';
import 'package:elites_live/core/global_widget/custom_text_view.dart';
import 'package:elites_live/core/global_widget/custom_elevated_button.dart';
import 'package:elites_live/core/helper/shared_prefarenses_helper.dart';
import 'package:elites_live/core/services/network_caller/repository/network_caller.dart';
import 'package:elites_live/core/utils/constants/app_colors.dart';
import 'package:elites_live/core/utils/constants/app_urls.dart';
import 'package:elites_live/routes/app_routing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../data/create_live_response_data_model.dart';



class LiveScreenController extends GetxController {
  var isCameraOn = true.obs;
  var isMicOn = true.obs;
  var isScreenSharing = false.obs;
  var isRecording = false.obs;
  var showMenu = false.obs;
  var viewerCount = 0.obs;
  var isLoading = false.obs;

  final NetworkCaller networkCaller = NetworkCaller();
  final SharedPreferencesHelper helper = SharedPreferencesHelper();
  final Uuid uuid = Uuid();

  /// Generate unique links for live streaming
  String generateHostLink() {
    return 'host_${uuid.v4()}';
  }

  String generateCoHostLink() {
    return 'cohost_${uuid.v4()}';
  }

  String generateAudienceLink() {
    return 'audience_${uuid.v4()}';
  }

  /// Create Live Stream with generated links (ONLY for hosts)
  Future<Map<String, dynamic>?> createLive({
    required bool isPaid,
    double cost = 0.0,
  }) async {
    isLoading.value = true;

    // Show loading spinner
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    String? token = helper.getString("userToken");

    if (token == null || token.isEmpty) {
      if (Get.isDialogOpen ?? false) Get.back();
      Get.snackbar(
        'Authentication Error',
        'Please login again',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      isLoading.value = false;
      return null;
    }

    try {
      // Host creates new session
      String hostLink = generateHostLink();
      String coHostLink = generateCoHostLink();
      String audienceLink = generateAudienceLink();

      Map<String, dynamic> body = {
        "hostLink": hostLink,
        "coHostLink": coHostLink,
        "audienceLink": audienceLink,
      };

      log("🔗 Generated Links:");
      log("   Host: $hostLink");
      log("   CoHost: $coHostLink");
      log("   Audience: $audienceLink");

      var response = await networkCaller.postRequest(
        AppUrls.createLive,
        body: body,
        token: token,
      );

      if (!response.isSuccess || response.responseData == null) {
        throw Exception("Failed to create live stream");
      }

      final json = response.responseData as Map<String, dynamic>;

      // Parse LiveResult
      LiveResult result = LiveResult.fromJson(
        json.containsKey('result') ? json['result'] : json,
      );

      final liveData = {
        "liveId": result.id,
        "roomId": result.id,
        "hostId": result.userId,
        "hostLink": result.hostLink,
        "coHostLink": result.coHostLink,
        "audienceLink": result.audienceLink,
        "isLive": result.isLive,
        "isPaid": isPaid,
        "cost": cost,
      };

      if (Get.isDialogOpen ?? false) Get.back();
      return liveData;
    } catch (e) {
      if (Get.isDialogOpen ?? false) Get.back();
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  /// Navigate to live screen after creating live stream
  Future<void> createAndNavigateToLive({
    required bool isPaid,
    required bool isHost,
    double cost = 0.0,
  }) async {
    log("=== createAndNavigateToLive called ===");
    log("isPaid: $isPaid, isHost: $isHost, cost: $cost");

    // Prevent multiple simultaneous calls
    if (isLoading.value) {
      log("⚠️ Already loading, ignoring duplicate call");
      return;
    }

    // Create live stream
    Map<String, dynamic>? liveData = await createLive(
      isPaid: isPaid,
      cost: cost,
    );

    // If creation successful, navigate
    if (liveData != null) {
      log("🚀 Navigating to live screen...");
      log("Navigation data: $liveData");

      try {
        if (isPaid) {
          log("Navigating to premium screen");
          await Get.toNamed(
            AppRoute.premiumScreen,
            arguments: liveData,
          );
        } else {
          log("Navigating to my live screen");
          await Get.toNamed(
            AppRoute.myLive,
            arguments: {
              ...liveData,
              'isHost': isHost,
            },
          );
        }
        log("✅ Navigation successful");
      } catch (e) {
        log("❌ Navigation error: $e");
        Get.snackbar(
          'Error',
          'Failed to navigate to live screen',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } else {
      log("❌ liveData is null, navigation cancelled");
    }
  }

  /// Join live session as audience using audience link
  /// IMPORTANT: The audience link must be in format "liveId|audienceLink"
  /// Example: "673e123abc|audience_uuid-here"
  Future<void> joinLiveAsAudience({required String audienceLink}) async {
    log("=== joinLiveAsAudience called ===");
    log("Audience Link: $audienceLink");

    // STEP 1: Parse the audience link to extract liveId
    // The link should be in format: "liveId|audience_link" or just "audience_link"
    String? liveId;
    String actualAudienceLink = audienceLink;

    if (audienceLink.contains('|')) {
      // Format: "liveId|audience_link"
      final parts = audienceLink.split('|');
      liveId = parts[0];
      actualAudienceLink = parts[1];
      log("📌 Extracted liveId: $liveId");
      log("📌 Extracted audienceLink: $actualAudienceLink");
    } else {
      // If no separator, use the audience link itself as liveId
      // This is a fallback - ideally the host should share "liveId|audienceLink"
      liveId = audienceLink;
      log("⚠️ No separator found, using entire link as liveId: $liveId");
    }

    if (liveId == null || liveId.isEmpty) {
      Get.snackbar(
        'Invalid Link',
        'The audience link is invalid. Please check and try again.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // STEP 2: Get current user info
    String? userId = helper.getString('userId') ?? 'user_${uuid.v4().substring(0, 8)}';
    String? userName = helper.getString('userName') ?? 'Guest User';

    log("🚀 Joining live stream as audience...");
    log("   Live ID (Room ID): $liveId");
    log("   User ID: $userId");
    log("   User Name: $userName");

    // STEP 3: Navigate to live screen with the SAME liveId as host
    try {
      await Get.toNamed(
        AppRoute.myLive,
        arguments: {
          'roomId': liveId, // CRITICAL: Use the same liveId as host
          'liveId': liveId, // CRITICAL: Use the same liveId as host
          'audienceLink': actualAudienceLink,
          'isHost': false, // User is audience, not host
          'isPaid': false,
          'cost': 0.0,
          'hostId': userId, // Current user's ID
          'hostLink': null,
          'coHostLink': null,
        },
      );
      log("✅ Successfully joined live stream");
    } catch (e) {
      log("❌ Navigation error: $e");
      Get.snackbar(
        'Error',
        'Failed to join live stream. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// end Live
  Future<void> leaveLive(String streamId) async {
    isLoading.value = true;
    String? token = helper.getString('userToken');
    try {
      var response = await networkCaller.postRequest(
        AppUrls.endLive(streamId),
        body: {},
        token: token,
      );
      if (response.isSuccess) {
        log("the api response is ${response.responseData}");
      }
    } catch (e) {
      log("the exception is ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  void toggleCamera() {
    isCameraOn.value = !isCameraOn.value;
  }

  void toggleMic() {
    isMicOn.value = !isMicOn.value;
  }

  void toggleScreenShare() {
    isScreenSharing.value = !isScreenSharing.value;
    showMenu.value = false;

    Get.snackbar(
      isScreenSharing.value ? 'Screen Sharing Started' : 'Screen Sharing Stopped',
      isScreenSharing.value
          ? 'Your screen is now being shared'
          : 'Screen sharing has been stopped',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black87,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  void toggleRecording() {
    isRecording.value = !isRecording.value;
    showMenu.value = false;

    Get.snackbar(
      isRecording.value ? 'Recording Started' : 'Recording Stopped',
      isRecording.value
          ? 'This session is now being recorded'
          : 'Recording has been saved',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black87,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  void toggleMenu() {
    showMenu.value = !showMenu.value;
  }

  void closeMenu() {
    showMenu.value = false;
  }

  void addContributor() {
    showMenu.value = false;
    Get.snackbar(
      'Add Contributor',
      'Opening contributor selection...',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black87,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  void openComments() {
    showMenu.value = false;
    Get.snackbar(
      'Comments',
      'Opening comments section...',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black87,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  void openPolls() {
    showMenu.value = false;
    Get.snackbar(
      'Polls',
      'Opening polls...',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black87,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  void endCall(BuildContext context, String streamId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: CustomTextView(
            text: "End Session",
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textHeader,
            textAlign: TextAlign.center,
          ),
          content: CustomTextView(
            text: "Are you sure you want to end this live session?",
            fontWeight: FontWeight.w400,
            fontSize: 14.sp,
            color: AppColors.textBody,
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CustomElevatedButton(
                    ontap: () {
                      Get.back();
                    },
                    text: "Cancel",
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: CustomElevatedButton(
                    ontap: () async {
                      Get.back(); // close dialog
                      isLoading.value = true;

                      await leaveLive(streamId);

                      isLoading.value = false;
                      Get.back(); // navigate back from live screen
                      Get.snackbar(
                        "Session Ended",
                        "Live session ended successfully",
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                        duration: const Duration(seconds: 2),
                      );
                    },
                    text: "End",
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void goBack(BuildContext context, String streamId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: CustomTextView(
            text: "Leave Live Session",
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textHeader,
            textAlign: TextAlign.center,
          ),
          content: CustomTextView(
            text: "Are you sure you want to leave this live session?",
            fontWeight: FontWeight.w400,
            fontSize: 14.sp,
            color: AppColors.textBody,
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            Row(
              children: [
                Expanded(
                  child: CustomElevatedButton(
                    ontap: () {
                      Get.back();
                    },
                    text: "Cancel",
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: CustomElevatedButton(
                    ontap: () async {
                      Get.back(); // close dialog
                      isLoading.value = true;

                      await leaveLive(streamId);

                      isLoading.value = false;
                      Get.back(); // leave live screen
                      Get.snackbar(
                        "Left Session",
                        "You have left the live session",
                        backgroundColor: Colors.orange,
                        colorText: Colors.white,
                        duration: const Duration(seconds: 2),
                      );
                    },
                    text: "Leave",
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}