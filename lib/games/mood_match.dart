import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class MoodMatch extends StatefulWidget {
  const MoodMatch({super.key});

  @override
  State<MoodMatch> createState() => _MoodMatchState();
}

class _MoodMatchState extends State<MoodMatch> {
  List<Map<String, dynamic>> scenarios;
  int currentScenarioIndex = 0;
  int score = 0;
  String feedbackMessage = "";
  bool showFeedback = false;
  int correctStreak = 0;
  int lives = 3;

  _MoodMatchState() : scenarios = [];
  @override
  void initState() {
    super.initState();
    scenarios = [
      {
        "text": "A sunny day in the park",
        "emoji": "😊",
        "options": ["😊", "😢", "😮", "😌"],
        "feedback":
            "Feeling happy in pleasant settings is common. It's a reminder of the simple joys in life and the importance of gratitude."
      },
      {
        "text": "Losing a valuable item",
        "emoji": "😢",
        "options": ["😠", "😢", "😌", "😮"],
        "feedback":
            "Sadness from loss is natural. Recognizing these feelings allows us to process them and eventually find closure."
      },
      {
        "text": "Getting a surprise gift",
        "emoji": "😮",
        "options": ["😮", "😢", "😊", "😠"],
        "feedback":
            "Surprise gifts can evoke joy and appreciation, highlighting the value of unexpected positive events."
      },
      {
        "text": "Finishing a challenging task",
        "emoji": "😌",
        "options": ["😌", "😠", "😮", "😊"],
        "feedback":
            "Completing difficult tasks can be relieving, boosting our confidence and sense of accomplishment."
      },
      {
        "text": "Facing a tight deadline at work",
        "emoji": "😰",
        "options": ["😊", "😢", "😰", "😌"],
        "feedback":
            "Feeling anxious about deadlines is normal, but CBT techniques can help manage this stress by breaking tasks into smaller, manageable parts.",
      },
      {
        "text": "Having an argument with a friend",
        "emoji": "😡",
        "options": ["😡", "😮", "😢", "😌"],
        "feedback":
            "Anger is a natural response to conflict. Reflecting on the situation can help understand both perspectives and find a resolution.",
      },
      {
        "text": "Volunteering for a cause you care about",
        "emoji": "🥰",
        "options": ["😊", "🥰", "😌", "😮"],
        "feedback":
            "Doing something meaningful can fill you with love and satisfaction, reinforcing the value of altruistic behaviors.",
      },
      {
        "text": "Reflecting on a day well spent",
        "emoji": "🧘‍♂️",
        "options": ["😊", "🧘‍♂️", "😌", "😮"],
        "feedback":
            "Mindfulness and reflection can foster feelings of peace and contentment, enhancing our emotional well-being."
      },
      {
        "text": "Feeling overwhelmed by a busy week ahead",
        "emoji": "😣",
        "options": ["😣", "😊", "😡", "😌"],
        "feedback":
            "Feeling overwhelmed is common when facing a lot of tasks. Prioritizing tasks and breaking them into smaller steps can help manage this feeling.",
      },
      {
        "text": "Feeling overwhelmed with work and personal life",
        "emoji": "😖",
        "options": ["😊", "😖", "😌", "😢"],
        "feedback":
            "Feeling overwhelmed is often a sign we're taking on too much. Prioritizing tasks and setting boundaries can help manage these feelings."
      },
      {
        "text": "Receiving criticism from someone you respect",
        "emoji": "😞",
        "options": ["😡", "😞", "😌", "😮"],
        "feedback":
            "Criticism can hurt, but it's also an opportunity to grow. Reflecting on feedback objectively can help us improve and become more resilient."
      },
      {
        "text": "Feeling anxious about an upcoming social event",
        "emoji": "😟",
        "options": ["😊", "😢", "😟", "😡"],
        "feedback":
            "Social anxiety is common. Preparing ahead, practicing relaxation techniques, and challenging negative thoughts can help ease anxiety."
      },
    ];
  }

  void _checkAnswer(String emoji) {
    final correctEmoji = scenarios[currentScenarioIndex]["emoji"];
    if (emoji == correctEmoji) {
      setState(() {
        score += 10 + (2 * correctStreak); // More points for streaks
        correctStreak++;
        feedbackMessage =
            "\n\nCorrect!\n\n${scenarios[currentScenarioIndex]["feedback"]}\n\n\n";
      });
    } else {
      setState(() {
        if (lives > 0) lives--; // Reduce lives if wrong
        correctStreak = 0;
        feedbackMessage =
            "\n\nThat's not quite right.\n\n${scenarios[currentScenarioIndex]["feedback"]}\n\n\n";
        if (lives == 0) {
          _showGameOverDialog(); // Show game over when lives reach 0
        }
      });
    }

    if (lives > 0) {
      setState(() => showFeedback = true);
      Future.delayed(const Duration(seconds: 3), () {
        if (currentScenarioIndex < scenarios.length - 1) {
          setState(() {
            currentScenarioIndex++;
            showFeedback = false;
          });
        } else {
          _showFinalScore();
        }
      });
    }
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("🎮 Game Over 🎮", textAlign: TextAlign.center,),
          content:
              const Text("Oops! You've run out of lives. Let's try again.", textAlign: TextAlign.center,),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.deepPurple),
              child: const Text("Restart 💪"),
              onPressed: () {
                Navigator.of(context).pop();
                _restartGame();
              },
            ),
          ],
        );
      },
    );
  }

  void _restartGame() {
    setState(() {
      currentScenarioIndex = 0;
      score = 0;
      showFeedback = false;
      correctStreak = 0;
      lives = 3; // Reset lives back to 3
    });
  }

  void _showFinalScore() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Well Done!", textAlign: TextAlign.center,),
          content: Text("Your final score is $score!", textAlign: TextAlign.center,),
          actions: <Widget>[
            TextButton(
              child: const Text("Restart", textAlign: TextAlign.center,),
              onPressed: () {
                Navigator.of(context).pop();
                _restartGame();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildLivesIndicator() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Lives: ',
            style: TextStyle(
                color: Colors.white, fontStyle: FontStyle.italic, fontSize: 14),
          ),
          ...List.generate(
            3,
            (index) => Icon(
              index < lives ? Icons.favorite : Icons.favorite_border,
              color: index < lives ? Colors.redAccent : Colors.grey,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mood Match Challenge'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Lottie.asset(
                'assets/animations/mini_game1.json',
                height: 200, // Making the animation larger
                fit: BoxFit.cover,
              ),
              const Text(
                'Welcome to Mood Match!',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Match the mood with the correct scenario and learn more about emotional awareness. Ready to play?',
                style: TextStyle(color: Colors.white38, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: _buildLivesIndicator(),
                      ),
                      const SizedBox(height: 20),
                      if (!showFeedback) ...[
                        const Align(
                          alignment: Alignment.center,
                          child: Text(
                            'What mood does this scenario evoke?',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontStyle: FontStyle.italic),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            scenarios[currentScenarioIndex]["text"],
                            style: const TextStyle(
                                color: Colors.deepPurpleAccent,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Align(
                          alignment: Alignment.center,
                          child: Wrap(
                            spacing: 10,
                            alignment: WrapAlignment.center,
                            children: scenarios[currentScenarioIndex]["options"]
                                .map<Widget>((emoji) {
                              return ChoiceChip(
                                backgroundColor: Colors.grey.shade900,
                                selectedColor: theme.chipTheme.selectedColor,
                                labelStyle: const TextStyle(color: Colors.white),
                                label: Text(emoji,
                                    style: const TextStyle(fontSize: 24)),
                                selected: false,
                                onSelected: (_) => _checkAnswer(emoji),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            '🌟 Current Score: $score\n🔥 Streak: $correctStreak',
                            style: const TextStyle(fontSize: 14, color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ] else ...[
                        Align(
                          alignment: Alignment.center,
                          child: Text(feedbackMessage,
                            style:
                                const TextStyle(fontSize: 18, color: Colors.white70),
                            textAlign: TextAlign.center),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
