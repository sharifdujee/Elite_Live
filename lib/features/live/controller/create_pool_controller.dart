import 'dart:convert';
import 'dart:developer';

import 'package:elites_live/core/helper/shared_prefarenses_helper.dart';
import 'package:elites_live/core/services/network_caller/repository/network_caller.dart';
import 'package:elites_live/core/utils/constants/app_urls.dart';
import 'package:elites_live/features/live/data/pool_data_model.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class CreatePollController extends GetxController {
  final questionController = TextEditingController();
  final newOptionController = TextEditingController();
  final RxList<String> options = <String>[].obs;
  var isLoading = false.obs;
  final NetworkCaller networkCaller = NetworkCaller();
  final SharedPreferencesHelper helper = SharedPreferencesHelper();
  RxList<PoolResult> poolList =<PoolResult>[].obs;

  @override
  void onInit() {
    // TODO: implement onInit

    super.onInit();
  }

  void addOption(String option) {
    if (option.trim().isNotEmpty) {
      options.add(option.trim());
      newOptionController.clear();
    }
  }

  /// create pool
  Future<void> createPool(String streamId) async {
    isLoading.value = true;

    String? token = helper.getString("userToken");
    log("token during create pool: $token");

    try {
      // Build request body matching the API format
      final Map<String, dynamic> body = {
        "question": questionController.text.trim(),
        "options": options.toList(), // << SEND LIST OF STRING
      };

      log("📤 Sending Poll Body: $body");

      var response = await networkCaller.postRequest(
        AppUrls.createPool(streamId),
        body: body,
        token: token,
      );

      if (response.statusCode == 201 && response.isSuccess) {
        log("✅ Poll Created: ${response.responseData}");

        Get.back(); // close dialog
        Get.snackbar(
          "Success",
          "Poll created successfully",
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        log("❌ Poll Create Failed: ${response.responseData}");
        Get.snackbar("Error", "Failed to create poll");
      }
    } catch (e) {
      log("❌ Exception in createPool: ${e.toString()}");
      Get.snackbar("Error", "Something went wrong");
    } finally {
      isLoading.value = false;
    }
  }

  /// get pool
  /// get pool
  Future<void> getPool(String streamId) async {
    isLoading.value = true;
    String? token = helper.getString("userToken");
    log("🔹 Fetching polls for streamId: $streamId");

    try {
      var response = await networkCaller.getRequest(
        AppUrls.getSinglePool(streamId),
        token: token,
      );

      log("🔹 Response Status: ${response.statusCode}");
      log("🔹 Response Data Type: ${response.responseData.runtimeType}");
      log("🔹 Raw Response: ${response.responseData}");

      if (response.isSuccess && response.responseData != null) {

        PoolDataModel poolData;

        // Handle different response types
        if (response.responseData is String) {
          log("🔹 Parsing from String");
          poolData = poolDataModelFromJson(response.responseData);

        } else if (response.responseData is Map) {
          log("🔹 Parsing from Map");
          poolData = PoolDataModel.fromJson(
              Map<String, dynamic>.from(response.responseData)
          );

        } else if (response.responseData is List) {
          // ✅ Handle List case - wrap it in the expected structure
          log("🔹 Response is a List - wrapping in PoolDataModel");
          poolData = PoolDataModel(
            success: true,
            message: "Polls retrieved",
            result: (response.responseData as List)
                .map((item) => PoolResult.fromJson(
                Map<String, dynamic>.from(item)
            ))
                .toList(),
          );

        } else {
          log("❌ Unexpected response type: ${response.responseData.runtimeType}");
          Get.snackbar("Error", "Invalid response format: ${response.responseData.runtimeType}");
          return;
        }

        if (poolData.success && poolData.result.isNotEmpty) {
          poolList.value = poolData.result;
          log("✅ Successfully loaded ${poolList.length} polls");

          // Log each poll for verification
          for (var poll in poolList) {
            log("  - Poll: ${poll.question}");
          }

        } else {
          log("⚠️ No polls found or success=false");
          poolList.clear();
        }

      } else {
        log("❌ API call failed with status: ${response.statusCode}");
        Get.snackbar("Error", "Failed to load polls");
      }

    } catch (e, stackTrace) {
      log("❌ Exception in getPool: $e");
      log("Stack trace: $stackTrace");
      Get.snackbar("Error", "Error loading polls: ${e.toString()}");
    } finally {
      isLoading.value = false;
      log("🔹 getPool completed. poolList.length = ${poolList.length}");
    }
  }




  void removeOption(int index) {
    options.removeAt(index);
  }

  void savePoll() {
    if (questionController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter a question',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (options.length < 2) {
      Get.snackbar(
        'Error',
        'Please add at least 2 options',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Handle save logic here
    Get.back();
    Get.snackbar(
      'Success',
      'Poll created successfully',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  @override
  void onClose() {
    questionController.clear();
    newOptionController.clear();
    super.onClose();
  }
}