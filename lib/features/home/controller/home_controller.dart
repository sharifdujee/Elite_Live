import 'dart:developer';
import 'dart:io';
import 'package:elites_live/core/utils/constants/image_path.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/services/payment_service.dart';
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
    "https://t4.ftcdn.net/jpg/03/83/25/83/360_F_383258331_D8imaEMl8Q3lf7EKU2Pi78Cn0R7KkW9o.jpg",
    "https://www.wilsoncenter.org/sites/default/files/media/images/person/james-person-1.jpg",
    "https://www.fluentu.com/blog/wp-content/uploads/site//4/african-american-young-mom-with-curly-hair-in-stylish-outfit-feeling-grateful-and-happy-receiving-surprise-gift-from-kid-holding-palms-on-heart-smiling.jpg",
    "https://www.viewbug.com/media/mediafiles/2017/11/16/76191533_large.jpg",
    "https://www.newdirectionsforwomen.org/wp-content/uploads/2021/02/Woman-smiling-sunlight.jpg"
  ];

  List<bool> isLive = [true, false, true, true, true];
  List<bool> isFollow = [true, false, true, true, true, false, true];

  var commentImage = Rx<File?>(null);
  var isEmojiVisible = false.obs;
  final commentController = TextEditingController();
  var comments = <Comment>[].obs;

  // Tab control
  void onTabSelected(int index) => selectedTab.value = index;

  void onSearchChanged(String value) => searchText.value = value;

  /// FIXED: Now actually calls Stripe payment service
  Future<void> processDonation(double amount) async {
    selectedDonationAmount.value = amount;

    // Get the current post ID (you need to pass this from your UI)
    // For now, using a dummy postId - replace with actual post ID
    String postId = getCurrentPostId();

    try {
      // Call Stripe payment service
      await StripeService.instance.paymentStart(postId, amount);
    } catch (e) {
      // Error is already handled in StripeService
      log('Error processing donation: $e');
    }
  }

  /// Get the current post/stream ID
  /// Replace this with your actual logic to get the post ID
  String getCurrentPostId() {
    // TODO: Get actual post ID from current stream/video
    // This could come from navigation arguments, selected item, etc.
    return "post_123"; // Placeholder - replace with real post ID
  }

  /// Refresh posts after successful payment
  Future<void> getAllPost() async {
    // TODO: Implement your logic to refresh the posts list
    log('Refreshing posts after payment...');
    // Example:
    // await fetchPosts();
    // posts.refresh();
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

  @override
  void onClose() {
    commentController.dispose();
    super.onClose();
  }
}
