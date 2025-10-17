
class Comment {
  final String id;
  final String userName;
  final String userImage;
  final String text;
  final String? imagePath;
  final String? emoji;
  final DateTime timestamp;
  final List<Comment> replies;
  bool isLiked;

  Comment({
    required this.id,
    required this.userName,
    required this.userImage,
    required this.text,
    this.imagePath,
    this.emoji,
    required this.timestamp,
    this.replies = const [],
    this.isLiked = false,
  });
}
