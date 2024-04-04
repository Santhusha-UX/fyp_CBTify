import 'package:overlay_support/overlay_support.dart';
import 'package:flutter/material.dart';

class NotificationItem {
  String title;
  String message;
  DateTime timestamp;
  bool isRead;

  NotificationItem({
    required this.title,
    required this.message,
    DateTime? timestamp,
    this.isRead = false,
  }) : timestamp = timestamp ?? DateTime.now();
}


class NotificationManager with ChangeNotifier {
  final List<NotificationItem> _notifications = [];

  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  void addNotification(NotificationItem notification) {
    _notifications.insert(0, notification);
    // Automatically show a banner notification when a new notification is added
    showBannerNotification(notification);
    notifyListeners();
  }

  List<NotificationItem> getNotifications() => List.unmodifiable(_notifications);

  void clearNotifications() {
    _notifications.clear();
    notifyListeners();
  }

  void markNotificationAsRead(int index) {
    if (_notifications.isNotEmpty) {
      _notifications[index].isRead = true;
      notifyListeners();
    }
  }

  void markAllAsRead() {
    for (var notification in _notifications) {
      notification.isRead = true;
    }
    notifyListeners();
  }

  void markAsRead(int index) {
    if (index < _notifications.length) {
      _notifications[index].isRead = true;
      notifyListeners();
    }
  }

  void removeNotification(int index) {
    if (index < _notifications.length) {
      _notifications.removeAt(index);
      notifyListeners();
    }
  }

  bool get hasUnreadNotifications => _notifications.any((n) => !n.isRead);

  void showBannerNotification(NotificationItem notification) {
    showOverlayNotification((context) {
      return Container(
        margin: const EdgeInsets.fromLTRB(12, 8, 12, 8), // Adjusted for a bit more space around the banner
        decoration: BoxDecoration(
          color: Colors.grey[850], // Slightly lighter than black for contrast with the shadow
          borderRadius: BorderRadius.circular(12), // Softened the corners for a more modern look
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5), // Intensified for better depth perception
              blurRadius: 10, // Slightly increased blur for a smoother shadow
              offset: const Offset(0, 4), // Adjusted to make the shadow more pronounced
            ),
          ],
        ),
        child: SafeArea(
          child: Material(
            color: Colors.transparent,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20), // More breathing room
              leading: CircleAvatar(
                backgroundColor: Colors.deepPurple[700],
                radius: 22, // A deeper shade for a richer appearance
                child: Icon(notification.isRead ? Icons.notifications_off : Icons.notifications, color: Colors.white), // Slightly reduced to balance with increased padding
              ),
              title: Text(
                notification.title,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16), // Slightly larger text for better readability
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 6), // Adjusted for better vertical rhythm
                child: Text(
                  notification.message,
                  style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 14), // Made text slightly more opaque for readability
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.close, color: Colors.white54), // Lightened the close icon for visual hierarchy
                onPressed: () {
                  OverlaySupportEntry.of(context)?.dismiss();
                },
              ),
              onTap: () {
                // Consider implementing a detailed view or marking as read
                OverlaySupportEntry.of(context)?.dismiss();
              },
            ),
          ),
        ),
      );
    }, duration: const Duration(seconds: 5)); // Consider adjusting duration based on user feedback
  }
}

