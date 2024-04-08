// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Thought {
  final String id;
  final String negativeThought;
  final List<String> options;
  final int correctOptionIndex;
  final String explanation;

  Thought({
    required this.id,
    required this.negativeThought,
    required this.options,
    required this.correctOptionIndex,
    required this.explanation,
  });
}

class ThoughtReframeGame extends StatefulWidget {
  const ThoughtReframeGame({super.key});

  @override
  _ThoughtReframeGameState createState() => _ThoughtReframeGameState();
}

class _ThoughtReframeGameState extends State<ThoughtReframeGame> {
  List<Thought> thoughts; // Initialize your thoughts list here
  int currentThoughtIndex = 0;
  bool? isCorrect;
  String feedback = "";
  int score = 0;
  int streak = 0;
  int lives = 5;

  _ThoughtReframeGameState() : thoughts = [
    Thought(
      id: "thought1",
      negativeThought: "I can't do anything right.",
      options: ["I always mess up.", "I can learn from my mistakes.", "I'm useless.", "Everyone has off days, I can try again."],
      correctOptionIndex: 1,
      explanation: "Acknowledging that everyone makes mistakes and that we can learn from them is a constructive and realistic approach.",
    ),
    Thought(
      id: "thought2",
      negativeThought: "No one understands me.",
      options: ["I should stop talking to people.", "Maybe I'm not expressing myself clearly.", "I'm better off alone.", "I can find common ground with others."],
      correctOptionIndex: 3,
      explanation: "Seeking understanding and commonality can lead to more meaningful connections.",
    ),
    Thought(
      id: "thought3",
      negativeThought: "I'm going to fail no matter how hard I try.",
      options: [
        "Success is impossible for me.",
        "Effort is pointless.",
        "There's always something to learn, even in failure.",
        "Failure is a part of the journey to success."
      ],
      correctOptionIndex: 3,
      explanation: "Viewing failure as a stepping stone rather than a setback can foster resilience and a growth mindset, encouraging persistence and effort."
    ),

    Thought(
      id: "thought4",
      negativeThought: "People always leave because I'm not interesting enough.",
      options: [
        "I should try to be someone I'm not.",
        "Maybe I can work on being more open and sharing my interests.",
        "It's better not to get close to anyone.",
        "I'm destined to be alone."
      ],
      correctOptionIndex: 1,
      explanation: "Building genuine connections involves sharing and openness. Recognizing your unique interests and values can attract like-minded individuals."
    ),

    Thought(
      id: "thought5",
      negativeThought: "I'll never be happy because my life is a mess.",
      options: [
        "Happiness is an unrealistic goal for me.",
        "If I work on organizing aspects of my life one at a time, it might improve.",
        "I don't deserve happiness.",
        "Chaos is my natural state."
      ],
      correctOptionIndex: 1,
      explanation: "Acknowledging the possibility of change and taking incremental steps to organize and address life's challenges can lead to improvements in happiness and well-being."
    ),

    Thought(
      id: "thought6",
      negativeThought: "I must be perfect, or I'm a complete failure.",
      options: [
        "Perfection is the only standard worth achieving.",
        "Small mistakes make me worthless.",
        "Striving for excellence is healthier than expecting perfection.",
        "Nobody respects effort, only perfect results."
      ],
      correctOptionIndex: 2,
      explanation: "Striving for excellence rather than perfection allows for personal growth and learning from mistakes, reducing undue pressure and enhancing self-acceptance."
    ),

    Thought(
      id: "thought7",
      negativeThought: "If I can't do it perfectly, then I shouldn't do it at all.",
      options: [
        "Avoiding tasks saves me from the pain of failure.",
        "Perfectionism is necessary for success.",
        "Taking part and trying my best is more important than being perfect.",
        "Nobody cares about the effort, only the perfect outcome."
      ],
      correctOptionIndex: 2,
      explanation: "Adopting a mindset that values effort and participation over flawless execution encourages learning and growth, making experiences enriching rather than paralyzing."
    ),

    Thought(
      id: "thought8",
      negativeThought: "My life hasn't gone as planned, so it's a total waste.",
      options: [
        "Life is only valuable if it goes exactly as planned.",
        "Deviation from my plan means I've failed.",
        "Life's unpredictability can lead to unexpected opportunities for growth.",
        "It's too late to make any changes."
      ],
      correctOptionIndex: 2,
      explanation: "Embracing life's unpredictability can open up new pathways and opportunities for growth, showing that value lies in the journey and how we adapt, not just the destination."
    ),
    Thought(
      id: "thought9",
      negativeThought: "I'll never be good enough.",
      options: ["It's true, I'm not good at this.", "I'm improving each day, even if it's slowly.", "Nobody likes me anyway.", "My worth isn't based on this alone."],
      correctOptionIndex: 1,
      explanation: "Growth and self-improvement take time and effort. Recognizing your progress, no matter how small, helps in developing a healthier self-image.",
    ),
    Thought(
      id: "thought10",
      negativeThought: "Everyone is judging me.",
      options: ["They must think I'm a failure.", "Maybe they're too concerned with their own lives to judge me.", "I know they dislike me.", "I can't do anything right in their eyes."],
      correctOptionIndex: 1,
      explanation: "Most people are more focused on their own experiences and challenges. Understanding this can alleviate the pressure we put on ourselves due to perceived judgment.",
    ),
  ];

  void checkAnswer(int selectedIndex) {
    final correct = thoughts[currentThoughtIndex].correctOptionIndex == selectedIndex;
    setState(() {
      if (correct) {
        score += 10 + streak * 5; // Additional points for streaks
        streak++;
        feedback = "Correct!\n\n${thoughts[currentThoughtIndex].explanation}";
      } else {
        streak = 0; // Reset streak on wrong answer
        if (lives > 0) lives--;
        feedback = "That's not quite right\n\nTry to adopt a more balanced perspective.";
      }
      isCorrect = correct;
    });

    if (lives == 0) {
      Future.delayed(const Duration(seconds: 2), showCompletionDialog);
    }
  }

  void goToNextThought() {
    if (currentThoughtIndex < thoughts.length - 1 && lives > 0) {
      setState(() {
        currentThoughtIndex++;
        isCorrect = null;
        feedback = "";
      });
    } else {
      showCompletionDialog();
    }
  }

  void showCompletionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Game Over"),
          content: Text(
            lives > 0
                ? "Congratulations!\n\nYou've completed the challenge with a score of $score."
                : "You've run out of lives. Try again to improve your score!",
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Restart"),
              onPressed: () {
                Navigator.of(context).pop();
                restartGame();
              },
            ),
          ],
        );
      },
    );
  }

  void restartGame() {
    setState(() {
      currentThoughtIndex = 0;
      isCorrect = null;
      feedback = "";
      score = 0;
      streak = 0;
      lives = 5;
    });
  }

  Widget _buildLivesIndicator() {
    List<Widget> lifeIcons = List.generate(
      5,
      (index) => Icon(
        index < lives ? Icons.favorite : Icons.favorite_border,
        color: index < lives ? Colors.red : Colors.grey,
        size: 24,
      ),
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const Text('Lives: '),
        Row(children: lifeIcons),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Thought currentThought = thoughts[currentThoughtIndex];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thought Reframe Challenge'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Add your Lottie animation and welcome text here
              Align(
                alignment: Alignment.center,
                child: Lottie.asset(
                  'assets/animations/mini_game2.json',
                  height: 200, // Making the animation larger
                  fit: BoxFit.cover,
                ),
              ),
              const Align(
                alignment: Alignment.center,
                child: Text(
                  'Welcome to Thought Reframe!',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Challenge and change your negative thoughts to learn how to think more positively.',
                style: TextStyle(color: Colors.white38, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 12, top: 4),
                          child: Text(
                            "Thought ${currentThoughtIndex + 1} / ${thoughts.length}",
                            style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.white54),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Padding(
                        padding: const EdgeInsets.only(right: 12, top: 4),
                        child: _buildLivesIndicator(),
                      ),
                      const SizedBox(height: 8),
                      const Divider(),
                      const SizedBox(height: 16),
                      const Text(
                        "Negative Thought",
                        style: TextStyle(fontSize: 14, color: Colors.white54, fontStyle: FontStyle.italic),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        currentThought.negativeThought,
                        style: const TextStyle(fontSize: 22, color: Colors.deepPurpleAccent, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      const Divider(),
                      for (var i = 0; i < currentThought.options.length; i++)
                        ListTile(
                          title: Text(currentThought.options[i]),
                          leading: Radio<int>(
                            value: i,
                            groupValue: isCorrect == true && currentThought.correctOptionIndex == i ? i : null,
                            onChanged: (value) => checkAnswer(i),
                          ),
                        ),
                      if (feedback.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            feedback,
                            style: TextStyle(color: isCorrect == true ? Colors.green.shade700 : Colors.red.shade800),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      if (isCorrect == true || lives == 0)
                        Center(
                          child: ElevatedButton(
                            onPressed: lives == 0 ? null : goToNextThought,
                            child: Text(currentThoughtIndex == thoughts.length - 1 || lives == 0 ? 'Finish' : 'Next Thought'),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}