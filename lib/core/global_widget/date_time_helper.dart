import 'package:intl/intl.dart';


class DateTimeHelper {
  /// Format schedule date to display date (25-08-2025) and time (11:00 AM)
  static Map<String, String> formatScheduleDateTime(String dateString) {
    try {
      final dateTime = DateTime.parse(dateString);

      final dateFormat = DateFormat('dd-MM-yyyy');
      final timeFormat = DateFormat('hh:mm a');

      return {
        'date': dateFormat.format(dateTime),
        'time': timeFormat.format(dateTime),
      };
    } catch (e) {
      return {'date': 'Invalid Date', 'time': 'Invalid Time'};
    }
  }

  /// Calculate time ago from createdAt timestamp
  static String getTimeAgo(String createdAtString) {
    try {
      final createdAt = DateTime.parse(createdAtString);
      final now = DateTime.now();
      final difference = now.difference(createdAt);

      if (difference.inSeconds < 60) {
        return 'Just now';
      } else if (difference.inMinutes < 60) {
        final minutes = difference.inMinutes;
        return '$minutes ${minutes == 1 ? "minute" : "minutes"} ago';
      } else if (difference.inHours < 24) {
        final hours = difference.inHours;
        return '$hours ${hours == 1 ? "hour" : "hours"} ago';
      } else if (difference.inHours < 48) {
        return 'Yesterday';
      } else {
        final dateFormat = DateFormat('dd-MM-yyyy');
        return dateFormat.format(createdAt);
      }
    } catch (e) {
      return 'Unknown';
    }
  }
}