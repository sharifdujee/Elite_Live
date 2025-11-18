import 'dart:io';

import 'package:elites_live/core/utils/constants/image_path.dart';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../data/comment_data_model.dart';

class HomeController extends GetxController {
  var searchText = ''.obs;
  var selectedTab = 0.obs;
  var commentText = ''.obs;
  var selectedDonationAmount = 0.0.obs;
  List<String> liveDescription = [
    "Tell me what excites you and makes you smile. Only good conversations—no bad texters!...",
    "Tell me what excites you and makes you smile. Only good conversations—no bad texters!...",
    "Tell me what excites you and makes you smile. Only good conversations—no bad texters!...",
    "Tell me what excites you and makes you smile. Only good conversations—no bad texters!...",
    "Tell me what excites you and makes you smile. Only good conversations—no bad texters!...",
  ];
  List<String> influencerName = [
    "Ethan Walker",
    "Ronald Richards",
    "Marvin",
    "Jerome Bell",
    "Marvin",
  ];
  List<String> influencerProfile = [
    ImagePath.two,
    ImagePath.one,
    ImagePath.user,
    ImagePath.three,
    ImagePath.one
  ];
  List<bool> isLive = [true, false, true, true, true];
 /// List<bool> eventLive = [false, false, false, false, false, true];
  List<bool> isFollow = [true, false, true, true, true, false, true];
  var commentImage = Rx<File?>(null); // Selected image
  var isEmojiVisible = false.obs;
  final commentController = TextEditingController();
  var comments = <Comment>[].obs;

  // Tab control
  void onTabSelected(int index) => selectedTab.value = index;

  void onSearchChanged(String value) => searchText.value = value;

  void processDonation(double amount) {
    selectedDonationAmount.value = amount;
    // Add your donation processing logic here
    Get.snackbar(
      'Donation',
      'Processing donation of \$${amount.toStringAsFixed(2)}',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

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

  // Comment submission




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
}
