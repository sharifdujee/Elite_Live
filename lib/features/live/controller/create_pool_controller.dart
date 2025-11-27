import 'dart:convert';
import 'dart:developer';

import 'package:elites_live/core/helper/shared_prefarenses_helper.dart';
import 'package:elites_live/core/services/network_caller/repository/network_caller.dart';
import 'package:elites_live/core/utils/constants/app_urls.dart';
import 'package:elites_live/features/live/data/pool_data_model.dart';
import 'package:elites_live/features/live/data/pool_vote_data_model.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';



class CreatePollController extends GetxController {
  final questionController = TextEditingController();
  final newOptionController = TextEditingController();
  final RxList<String> options = <String>[].obs;
  var isLoading = false.obs;
  final NetworkCaller networkCaller = NetworkCaller();
  final SharedPreferencesHelper helper = SharedPreferencesHelper();
  RxList<PoolResult> poolList = <PoolResult>[].obs;

  // IMPORTANT: Use Map instead of List for vote results
  RxMap<String, PoolVoteResult> poolVoteMap = <String, PoolVoteResult>{}.obs;

  // Map to store checked states: pollIndex -> [list of bool for each option]
  final RxMap<int, RxList<bool>> checkedOptionsMap = <int, RxList<bool>>{}.obs;

  @override
  void onInit() {
    super.onInit();
  }

  // Initialize checked options for a specific poll
  void initializeCheckedOptions(int pollIndex, int optionsCount) {
    if (!checkedOptionsMap.containsKey(pollIndex)) {
      checkedOptionsMap[pollIndex] = List<bool>.generate(optionsCount, (_) => false).obs;
    }
  }

  // Get checked value for a specific poll's option
  bool getCheckedValue(int pollIndex, int optionIndex) {
    if (checkedOptionsMap.containsKey(pollIndex)) {
      final list = checkedOptionsMap[pollIndex]!;
      if (optionIndex < list.length) {
        return list[optionIndex];
      }
    }
    return false;
  }

  // Set checked value for a specific poll's option
  void setCheckedValue(int pollIndex, int optionIndex, bool value) {
    if (checkedOptionsMap.containsKey(pollIndex)) {
      final list = checkedOptionsMap[pollIndex]!;
      if (optionIndex < list.length) {
        list[optionIndex] = value;
      }
    }
  }

  // Clear all checked states (call this when closing dialog or after actions)
  void clearCheckedStates() {
    checkedOptionsMap.clear();
  }

  // Get selected options for a specific poll (returns list of selected option texts)
  List<String> getSelectedOptions(int pollIndex, List<String> pollOptions) {
    if (!checkedOptionsMap.containsKey(pollIndex)) {
      return [];
    }

    final checkedList = checkedOptionsMap[pollIndex]!;
    final selectedOptions = <String>[];

    for (int i = 0; i < checkedList.length && i < pollOptions.length; i++) {
      if (checkedList[i]) {
        selectedOptions.add(pollOptions[i]);
      }
    }

    return selectedOptions;
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
      final Map<String, dynamic> body = {
        "question": questionController.text.trim(),
        "options": options.toList(),
      };

      log("Sending Poll Body: $body");

      var response = await networkCaller.postRequest(
        AppUrls.createPool(streamId),
        body: body,
        token: token,
      );

      if (response.statusCode == 201 && response.isSuccess) {
        log("Poll Created: ${response.responseData}");

        // Clear fields and refresh
        questionController.clear();
        options.clear();
        await getPool(streamId);

        Get.back();
        Get.snackbar(
          "Success",
          "Poll created successfully",
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        log("Poll Create Failed: ${response.responseData}");
        Get.snackbar("Error", "Failed to create poll");
      }
    } catch (e) {
      log("Exception in createPool: ${e.toString()}");
      Get.snackbar("Error", "Something went wrong");
    } finally {
      isLoading.value = false;
    }
  }

  /// get pool
  Future<void> getPool(String streamId) async {
    isLoading.value = true;
    String? token = helper.getString("userToken");
    log("Fetching polls for streamId: $streamId");

    try {
      var response = await networkCaller.getRequest(
        AppUrls.getSinglePool(streamId),
        token: token,
      );

      log("Response Status: ${response.statusCode}");
      log("Response Data Type: ${response.responseData.runtimeType}");
      log("Raw Response: ${response.responseData}");

      if (response.isSuccess && response.responseData != null) {
        PoolDataModel poolData;

        if (response.responseData is String) {
          log("Parsing from String");
          poolData = poolDataModelFromJson(response.responseData);
        } else if (response.responseData is Map) {
          log("Parsing from Map");
          poolData = PoolDataModel.fromJson(
              Map<String, dynamic>.from(response.responseData));
        } else if (response.responseData is List) {
          log("Response is a List - wrapping in PoolDataModel");
          poolData = PoolDataModel(
            success: true,
            message: "Polls retrieved",
            result: (response.responseData as List)
                .map((item) =>
                PoolResult.fromJson(Map<String, dynamic>.from(item)))
                .toList(),
          );
        } else {
          log("Unexpected response type: ${response.responseData.runtimeType}");
          Get.snackbar("Error",
              "Invalid response format: ${response.responseData.runtimeType}");
          return;
        }

        if (poolData.success && poolData.result.isNotEmpty) {
          poolList.value = poolData.result;
          log("Successfully loaded ${poolList.length} polls");

          for (var poll in poolList) {
            log("  - Poll: ${poll.question}");
          }
        } else {
          log("⚠️ No polls found or success=false");
          poolList.clear();
        }
      } else {
        log("API call failed with status: ${response.statusCode}");
        Get.snackbar("Error", "Failed to load polls");
      }
    } catch (e, stackTrace) {
      log("Exception in getPool: $e");
      log("Stack trace: $stackTrace");
      Get.snackbar("Error", "Error loading polls: ${e.toString()}");
    } finally {
      isLoading.value = false;
      log("🔹 getPool completed. poolList.length = ${poolList.length}");
    }
  }

  /// update pool
  Future<void> updatePool(String poolId, String streamId) async {
    isLoading.value = true;
    String? token = helper.getString("userToken");
    log("token during update pool: $token");

    try {
      final Map<String, dynamic> body = {
        "question": questionController.text.trim(),
        "options": options.toList(),
      };

      log("Sending Poll Body: $body");

      var response = await networkCaller.patchRequest(
        AppUrls.updatePool(poolId),
        body: body,
        token: token,
      );

      if (response.statusCode == 200 && response.isSuccess) {
        log("Poll updated: ${response.responseData}");
        await getPool(streamId);

        Get.back();
        Get.snackbar(
          "Success",
          "Poll updated successfully",
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        log("Poll updated Failed: ${response.responseData}");
        Get.snackbar("Error", "Failed to update poll");
      }
    } catch (e) {
      log("Exception in update: ${e.toString()}");
      Get.snackbar("Error", "Something went wrong");
    } finally {
      isLoading.value = false;
    }
  }

  /// delete pool
  Future<void> deletePool(String poolId, String streamId) async {
    isLoading.value = true;
    String? token = helper.getString("userToken");
    log("the token during delete pool is $token");
    try {
      var response =
      await networkCaller.deleteRequest(AppUrls.deletePool(poolId), token);
      if (response.isSuccess) {
        log("the api response is ${response.responseData}");
        await getPool(streamId);
        Get.snackbar("Success", "Poll deleted successfully");
      }
    } catch (e) {
      log("the exception is ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  /// get pool vote result - FIXED VERSION
  Future<void> getPoolVoteResult(String pollId) async {
    String? token = helper.getString("userToken");
    log("🔍 Fetching vote results for pollId: $pollId");

    try {
      var response = await networkCaller.getRequest(
        AppUrls.poolResult(pollId),
        token: token,
      );

      log("📊 Response Status: ${response.statusCode}");
      log("📊 Raw Response: ${response.responseData}");

      if (response.isSuccess && response.responseData != null) {
        try {
          PoolVoteDataModel poolVoteData;

          if (response.responseData is String) {
            // Parse JSON string
            final decoded = json.decode(response.responseData);
            poolVoteData = PoolVoteDataModel.fromJson(
                Map<String, dynamic>.from(decoded));
          } else if (response.responseData is Map) {
            // Already a Map
            final responseMap =
            Map<String, dynamic>.from(response.responseData);

            // Check structure: does it have 'result' key or is it the result itself?
            if (responseMap.containsKey('result') &&
                responseMap.containsKey('success')) {
              // Full response: {success: true, message: "...", result: {...}}
              poolVoteData = PoolVoteDataModel.fromJson(responseMap);
            } else {
              // Direct result: {id: "...", question: "...", options: [...]}
              poolVoteData = PoolVoteDataModel(
                success: true,
                message: "Poll result retrieved",
                result: PoolVoteResult.fromJson(responseMap),
              );
            }
          } else {
            log("⚠️ Unexpected response type: ${response.responseData.runtimeType}");
            return;
          }

          // CRITICAL: Store in map using poll ID
          poolVoteMap[pollId] = poolVoteData.result;

          log("✅ Stored vote results for poll: $pollId");
          log("   Question: ${poolVoteData.result.question}");
          log("   Total options: ${poolVoteData.result.options.length}");

          // Trigger UI update
          poolVoteMap.refresh();

        } catch (parseError, parseStack) {
          log("❌ Parse Error: $parseError");
          log("Parse Stack: $parseStack");
        }
      }
    } catch (e, stackTrace) {
      log("❌ Network Error: $e");
      log("Stack: $stackTrace");
    }
  }

  /// Get vote result for specific poll by ID
  PoolVoteResult? getVoteResultForPoll(String pollId) {
    final result = poolVoteMap[pollId];
    log("🔍 Looking up vote result for poll: $pollId, Found: ${result != null}");
    return result;
  }

  void removeOption(int index) {
    options.removeAt(index);
  }

  @override
  void onClose() {
    questionController.clear();
    newOptionController.clear();
    options.clear();
    clearCheckedStates();
    super.onClose();
  }
}