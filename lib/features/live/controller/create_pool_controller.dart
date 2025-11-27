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


  RxMap<String, PoolVoteResult> poolVoteMap = <String, PoolVoteResult>{}.obs;


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


  bool getCheckedValue(int pollIndex, int optionIndex) {
    if (checkedOptionsMap.containsKey(pollIndex)) {
      final list = checkedOptionsMap[pollIndex]!;
      if (optionIndex < list.length) {
        return list[optionIndex];
      }
    }
    return false;
  }

  void setCheckedValue(int pollIndex, int optionIndex, bool value) {
    if (checkedOptionsMap.containsKey(pollIndex)) {
      final list = checkedOptionsMap[pollIndex]!;
      if (optionIndex < list.length) {
        list[optionIndex] = value;
      }
    }
  }


  void clearCheckedStates() {
    checkedOptionsMap.clear();
  }


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
  /// Update pool with question and options
  Future<void> updatePool(String poolId, String streamId, String question, List<String> options) async {
    if (question.trim().isEmpty) {
      Get.snackbar("Error", "Question cannot be empty");
      return;
    }

    if (options.isEmpty) {
      Get.snackbar("Error", "Add at least one option");
      return;
    }

    isLoading.value = true;
    String? token = helper.getString("userToken");
    log("Token during update pool: $token");

    try {
      final Map<String, dynamic> body = {
        "question": question.trim(),
        "options": options, // Include options in update
      };

      log("Updating Poll Body: $body");

      var response = await networkCaller.patchRequest(
        AppUrls.updatePool(poolId),
        body: body,
        token: token,
      );

      if (response.statusCode == 200 && response.isSuccess) {
        log("Poll updated: ${response.responseData}");

        // Clear the form
        questionController.clear();
        this.options.clear();

        // Refresh poll list
        await getPool(streamId);

        Get.back();
        Get.snackbar(
          "Success",
          "Poll updated successfully",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        log("Poll update failed: ${response.responseData}");
        Get.snackbar(
          "Error",
          response.responseData?['message'] ?? "Failed to update poll",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      log("Exception in updatePool: ${e.toString()}");
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

  /// Vote on a pool with selected options
  /// Vote on a pool with selected option
  Future<void> votePool(String poolId, String streamId, List<String> selectedOptions) async {
    if (selectedOptions.isEmpty) {
      Get.snackbar("Error", "Please select at least one option");
      return;
    }

    isLoading.value = true;
    String? token = helper.getString("userToken");
    log("Token during vote pool: $token");
    log("Voting on poll: $poolId with option: ${selectedOptions.first}");

    try {
      // Send single option as string (API expects "option" not "options")
      final Map<String, dynamic> body = {
        "option": selectedOptions.first, // ✅ Send first selected option as string
      };

      log("Vote Body: $body");

      var response = await networkCaller.postRequest(
        AppUrls.votePool(poolId),
        body: body,
        token: token,
      );

      if (response.isSuccess && response.statusCode == 200) {
        log("Vote successful: ${response.responseData}");

        // Clear selected options after successful vote
        clearCheckedStates();

        // Refresh poll data and results
        await getPool(streamId);
        ///await getPoolVoteResult(streamId);

        Get.snackbar(
          "Success",
          "Vote submitted successfully",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        log("Vote failed: ${response.responseData}");
        Get.snackbar(
          "Error",
          response.responseData?['message'] ?? "Failed to submit vote",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      log("Exception in votePool: ${e.toString()}");
      Get.snackbar(
        "Error",
        "Something went wrong while voting",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// get pool vote result - FIXED VERSION
  Future<void> getPoolVoteResultByStream(String streamId) async {
    String? token = helper.getString("userToken");
    log("🔍 Fetching vote results for streamId: $streamId");

    try {
      // Use streamId instead of pollId in the endpoint
      var response = await networkCaller.getRequest(
        AppUrls.poolResult(streamId), // ✅ Pass streamId, not pollId
        token: token,
      );

      log("📊 Response Status: ${response.statusCode}");
      log("📊 Raw Response: ${response.responseData}");

      if (response.isSuccess && response.responseData != null) {
        try {
          // The response can be a single poll result or array of results
          List<dynamic> resultsArray = [];

          if (response.responseData is String) {
            final decoded = json.decode(response.responseData);
            if (decoded is Map && decoded.containsKey('result')) {
              final result = decoded['result'];
              resultsArray = result is List ? result : [result];
            } else if (decoded is List) {
              resultsArray = decoded;
            } else {
              resultsArray = [decoded];
            }
          } else if (response.responseData is Map) {
            final responseMap = Map<String, dynamic>.from(response.responseData);

            if (responseMap.containsKey('result')) {
              final result = responseMap['result'];
              resultsArray = result is List ? result : [result];
            } else {
              resultsArray = [responseMap];
            }
          } else if (response.responseData is List) {
            resultsArray = response.responseData;
          }

          log("📊 Processing ${resultsArray.length} poll result(s)");

          // Process each poll result
          for (var resultData in resultsArray) {
            final resultMap = Map<String, dynamic>.from(resultData);
            final pollResult = PoolVoteResult.fromJson(resultMap);

            // Store using poll ID as key
            poolVoteMap[pollResult.id] = pollResult;

            log("✅ Stored vote results for poll: ${pollResult.id}");
            log("   Question: ${pollResult.question}");
            log("   Total options: ${pollResult.options.length}");
          }

          // Trigger UI update
          poolVoteMap.refresh();
          log("✅ Completed fetching poll results for stream: $streamId");

        } catch (parseError, parseStack) {
          log("❌ Parse Error: $parseError");
          log("Parse Stack: $parseStack");
        }
      } else {
        log("⚠️ API call failed or returned no data");
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