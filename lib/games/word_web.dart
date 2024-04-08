import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class WordWebGame extends StatefulWidget {
  const WordWebGame({Key? key}) : super(key: key);

  @override
  _WordWebGameState createState() => _WordWebGameState();
}

class _WordWebGameState extends State<WordWebGame> {
  List<Map<String, dynamic>> levels = [
    {
      "centralThought": "Stressed",
      "description":
          "Explore how different thoughts connect to your feelings of stress.",
      "options": ["Overwhelmed", "Anxious", "Busy", "Challenged", "Excited"],
      "feedbacks": {
        "Overwhelmed":
            "Catastrophizing can make you feel as if problems are insurmountable.\n\nWhat's one step you could take to feel less overwhelmed?",
        "Anxious":
            "Fortune telling can increase anxiety by anticipating the worst.\n\nCould there be a positive outcome?",
        "Busy":
            "Feeling constantly busy may lead to overgeneralization.\n\nAre there moments of calm you're overlooking?",
        "Challenged":
            "Feeling challenged is not a sign of failure but an opportunity for growth.\n\nWhat have you learned from this challenge?",
        "Excited":
            "Identifying excitement in stress highlights your ability to find positive opportunities in challenging situations."
      }
    },
    {
      "centralThought": "Unworthy",
      "description":
          "Explore how different thoughts connect to your feelings of unworthiness.",
      "options": [
        "Inferior",
        "Useless",
        "Capable",
        "Appreciated",
        "Overlooked"
      ],
      "feedbacks": {
        "Inferior":
            "Comparing ourselves to others can lead to feelings of inferiority.\n\nReflect on your unique strengths and qualities.",
        "Useless":
            "Feeling useless is often a result of harsh self-judgment.\n\nList your achievements and contributions, no matter how small they seem.",
        "Capable":
            "Recognizing your capabilities can shift your self-view.\n\nConsider times you've successfully faced challenges.",
        "Appreciated":
            "Self-appreciation is key to feeling valued.\n\nWhat qualities do you appreciate in yourself?",
        "Overlooked":
            "Feeling overlooked can stem from not voicing our needs.\n\nPractice expressing your contributions and needs in your relationships."
      }
    },
    {
      "centralThought": "Fearful",
      "description":
          "Explore how different thoughts connect to your feelings of fear.",
      "options": ["Threatened", "Safe", "Vulnerable", "Protected", "Exposed"],
      "feedbacks": {
        "Threatened":
            "Feeling threatened can magnify perceived danger.\n\nAssess the situation objectively to identify real vs. imagined threats.",
        "Safe":
            "Identifying elements of safety in your life can provide comfort.\n\nWhat are your safe spaces or safe people?",
        "Vulnerable":
            "Embracing vulnerability allows for true connection and growth.\n\nWhat strength can you find in vulnerability?",
        "Protected":
            "Acknowledging protection helps build security.\n\nWhat measures or relationships protect you?",
        "Exposed":
            "Feeling exposed is uncomfortable but can lead to resilience.\n\nHow can this exposure be a learning opportunity?"
      }
    },
    {
      "centralThought": "Angry",
      "description":
          "Explore how different thoughts connect to your feelings of anger.",
      "options": [
        "Frustrated",
        "Misunderstood",
        "Heard",
        "Dismissed",
        "Respected"
      ],
      "feedbacks": {
        "Frustrated":
            "Frustration often arises from unmet expectations.\n\nCan resetting your expectations or changing your approach help?",
        "Misunderstood":
            "Misunderstandings can fuel anger.\n\nHow can you improve communication to ensure you're understood?",
        "Heard":
            "Feeling heard can alleviate anger.\n\nWhat changes when you feel listened to?",
        "Dismissed":
            "Feeling dismissed can intensify anger.\n\nAsserting your worth and boundaries is crucial.",
        "Respected":
            "Respect is foundational for self-esteem and mutual understanding.\n\nHow do you establish respect in your interactions?"
      }
    },
    {
      "centralThought": "Sad",
      "description":
          "Explore how different thoughts connect to your feelings of sadness.",
      "options": ["Hopeless", "Grieving", "Optimistic", "Lonely", "Connected"],
      "feedbacks": {
        "Hopeless":
            "Hopelessness often comes from a sense of powerlessness.\n\nWhat small action can bring a sense of control back to you?",
        "Grieving":
            "Grieving is a process that needs time and care.\n\nHow can you gently support yourself through this process?",
        "Optimistic":
            "Optimism can be a beacon during sad times.\n\nWhat's something good in your life, no matter how small?",
        "Lonely":
            "Loneliness is challenging but can be eased by reaching out.\n\nWho can you connect with today?",
        "Connected":
            "Feeling connected can significantly lift spirits.\n\nWhat connections are most meaningful to you, and how can you nurture them?"
      }
    }
  ];

  int currentLevel = 0;
  Set<String> selectedOptions = Set();
  String feedbackMessage = "";

  void selectOption(String option) {
    setState(() {
      if (selectedOptions.contains(option)) {
        selectedOptions.remove(option);
        feedbackMessage = "";
      } else {
        selectedOptions.clear();
        selectedOptions.add(option);
        feedbackMessage = levels[currentLevel]["feedbacks"][option];
      }
    });
  }

  void proceedToNextLevel() {
    if (currentLevel < levels.length - 1) {
      setState(() {
        currentLevel++;
        selectedOptions.clear();
        feedbackMessage = "";
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
          title: Text("🎉 Congratulations! 🎉"),
          content: Text(
              "You've explored different perspectives on your thoughts and feelings. Continue practicing these strategies to maintain a healthy mindset."),
          actions: <Widget>[
            TextButton(
              child: Text("Start Over"),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  currentLevel = 0;
                  selectedOptions.clear();
                  feedbackMessage = "";
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Word Web: Understanding Your Thoughts'),
        centerTitle: true,
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
                  'assets/animations/mini_game3.json',
                  height: 200, // Making the animation larger
                  fit: BoxFit.cover,
                ),
              ),
              const Align(
                alignment: Alignment.center,
                child: Text(
                  'Welcome to Word Web!',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Discover how thoughts are interconnected and can affect mood and behavior.',
                style: TextStyle(color: Colors.white38, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      const Text(
                        "Main Thought",
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.white54,
                            fontStyle: FontStyle.italic),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        levels[currentLevel]['centralThought'],
                        style: const TextStyle(
                            fontSize: 22,
                            color: Colors.deepPurpleAccent,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Text(
                          levels[currentLevel]['description'],
                          style: TextStyle(
                              color: Colors.white54,
                              fontSize: 14,
                              fontStyle: FontStyle.italic),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 12,
                        runSpacing: 10,
                        children: levels[currentLevel]['options']
                            .map<Widget>((option) {
                          return ChoiceChip(
                            label: Text(option),
                            selected: selectedOptions.contains(option),
                            onSelected: (selected) => selectOption(option),
                            selectedColor: Colors.deepPurpleAccent,
                            labelStyle: TextStyle(color: Colors.white),
                          );
                        }).toList(),
                      ),
                      if (feedbackMessage.isNotEmpty) ...[
                        Container(
                          padding: EdgeInsets.all(16),
                          margin: EdgeInsets.only(top: 6),
                          child: Text(
                            feedbackMessage,
                            style: TextStyle(fontSize: 14, color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                      const SizedBox(height: 6),
                      ElevatedButton(
                        onPressed: proceedToNextLevel,
                        child: Text(currentLevel < levels.length - 1
                            ? 'Next Level'
                            : 'Finish'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.deepPurple,
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10),
                          textStyle: TextStyle(fontSize: 18),
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
