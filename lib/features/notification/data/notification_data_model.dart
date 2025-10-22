

class NotificationModel {
  final String id;
  final String userName;
  final String userImage;
  final String message;
  final DateTime timestamp;
  final bool isVerified;
  final bool isRead;

  NotificationModel({
    required this.id,
    required this.userName,
    required this.userImage,
    required this.message,
    required this.timestamp,
    this.isVerified = false,
    this.isRead = false,
  });
}