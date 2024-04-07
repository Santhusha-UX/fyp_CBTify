// ignore_for_file: library_private_types_in_public_api

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:audioplayers/audioplayers.dart';

class MindfulnessScreen extends StatefulWidget {
  const MindfulnessScreen({super.key});

  @override
  _MindfulnessScreenState createState() => _MindfulnessScreenState();
}

class _MindfulnessScreenState extends State<MindfulnessScreen> {
  final AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    audioPlayer.onPlayerComplete.listen((event) {
      _showCongratulationsDialog2();
    });
  }

  void _showCongratulationsDialog2() {
    if (mounted) {
      // Check if the widget is still in the tree
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset('assets/animations/celebration.json', repeat: true),
              const SizedBox(height: 20),
              const Text("🥳 Well Done! 🥳",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              const Text(
                  "You're officially one step closer to mindfulness and peace. Keep it up!",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white30)),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Close the dialog
              child: const Text('OK',
                  style: TextStyle(color: Colors.deepPurpleAccent)),
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  Future<void> playAudio(String path) async {
    await audioPlayer.play(AssetSource(path));
  }

  Future<void> playAudio2(String path, bool play) async {
    if (play) {
      // Assuming audioPlayer is an instance of AudioPlayer
      await audioPlayer.play(AssetSource(path));
    } else {
      await audioPlayer.pause();
    }
  }

  void playAudio3(String path, bool play) async {
    if (play) {
      // Assuming audioPlayer is an instance of AudioPlayer
      await audioPlayer.play(AssetSource(path));
    } else {
      await audioPlayer.pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calm Your Mind"),
        backgroundColor: Colors.deepPurple,
        shadowColor: Colors.white54,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _buildMindfulBanner(context),
            Section(
              title: "Guided Meditations",
              description:
                  "Discover tranquility through our curated list of guided meditations, designed to help you find peace and calm.",
              iconData: Icons.self_improvement_rounded,
              child: MeditationList(playAudio: playAudio),
            ),
            const Section(
              title: "Breathing Exercises",
              description:
                  "Learn and practice breathing techniques to manage stress and improve your mental well-being.",
              iconData: Icons.air_rounded,
              child: BreathingExerciseList(),
            ),
            Section(
              title: "Sleep Therapy",
              description:
                  "Enhance your sleep quality with our soothing sleep therapy sessions, aiding in restful nights.",
              iconData: Icons.nights_stay_rounded,
              child: SleepTherapyList(playAudio: playAudio2),
            ),
            Section(
              title: "Positivity and Affirmations",
              description:
                  "Boost your mood and self-confidence with positive affirmations and uplifting messages.",
              iconData: Icons.favorite_rounded,
              child: PositivityAffirmations(playAudio: playAudio3),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildMindfulBanner(BuildContext context) {
  return Container(
    margin: const EdgeInsets.all(16),
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.deepPurpleAccent,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.deepPurple.shade200.withOpacity(0.6),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      children: [
        Lottie.asset('assets/animations/mindfulness.json',
            width: MediaQuery.of(context).size.width * 0.8, repeat: true),
        const Text(
          "Discover Mindfulness & Relaxation",
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          "Cultivate presence and peace through our guided mindfulness practices. Embrace the journey to a more mindful and serene life.",
          style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.9)),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}

class Section extends StatelessWidget {
  final String title;
  final String description;
  final Widget child;
  final IconData? iconData; // Optional icon data for section title

  const Section({
    super.key,
    required this.title,
    required this.description,
    required this.child,
    required this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.deepPurple[50]
            ?.withOpacity(0.1), // Light purple with some transparency
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            // color: Colors.black54,
            color: Color.fromARGB(255, 12, 11, 20),
            // blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (iconData != null) ...[
                Icon(iconData, color: Colors.white),
                const SizedBox(width: 8),
              ],
              Text(title,
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            ],
          ),
          const SizedBox(height: 8),
          Text(description,
              style: const TextStyle(fontSize: 14, color: Colors.white38)),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

// Example MeditationList with expanded design
class MeditationList extends StatelessWidget {
  final Function(String) playAudio;

  MeditationList({super.key, required this.playAudio});

  final List<Map<String, dynamic>> meditations = [
    {
      "title": "Ambient Relaxation",
      "description": "A soothing journey along a serene beach.",
      "duration": "10 min",
      "audioPath": "audio/beach.mp3",
      "imagePath": "assets/images/beach.jpg",
    },
    {
      "title": "Mountain Relaxation",
      "description": "A mindful meditation to relax in the high altitudes.",
      "duration": "10 min",
      "audioPath": "audio/mountain.mp3",
      "imagePath": "assets/images/mountain.jpg",
    },
    {
      "title": "Discarding Worries",
      "description":
          "A visualisation exercise to help you discard the worries.",
      "duration": "15 min",
      "audioPath": "audio/worry.mp3",
      "imagePath": "assets/images/worry.jpg",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: meditations.map((meditation) {
        return MeditationCard(
          title: meditation["title"],
          description: meditation["description"],
          duration: meditation["duration"],
          audioPath: meditation["audioPath"],
          imagePath: meditation["imagePath"],
          playAudio: playAudio,
        );
      }).toList(),
    );
  }
}

class MeditationCard extends StatefulWidget {
  final String title;
  final String description;
  final String duration;
  final String audioPath;
  final String imagePath;
  final Function(String) playAudio;

  const MeditationCard({
    super.key,
    required this.title,
    required this.description,
    required this.duration,
    required this.audioPath,
    required this.imagePath,
    required this.playAudio,
  });

  @override
  State<MeditationCard> createState() => _MeditationCardState();
}

class _MeditationCardState extends State<MeditationCard> {
  final AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        // Check if the widget is still in the widget tree
        setState(() {
          isPlaying = state == PlayerState.playing;
        });
      }
    });
  }

  @override
  void dispose() {
    audioPlayer.dispose(); // Dispose the audio player
    super.dispose();
  }

  void toggleAudio() async {
    if (isPlaying) {
      await audioPlayer.pause();
    } else {
      await audioPlayer.play(AssetSource(widget.audioPath));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: const EdgeInsets.fromLTRB(0, 8, 0, 8),
      child: InkWell(
        onTap: toggleAudio,
        borderRadius: BorderRadius.circular(10.0),
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(4.0),
                  child: Image.asset(
                    widget.imagePath,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.description,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.duration,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.deepPurpleAccent,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                      isPlaying
                          ? Icons.pause_circle_filled
                          : Icons.play_circle_fill,
                      color: Colors.deepPurpleAccent),
                  onPressed: toggleAudio,
                ),
              ],
            )),
      ),
    );
  }
}

// BreathingExerciseList Component
class BreathingExerciseList extends StatelessWidget {
  const BreathingExerciseList({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        BreathingExerciseCard(
          title: "Box Breathing",
          description:
              "A powerful stress reliever. Inhale, hold, exhale, and hold again, each for 4 seconds.",
          animationPath: "assets/animations/box_breathing.json",
        ),
        BreathingExerciseCard(
          title: "4-7-8 Breathing",
          description:
              "Boosts concentration levels. Inhale for 4 seconds, hold for 7, exhale for 8.",
          animationPath: "assets/animations/478_breathing.json",
        ),
        // Add more breathing exercises here
      ],
    );
  }
}

class BreathingExerciseCard extends StatelessWidget {
  final String title;
  final String description;
  final String animationPath;

  const BreathingExerciseCard({
    super.key,
    required this.title,
    required this.description,
    required this.animationPath,
  });

  void _startExercise(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(animationPath, repeat: true, height: 200),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white30),
            ),
            const SizedBox(height: 20),
            const CountdownTimer(), // Assuming CountdownTimer is a widget that handles the countdown logic
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(), // Close the dialog
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 4,
        margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Lottie.asset(animationPath, height: 180),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                child: Column(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(description,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white30,
                          fontSize: 14,
                        )),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => _startExercise(context),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.deepPurpleAccent,
                      ),
                      child: const FittedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text('Start Exercise'),
                            SizedBox(
                                width: 6), // This creates a gap of 10 pixels
                            Icon(Icons
                                .play_arrow_rounded) // This is the arrow icon
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}

class CountdownTimer extends StatefulWidget {
  const CountdownTimer({super.key});

  @override
  _CountdownTimerState createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  Duration duration = const Duration(minutes: 5);
  Timer? _timer; // Keep a reference to the timer

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (duration.inSeconds == 0) {
        timer.cancel();
        _showCongratulationsDialog();
      } else if (mounted) {
        // Check if the widget is still in the tree
        setState(() {
          duration -= const Duration(seconds: 1);
        });
      }
    });
  }

  void _showCongratulationsDialog() {
    if (mounted) {
      // Check if the widget is still in the tree
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset('assets/animations/achievement_unlocked.json',
                  repeat: false),
              const Text("🎉 Congratulations! 🎉",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              const Text(
                  "You've completed the breathing exercise. Keep up the good work",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white30)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the congratulations dialog
                Navigator.of(context).pop(); // Close the exercise dialog
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      "${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}",
      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    );
  }
}

// // SleepTherapyList Component
class SleepTherapyList extends StatelessWidget {
  final Function(String, bool) playAudio;

  SleepTherapyList({super.key, required this.playAudio});

  final List<Map<String, dynamic>> therapies = [
    {
      "title": "Dispelling Anxiety Before Sleep",
      "description": "Soothing breathing exercise to help you fall asleep.",
      "duration": "30 min",
      "audioPath": "audio/gentle_sleep1.mp3",
      "imagePath": "assets/images/soothing_breathing.jpg",
    },
    {
      "title": "The Hidden Garden: Guided Sleep Story",
      "description":
          "Explore the hidden garden and return home to a restful sleep.",
      "duration": "30 min",
      "audioPath": "audio/gentle_sleep2.mp3",
      "imagePath": "assets/images/hidden_garden.jpg",
    },
    {
      "title": "Deep Sleep Induction",
      "description":
          "A deep sleep induction designed purely to induce deep relaxation and sleep",
      "duration": "20 min",
      "audioPath": "audio/gentle_sleep3.mp3",
      "imagePath": "assets/images/deep_sleep.jpg",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: therapies.length,
      itemBuilder: (context, index) {
        final therapy = therapies[index];
        return TherapyCard2(
          title: therapy["title"],
          description: therapy["description"],
          duration: therapy["duration"],
          audioPath: therapy["audioPath"],
          imagePath: therapy["imagePath"],
          togglePlay: playAudio,
        );
      },
    );
  }
}

class TherapyCard2 extends StatefulWidget {
  final String title, description, duration, audioPath, imagePath;
  final Function(String, bool) togglePlay;

  const TherapyCard2({
    super.key,
    required this.title,
    required this.description,
    required this.duration,
    required this.audioPath,
    required this.imagePath,
    required this.togglePlay,
  });

  @override
  _TherapyCard2State createState() => _TherapyCard2State();
}

class _TherapyCard2State extends State<TherapyCard2> {
  bool isPlaying = false;

  void toggleAudio() {
    setState(() {
      isPlaying = !isPlaying;
    });
    widget.togglePlay(widget.audioPath, isPlaying);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: const EdgeInsets.fromLTRB(0, 8, 0, 8),
      child: InkWell(
        onTap: toggleAudio,
        borderRadius: BorderRadius.circular(4.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset(
                  widget.imagePath,
                  width: 100,
                  height: 110,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.description,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.duration,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.deepPurpleAccent,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                    isPlaying
                        ? Icons.pause_circle_filled
                        : Icons.play_circle_fill,
                    color: Colors.deepPurpleAccent),
                onPressed: toggleAudio,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PositivityAffirmations extends StatelessWidget {
  // final Function(String, bool) togglePlay;
  final Function(String, bool) playAudio;

  PositivityAffirmations({super.key, required this.playAudio});

  final List<Map<String, dynamic>> affirmations = [
    {
      "title": "Morning Positivity",
      "description": "Start your day with positive affirmations.",
      "duration": "5 min",
      "audioPath": "audio/morning_positivity.mp3",
      "imagePath": "assets/images/morning_positivity.jpg"
    },
    {
      "title": "Confidence Boost",
      "description": "Boost your confidence with these powerful affirmations.",
      "duration": "3 min",
      "audioPath": "audio/confidence_boost.mp3",
      "imagePath": "assets/images/confidence.jpg"
    },
    {
      "title": "Positive Life",
      "description": "Daily exercise you can do to help uplift your spirit.",
      "duration": "5 min",
      "audioPath": "audio/positive.mp3",
      "imagePath": "assets/images/positive.jpg"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: affirmations.map((affirmation) {
        return AffirmationCard(
          title: affirmation["title"],
          description: affirmation["description"],
          duration: affirmation["duration"],
          audioPath: affirmation["audioPath"],
          imagePath: affirmation["imagePath"],
          togglePlay: playAudio,
        );
      }).toList(),
    );
  }
}

// Helper Widgets
class TherapyCard extends StatelessWidget {
  final String title;
  final String description;
  final String duration;
  final VoidCallback playAudio;

  const TherapyCard(
      {super.key,
      required this.title,
      required this.description,
      required this.duration,
      required this.playAudio});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(8),
      child: ListTile(
        title: Text(title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        subtitle: Text("$description\nDuration: $duration"),
        trailing: IconButton(
          icon: const Icon(Icons.play_circle_fill,
              color: Colors.deepPurpleAccent),
          onPressed: playAudio,
        ),
      ),
    );
  }
}

class AffirmationCard extends StatefulWidget {
  final String title, description, duration, audioPath, imagePath;
  final Function(String, bool) togglePlay;

  const AffirmationCard({
    super.key,
    required this.title,
    required this.description,
    required this.duration,
    required this.audioPath,
    required this.imagePath,
    required this.togglePlay,
  });

  @override
  _AffirmationCardState createState() => _AffirmationCardState();
}

class _AffirmationCardState extends State<AffirmationCard> {
  bool isPlaying = false;

  void toggleAudio() {
    setState(() {
      isPlaying = !isPlaying;
    });
    widget.togglePlay(widget.audioPath, isPlaying);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: const EdgeInsets.fromLTRB(0, 8, 0, 8),
      child: InkWell(
        onTap: toggleAudio,
        borderRadius: BorderRadius.circular(4.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset(
                  widget.imagePath,
                  width: 100,
                  height: 110,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.description,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.duration,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.deepPurpleAccent,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                    isPlaying
                        ? Icons.pause_circle_filled
                        : Icons.play_circle_fill,
                    color: Colors.deepPurpleAccent),
                onPressed: toggleAudio,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// You would follow a similar approach for BreathingExerciseList, SleepTherapyList, and PositivityAffirmations components,
// providing a detailed description, using relevant icons or images, and ensuring that each card or list item is interactive and informative.

// This code structure aims to provide a skeleton for your app's MindfulnessScreen. Depending on your specific requirements,
// you may need to add more properties to each component, adjust the layout, styles, or add more functionality like downloading or streaming audio.
