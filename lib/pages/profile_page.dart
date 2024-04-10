import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class User {
  String username;
  String email;
  String avatarUrl;

  User({required this.username, required this.email, required this.avatarUrl});
}

class Achievement {
  final String title;
  final String description;
  final String lottieAsset;
  final bool unlocked;

  Achievement({
    required this.title,
    required this.description,
    required this.lottieAsset,
    this.unlocked = false,
  });
}

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  User currentUser = User(
    username: 'John Doe',
    email: 'john@example.com',
    avatarUrl: 'assets/animations/default_avatar.json', // Default avatar
  );

  // Define avatars with locked status
  final List<Map<String, dynamic>> avatars = [
    {'path': 'assets/animations/avatar1.json', 'locked': false},
    {'path': 'assets/animations/avatar2.json', 'locked': false},
    {'path': 'assets/animations/avatar3.json', 'locked': false},
    {'path': 'assets/animations/avatar4.json', 'locked': false},
    {'path': 'assets/animations/avatar5.json', 'locked': true},
    {'path': 'assets/animations/avatar6.json', 'locked': true},
    {'path': 'assets/animations/avatar7.json', 'locked': true},
    {'path': 'assets/animations/avatar8.json', 'locked': true},
  ];

  final List<Achievement> achievements = [
    Achievement(
      title: "First Step",
      description: "Congratulations on starting your wellness journey with us!",
      lottieAsset: "assets/animations/badge3.json",
      unlocked: true,
    ),
    Achievement(
      title: "Consistency",
      description: "Logged in and engaged with the app daily for a week. Keep up the good work!",
      lottieAsset: "assets/animations/badge4.json",
      unlocked: true,
    ),
    Achievement(
      title: "Goal Getter",
      description: "Achieved your first major goal. Your dedication is inspiring!",
      lottieAsset: "assets/animations/badge4.json",
      unlocked: false,
    ),
    Achievement(
      title: "Thought Shifter",
      description: "Successfully reframed 10 negative thoughts into positive ones. Your mindset is changing!",
      lottieAsset: "assets/animations/badge4.json",
      unlocked: false,
    ),
    Achievement(
      title: "Mindfulness Master",
      description: "Completed 30 days of mindfulness practice. Your presence is powerful!",
      lottieAsset: "assets/animations/badge4.json",
      unlocked: true,
    ),
    Achievement(
      title: "Resilience",
      description: "Bounced back from a setback with grace and strength. Nothing can keep you down!",
      lottieAsset: "assets/animations/badge4.json",
      unlocked: false,
    ),
    Achievement(
      title: "CBT Champion",
      description: "Mastered 5 different Cognitive Behavioral Therapy techniques. Your mental toolbox is expanding!",
      lottieAsset: "assets/animations/badge4.json",
      unlocked: false,
    ),
    Achievement(
      title: "Wellness Warrior",
      description: "Engaged with every aspect of the app to improve your wellness. You're a true warrior!",
      lottieAsset: "assets/animations/badge4.json",
      unlocked: false,
    ),
    Achievement(
      title: "Zen Master",
      description: "Achieved a state of calm and mindfulness that many strive for. Your inner peace is your strength.",
      lottieAsset: "assets/animations/badge4.json",
      unlocked: false,
    ),
  ];

  void _showAchievementDialog(Achievement achievement) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(achievement.title),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Lottie.asset(achievement.lottieAsset, repeat: false, frameRate: FrameRate.max),
              SizedBox(height: 16),
              Text(achievement.description,
              textAlign: TextAlign.center,),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Close'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  double currentProgress = 0.75;

  void _changeAvatar(String avatarPath) {
    setState(() {
      currentUser.avatarUrl = avatarPath;
    });
  }

  void _showAvatarSelectionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Avatar'),
        content: Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          runSpacing: 8,
          children: avatars.map((avatar) {
            return GestureDetector(
              onTap: () {
                if (!avatar['locked']) {
                  _changeAvatar(avatar['path']);
                  Navigator.pop(context);
                }
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Lottie.asset(avatar['path'], width: 80, height: 80),
                  if (avatar['locked'])
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                      ),
                      child: const Icon(Icons.lock, color: Colors.white, size: 24),
                    ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildUserInfo(),
            const SizedBox(height: 20),
            Divider(color: Colors.deepPurple.withOpacity(0.5)),
            const SizedBox(height: 20),
            _buildAchievementGallery(achievements),
            const SizedBox(height: 20),
            Divider(color: Colors.deepPurple.withOpacity(0.5)),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfo() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            GestureDetector(
              onLongPress: () {
                setState(() {
                  currentUser.avatarUrl = 'assets/animations/default_avatar.json';
                });
              },
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey[200],
                child: ClipOval(
                  child: Lottie.asset(currentUser.avatarUrl, width: 120, height: 120),
                ),
              ),
            ),
            GestureDetector(
              onTap: _showAvatarSelectionDialog,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.deepPurpleAccent,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.edit, color: Colors.white, size: 24),
                padding: const EdgeInsets.all(8),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(currentUser.username, style: Theme.of(context).textTheme.headline5),
        Text(currentUser.email, style: Theme.of(context).textTheme.subtitle1),
      ],
    );
  }

  Widget _buildAchievementGallery(List<Achievement> achievements) {
    int unlockedCount = achievements.where((achievement) => achievement.unlocked).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8), 
          child: Text('Achievements ($unlockedCount/${achievements.length})', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8), 
          child: Text("Each achievement marks a step forward in mastering your wellness and mental health. Unlock them by engaging with daily tasks, challenges, and personal growth activities.",
          style: TextStyle(color: Colors.white38, fontSize: 14, fontStyle: FontStyle.italic),
          ),
        ),
        const SizedBox(height: 16),
        Align(
          alignment: Alignment.center,
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: achievements.map((achievement) => GestureDetector(
              onTap: () => _showAchievementDialog(achievement),
              child: Card(
                elevation: 4,
                child: SizedBox(
                  width: 110,
                  height: 150,
                  child: Stack(
                    children: [
                      Lottie.asset(achievement.lottieAsset, repeat: true),
                      if (!achievement.unlocked) _lockedOverlay(),
                      Positioned(
                        bottom: 8,
                        left: 0,
                        right: 0,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8), // Apply padding horizontally or vertically only
                          child: Text(
                            achievement.title,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )).toList(),
          ),
        ),
      ],
    );
  }

  Widget _lockedOverlay() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.center,
      child: const Icon(Icons.lock, color: Colors.white, size: 24),
    );
  }
}
