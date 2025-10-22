import 'package:get/get.dart';

import 'package:get/get.dart';

class Comment {
  final String id;
  final String userName;
  final String userImage;
  final String text;
  final String? imagePath;
  final String? emoji;
  final DateTime timestamp;
  final List<Comment> replies;
  final RxBool isLiked; // Changed to RxBool for reactivity

  Comment({
    required this.id,
    required this.userName,
    required this.userImage,
    required this.text,
    this.imagePath,
    this.emoji,
    required this.timestamp,
    this.replies = const [],
    bool isLiked = false,
  }) : isLiked = RxBool(isLiked); // Initialize RxBool in initializer list

  // Optional: Add a convenience method to toggle like
  void toggleLike() {
    isLiked.value = !isLiked.value;
  }
}

// Vote Detail Model
class VoteDetail {
  final String userName;
  final String userImage;
  final int selectedOptionIndex;
  final DateTime timestamp;
  final bool isVerified;

  VoteDetail({
    required this.userName,
    required this.userImage,
    required this.selectedOptionIndex,
    required this.timestamp,
    this.isVerified = false,
  });
}




