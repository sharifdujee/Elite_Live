import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../data/notification_data_model.dart';

class NotificationController extends GetxController {
  var notifications = <NotificationModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
  }

  void loadNotifications() {
    isLoading.value = true;

    // Sample data
    notifications.value = [
      NotificationModel(
        id: '1',
        userName: 'Floyd Miles',
        userImage: 'https://i.pravatar.cc/150?img=1',
        message: 'Started following you',
        timestamp: DateTime.now().subtract(const Duration(hours: 4)),
        isVerified: true,
      ),
      NotificationModel(
        id: '2',
        userName: 'Darrell Steward',
        userImage: 'https://i.pravatar.cc/150?img=2',
        message: 'Mentioned you in a comment',
        timestamp: DateTime.now().subtract(const Duration(hours: 6)),
        isVerified: true,
      ),
      NotificationModel(
        id: '3',
        userName: 'Kristin Watson',
        userImage: 'https://i.pravatar.cc/150?img=3',
        message: 'Started following you',
        timestamp: DateTime.now().subtract(const Duration(hours: 8)),
        isVerified: true,
      ),
      NotificationModel(
        id: '4',
        userName: 'Marvin McKinney',
        userImage: 'https://i.pravatar.cc/150?img=4',
        message: 'Mentioned you in...',
        timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
        isVerified: true,
      ),
      NotificationModel(
        id: '5',
        userName: 'Jenny Wilson',
        userImage: 'https://i.pravatar.cc/150?img=5',
        message: 'Started following you',
        timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 5)),
        isVerified: true,
      ),
      NotificationModel(
        id: '6',
        userName: 'Arlene McCoy',
        userImage: 'https://i.pravatar.cc/150?img=6',
        message: 'Mentioned you in a comment',
        timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 8)),
        isVerified: true,
      ),
      NotificationModel(
        id: '7',
        userName: 'Robert Fox',
        userImage: 'https://i.pravatar.cc/150?img=7',
        message: 'Started following you',
        timestamp: DateTime.now().subtract(const Duration(days: 3)),
        isVerified: true,
      ),
      NotificationModel(
        id: '8',
        userName: 'Wade Warren',
        userImage: 'https://i.pravatar.cc/150?img=8',
        message: 'Mentioned you in a comment',
        timestamp: DateTime.now().subtract(const Duration(days: 3, hours: 4)),
        isVerified: true,
      ),
    ];

    isLoading.value = false;
  }

  // Group notifications by date
  Map<String, List<NotificationModel>> get groupedNotifications {
    Map<String, List<NotificationModel>> grouped = {};

    for (var notification in notifications) {
      String dateKey = getDateHeader(notification.timestamp);
      if (!grouped.containsKey(dateKey)) {
        grouped[dateKey] = [];
      }
      grouped[dateKey]!.add(notification);
    }

    return grouped;
  }

  // Get date header (Today, Yesterday, or formatted date)
  String getDateHeader(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final notificationDate = DateTime(date.year, date.month, date.day);

    if (notificationDate == today) {
      return 'Today';
    } else if (notificationDate == yesterday) {
      return 'Yesterday';
    } else {
      return DateFormat('MMMM d, yyyy').format(date);
    }
  }

  // Get time ago text
  String getTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds}s';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d';
    } else {
      return DateFormat('MMM d').format(timestamp);
    }
  }

  void markAsRead(String notificationId) {
    int index = notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      notifications[index] = NotificationModel(
        id: notifications[index].id,
        userName: notifications[index].userName,
        userImage: notifications[index].userImage,
        message: notifications[index].message,
        timestamp: notifications[index].timestamp,
        isVerified: notifications[index].isVerified,
        isRead: true,
      );
      notifications.refresh();
    }
  }
}