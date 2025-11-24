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
  var viewerCount = 234.obs;
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

  /// Create Live Stream with generated links
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

    // Validate token
    if (token == null || token.isEmpty) {
      log("❌ ERROR: User token is missing");
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

    // Generate links
    String hostLink = generateHostLink();
    String coHostLink = generateCoHostLink();
    String audienceLink = generateAudienceLink();

    log("🔗 Generated Links:");
    log("   Host: $hostLink");
    log("   CoHost: $coHostLink");
    log("   Audience: $audienceLink");

    try {
      var response = await networkCaller.postRequest(
        AppUrls.createLive,
        body: {
          "hostLink": hostLink,
          "coHostLink": coHostLink,
          "audienceLink": audienceLink,
        },
        token: token,
      );

      log("📌 Status: ${response.statusCode}");
      log("📌 Raw Response: ${response.responseData}");
      log("📌 Is Success: ${response.isSuccess}");

      // Handle non-success responses
      if (response.statusCode != 201 || !response.isSuccess) {
        String errorMessage = "Failed to create live stream";

        // Try to extract error message from response
        if (response.responseData != null) {
          if (response.responseData is Map<String, dynamic>) {
            errorMessage = response.responseData['message'] ?? errorMessage;
          } else if (response.responseData is String) {
            errorMessage = response.responseData;
          }
        }

        log("❌ API Error: $errorMessage");
        throw Exception(errorMessage);
      }

      final json = response.responseData;

      if (json == null) {
        throw Exception("Response data is null");
      }

      log("📦 JSON Type: ${json.runtimeType}");
      log("📦 JSON Content: $json");

      LiveResult result;

      // Handle both possible response structures
      if (json is Map<String, dynamic>) {
        // Check if response has 'result' wrapper
        if (json.containsKey('result') && json['result'] is Map<String, dynamic>) {
          log("✅ Parsing from wrapped response");
          result = LiveResult.fromJson(json['result']);
        }
        // Direct result object (already extracted by NetworkCaller)
        else if (json.containsKey('id') && json.containsKey('userId')) {
          log("✅ Parsing from direct response");
          result = LiveResult.fromJson(json);
        } else {
          log("❌ Unknown response structure: $json");
          throw Exception("Invalid response structure");
        }
      } else {
        throw Exception("Invalid JSON type: ${json.runtimeType}");
      }

      log("🎉 Parsed Live ID: ${result.id}");
      log("🎉 Host Link: ${result.hostLink}");
      log("🎉 User ID: ${result.userId}");

      // Build navigation data
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

      log("📊 Live Data: $liveData");

      // Close loading dialog
      if (Get.isDialogOpen ?? false) Get.back();

      return liveData;
    } catch (e, stack) {
      log("❌ ERROR: $e");
      log("📍 STACK: $stack");

      if (Get.isDialogOpen ?? false) Get.back();

      // Show user-friendly error message
      String userMessage = "An error occurred creating live stream";
      if (e.toString().contains("token") || e.toString().contains("auth")) {
        userMessage = "Authentication failed. Please login again.";
      } else if (e.toString().contains("network") || e.toString().contains("connection")) {
        userMessage = "Network error. Please check your connection.";
      }

      Get.snackbar(
        'Error',
        userMessage,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
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

  void endCall(BuildContext context) {
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
                    ontap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
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

  void goBack(BuildContext context) {
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
                    ontap: () {
                      Get.back();
                      Get.back();
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