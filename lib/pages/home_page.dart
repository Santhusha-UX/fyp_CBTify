import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'action_planner.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../utils/notification_manager.dart';
import 'package:intl/intl.dart';
import 'mood_tracker_page.dart';
import 'resource_page.dart';
import 'mindfulness_page.dart';
import 'thought_challenge_page.dart';

class NotificationCard extends StatelessWidget {
  final NotificationItem notification;
  final VoidCallback onRead;

  const NotificationCard({
    super.key,
    required this.notification,
    required this.onRead,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text(notification.title),
            content: Text(notification.message),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  onRead(); // Mark as read and dismiss dialog
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: notification.isRead ? Colors.grey.shade200 : Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor:
                  notification.isRead ? Colors.grey[400] : Colors.deepPurple,
              child: Icon(
                  notification.isRead
                      ? Icons.notifications_off
                      : Icons.notifications,
                  color: Colors.white),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: notification.isRead
                          ? Colors.grey[700]
                          : Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.message,
                    style: TextStyle(
                      color: Colors.grey[600],
                      overflow: TextOverflow.ellipsis,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Text(
              timeAgo(notification.timestamp),
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  String timeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat.yMMMd().format(
          date); // Ensure 'package:intl/intl.dart' is imported for DateFormat
    }
  }
}

class NotificationIcon extends StatelessWidget {
  const NotificationIcon({super.key});

  @override
  Widget build(BuildContext context) {
    // Accessing NotificationManager from the provider
    final notificationManager = Provider.of<NotificationManager>(context);

    return Stack(
      alignment: Alignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 2),
          child: IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () => showNotificationList(context, notificationManager),
          ),
        ),
        // Animated Visibility of the notification count bubble
        if (notificationManager.unreadCount > 0)
          Positioned(
            right: 2,
            top: 8,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1),
              ),
              constraints: const BoxConstraints(
                minWidth: 14,
                minHeight: 14,
              ),
              child: Text(
                '${notificationManager.unreadCount}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }

  void showNotificationList(
      BuildContext context, NotificationManager notificationManager) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Notifications'),
          content: SingleChildScrollView(
            child: ListBody(
              children: notificationManager.getNotifications().isEmpty
                  ? [const Text("You're all caught up! 🎉")]
                  : notificationManager.getNotifications().map((notification) {
                      int index = notificationManager
                          .getNotifications()
                          .indexOf(notification);
                      return NotificationCard(
                        notification: notification,
                        onRead: () {
                          notificationManager.markNotificationAsRead(index);
                          Navigator.of(dialogContext)
                              .pop(); // Optionally close on tap
                        },
                      );
                    }).toList(),
            ),
          ),
          actions: <Widget>[
            if (notificationManager.hasUnreadNotifications)
              TextButton(
                child: const Text('Mark all as read'),
                onPressed: () {
                  notificationManager.markAllAsRead();
                  Navigator.of(dialogContext).pop();
                },
              ),
            TextButton(
              child: Text(notificationManager.getNotifications().isEmpty
                  ? 'OK'
                  : 'Clear All'),
              onPressed: () {
                notificationManager.clearNotifications();
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class MoodTrackerBanner extends StatelessWidget {
  final VoidCallback onTap;

  const MoodTrackerBanner({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 20, 16, 20),
        padding: const EdgeInsets.fromLTRB(8, 16, 16, 16),
        decoration: BoxDecoration(
          color: Colors.deepPurpleAccent,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.white30,
              blurRadius: 20,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Lottie.asset(
              'assets/animations/mood_tracker.json', // An animation that suggests calmness and introspection
              width: 100,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Padding(
                  padding: EdgeInsets.only(right: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Track Your Mood',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Understand your emotions and engage to unlock insights.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  )),
            ),
            const Icon(Icons.arrow_forward_ios_rounded,
                color: Colors.white70, size: 28),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> inspirationalQuotes = [
    "The only way to do great work is to love what you do.",
    "Believe you can and you're halfway there.",
    "It does not matter how slowly you go as long as you do not stop.",
    // Add more quotes as needed
  ];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance
        .addPostFrameCallback((_) => scheduleNotifications());
  }

  void scheduleNotifications() {
    final notificationManager =
        Provider.of<NotificationManager>(context, listen: false);

    // Immediate notification
    notificationManager.addNotification(
      NotificationItem(
        title: "Welcome to CBTify",
        message: "Discover features designed to enhance your well-being.",
        timestamp: DateTime.now(),
      ),
    );

    // After 10 seconds: Daily Mood Reminder
    Future.delayed(const Duration(seconds: 25), () {
      notificationManager.addNotification(
        NotificationItem(
          title: "Daily Mood Check-In",
          message: "How are you feeling today? Tap to record your mood.",
          timestamp: DateTime.now(),
        ),
      );
    });

    // After 5 minutes: Wellness Tip
    Future.delayed(const Duration(minutes: 5), () {
      notificationManager.addNotification(
        NotificationItem(
          title: "Wellness Tip",
          message:
              "Try a 5-minute breathing exercise to relax and reduce stress.",
          timestamp: DateTime.now(),
        ),
      );
    });

    // After 15 minutes: Hydration Reminder
    Future.delayed(const Duration(minutes: 15), () {
      notificationManager.addNotification(
        NotificationItem(
          title: "Hydration Reminder",
          message: "Don't forget to stay hydrated. Have a glass of water.",
          timestamp: DateTime.now(),
        ),
      );
    });

    // After 1 hour: Activity Suggestion
    Future.delayed(const Duration(hours: 1), () {
      notificationManager.addNotification(
        NotificationItem(
          title: "Activity Suggestion",
          message:
              "Taking a short walk can help clear your mind and boost creativity.",
          timestamp: DateTime.now(),
        ),
      );
    });

    // After 2 hours: Learning Resource
    Future.delayed(const Duration(hours: 2), () {
      notificationManager.addNotification(
        NotificationItem(
          title: "Explore Resources",
          message:
              "Learn more about mindfulness and its benefits for mental health.",
          timestamp: DateTime.now(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Placeholder navigation functions
    void navigateToMoodTracker() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MoodTrackerScreen()),
      );
    }

    void navigateToThoughtChallenge() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ThoughtChallengeScreen()),
      );
    }
    
    void navigateToBehavioralActivation() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ActionPlanner()),
      );
    }

    void navigateToMindfulnessRelaxation() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MindfulnessScreen()),
      );
    }

    void navigateToResources() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ResourcesScreen()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('CBTify'),
        backgroundColor: Colors.deepPurple,
        shadowColor: Colors.white54,
        actions: const [
          NotificationIcon(),
        ],
      ),
      body: Column(
        children: [
          MoodTrackerBanner(
            onTap: navigateToMoodTracker,
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio:
                    MediaQuery.of(context).size.width > 600 ? 1 / 1.1 : 0.8,
              ),
              itemCount: 4,
              itemBuilder: (context, index) {
                List<Widget> cards = [
                  FeatureCard(
                    icon: Icons.lightbulb_outline,
                    title: 'Thought Shift',
                    description: 'Transform thoughts, foster positivity.',
                    onTap: navigateToThoughtChallenge,
                  ),
                  FeatureCard(
                    icon: Icons.checklist_rtl,
                    title: 'Action Planner',
                    description: 'Track progress, achieve well-being.',
                    onTap: navigateToBehavioralActivation,
                  ),
                  FeatureCard(
                    icon: Icons.self_improvement,
                    title: 'Calm Your Mind',
                    description: 'Practices for peace and clarity.',
                    onTap: navigateToMindfulnessRelaxation,
                  ),
                  FeatureCard(
                    icon: Icons.library_books,
                    title: 'Learn and Grow',
                    description: 'Guides on mental health and growth.',
                    onTap: navigateToResources,
                  ),
                ];

                return cards[index];
              },
            ),
          ),
        ],
      ),
    );
  }
}

class FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  const FeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.deepPurple.shade100, Colors.white],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.deepPurple.shade300,
                  radius: 25,
                  child: Icon(icon, size: 30, color: Colors.white),
                ),
                const SizedBox(height: 10),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple.shade800,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 5),
                AutoSizeText(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                  textAlign: TextAlign.center,
                  minFontSize: 12,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
