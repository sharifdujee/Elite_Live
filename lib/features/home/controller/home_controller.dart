import 'dart:developer';
import 'dart:io';
import 'package:elites_live/core/global_widget/custom_loading.dart';
import 'package:elites_live/core/helper/shared_prefarenses_helper.dart';
import 'package:elites_live/core/services/network_caller/repository/network_caller.dart';
import 'package:elites_live/core/utils/constants/app_colors.dart';
import 'package:elites_live/core/utils/constants/app_urls.dart';
import 'package:elites_live/core/utils/constants/image_path.dart';
import 'package:elites_live/features/home/data/all_stream_data_model.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../data/comment_data_model.dart';

import 'dart:developer';
import 'dart:io';
import 'package:elites_live/core/global_widget/custom_loading.dart';
import 'package:elites_live/core/helper/shared_prefarenses_helper.dart';
import 'package:elites_live/core/services/network_caller/repository/network_caller.dart';
import 'package:elites_live/core/utils/constants/app_colors.dart';
import 'package:elites_live/core/utils/constants/app_urls.dart';
import 'package:elites_live/core/utils/constants/image_path.dart';
import 'package:elites_live/features/home/data/all_stream_data_model.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../data/comment_data_model.dart';

class HomeController extends GetxController {
  var searchText = ''.obs;
  var selectedTab = 0.obs;
  var commentText = ''.obs;
  var selectedDonationAmount = 0.0.obs;
  var isLoading = false.obs;
  final NetworkCaller networkCaller = NetworkCaller();
  final SharedPreferencesHelper helper = SharedPreferencesHelper();
  RxList<Event> allStreamList = <Event>[].obs;
  RxInt currentPage = 1.obs;
  RxInt limit = 10.obs;

  @override
  void onInit() {
    super.onInit();
    getAllRecordedLive(currentPage.value, limit.value);
  }

  /// get all recording
  Future<void> getAllRecordedLive(int currentPage, int limit) async {
    isLoading.value = true;

    Get.dialog(
      CustomLoading(color: AppColors.primaryColor),
      barrierDismissible: false,
    );

    String? token = helper.getString("userToken");

    try {
      var response = await networkCaller.getRequest(
        AppUrls.getAllRecordedLive(currentPage, limit),
        token: token,
      );

      if (response.isSuccess) {
        log("The recorded live is ${response.responseData}");

        final allStream = AllRecordedEventDataModel.fromJson(response.responseData);

        // Clear and assign new data
        allStreamList.clear();
        allStreamList.assignAll(allStream.result.events);

        log("Total events loaded: ${allStreamList.length}");

        // Force UI update
        allStreamList.refresh();
      } else {
        log("API Error: ${response.errorMessage}");
        Get.snackbar(
          'Error',
          'Failed to load events',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e, stackTrace) {
      log("Exception: ${e.toString()}");
      log("StackTrace: ${stackTrace.toString()}");
      Get.snackbar(
        'Error',
        'Something went wrong: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;

      /// Close the loading dialog
      if (Get.isDialogOpen == true) {
        Get.back();
      }
    }
  }

  // Method to get filtered events based on tab
  List<Event> get filteredEvents {
    if (searchText.value.isEmpty) {
      return allStreamList;
    }

    return allStreamList.where((event) {
      final searchLower = searchText.value.toLowerCase();
      return event.title.toLowerCase().contains(searchLower) ||
          event.text.toLowerCase().contains(searchLower) ||
          event.user.firstName.toLowerCase().contains(searchLower) ||
          event.user.lastName.toLowerCase().contains(searchLower);
    }).toList();
  }

  // Get live events only
  List<Event> get liveEvents {
    return allStreamList.where((event) => event.stream.isLive).toList();
  }

  // Get recorded events only
  List<Event> get recordedEvents {
    return allStreamList.where((event) => !event.stream.isLive).toList();
  }

  // Get scheduled events
  List<Event> get scheduledEvents {
    return allStreamList.where((event) => event.eventType == 'Schedule').toList();
  }

  // Get funding events
  List<Event> get fundingEvents {
    return allStreamList.where((event) => event.eventType == 'Funding').toList();
  }

  var commentImage = Rx<File?>(null);
  var isEmojiVisible = false.obs;
  final commentController = TextEditingController();
  var comments = <Comment>[].obs;

  // Tab control
  void onTabSelected(int index) => selectedTab.value = index;

  void onSearchChanged(String value) => searchText.value = value;

  void toggleEmojiKeyboard() {
    isEmojiVisible.value = !isEmojiVisible.value;
  }

  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source, imageQuality: 75);
    if (picked != null) {
      commentImage.value = File(picked.path);
    }
  }

  void clearCommentState() {
    commentController.clear();
    commentImage.value = null;
    isEmojiVisible.value = false;
  }

  void submitComment(String text, {String? replyToId}) {
    if (text.trim().isEmpty && commentImage.value == null) return;

    final newComment = Comment(
      id: UniqueKey().toString(),
      userName: 'You',
      userImage: ImagePath.user,
      text: text,
      imagePath: commentImage.value?.path,
      timestamp: DateTime.now(),
    );

    if (replyToId != null) {
      final parentIndex = comments.indexWhere((c) => c.id == replyToId);
      if (parentIndex != -1) {
        comments[parentIndex].replies.add(newComment);
        comments.refresh();
        clearCommentState();
        return;
      }
    }

    comments.insert(0, newComment);
    clearCommentState();
  }

  void toggleLike(String commentId, {String? parentId}) {
    if (parentId != null) {
      final parent = comments.firstWhere((c) => c.id == parentId);
      final reply = parent.replies.firstWhere((r) => r.id == commentId);
      reply.isLiked.value = !reply.isLiked.value;
    } else {
      final comment = comments.firstWhere((c) => c.id == commentId);
      comment.isLiked.value = !comment.isLiked.value;
    }
    comments.refresh();
  }

  // Refresh method for pull-to-refresh
  Future<void> refreshEvents() async {
    currentPage.value = 1;
    await getAllRecordedLive(currentPage.value, limit.value);
  }

  // Load more for pagination
  Future<void> loadMore() async {
    if (!isLoading.value) {
      currentPage.value++;
      await getAllRecordedLive(currentPage.value, limit.value);
    }
  }

  @override
  void onClose() {
    commentController.dispose();
    super.onClose();
  }
}
