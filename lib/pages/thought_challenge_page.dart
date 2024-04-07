// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api, deprecated_member_use, no_leading_underscores_for_local_identifiers
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../db/database_helper.dart';
import '../models/thought_challenge.dart';
import 'package:fl_chart/fl_chart.dart';

class ThoughtChallengeScreen extends StatefulWidget {
  const ThoughtChallengeScreen({super.key});

  @override
  _ThoughtChallengeScreenState createState() => _ThoughtChallengeScreenState();
}

class _ThoughtChallengeScreenState extends State<ThoughtChallengeScreen> {
  final PageController _pageController = PageController();
  final _negativeThoughtController = TextEditingController();

  double _evidenceFor = 0.0;
  double _evidenceAgainst = 0.0;
  List<String> techniques = [
    "Decatastrophizing",
    "Examining the Evidence",
    "The Double-Standard Method"
  ];
  String selectedTechnique = "Decatastrophizing";
  ThoughtChallenge? _currentChallenge;
// Example streak counter

  @override
  void initState() {
    super.initState();
    _currentChallenge = ThoughtChallenge(
      id: DateTime.now().toString(),
      negativeThought: '',
      evidenceFor: [],
      evidenceAgainst: [],
      cognitiveReframingTechnique: '',
      reframedThought: '',
      progress: 0.0,
    );
// Fetch from storage in real app
  }

  Future<bool> _saveChallenge() async {
    try {
      if (_currentChallenge != null) {
        await DatabaseHelper.instance
            .createThoughtChallenge(_currentChallenge!);
        return true;
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error saving challenge: $e");
      }
    }
    return false;
  }

  void _updateProgressAndAchievements() {
    double newProgress =
        (_currentChallenge?.progress ?? 0) + 0.1; // Increment by 10%
    _currentChallenge?.updateProgress(newProgress);

    if (newProgress >= 1.0) {
      _unlockAchievement("Thought Master", "Completed all thought challenges!");
    }

    setState(() {});
  }

  void _unlockAchievement(String title, String description) {
    if (kDebugMode) {
      print("Achievement unlocked: $title - $description");
    }
  }

  void _showMessage(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  bool _validateChallengeInput() {
    if (_negativeThoughtController.text.isEmpty) {
      _showMessage("Please enter a negative thought.");
      return false;
    }
    // Add more validation checks as necessary
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thought Shift'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _introSection(),
            const SizedBox(height: 20),
            _negativeThoughtInputSection(),
            const SizedBox(height: 20),
            _evidenceSection(),
            const SizedBox(height: 20),
            _cognitiveReframingSection(),
            const SizedBox(height: 20),
            _completeChallengeButton(),
            const SizedBox(height: 20),
            const ProgressDashboard(),
            const SizedBox(height: 10),
            const Divider(color: Colors.grey),
            const SizedBox(height: 10),
            _buildDailyChallengeSection(),
          ],
        ),
      ),
    );
  }

  Widget _introSection() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
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
          Lottie.asset(
            'assets/animations/cognitive_reframing_intro.json',
            width: double.infinity,
            height: 200,
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              "Welcome to Your Mindful Journey",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Text(
            "Discover how cognitive reframing can transform your mental health.",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.9),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              _showTutorial(context);
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white, // Button color
              backgroundColor: Colors.deepPurple, // Text color
            ),
            child: const Text("Start Tutorial"),
          ),
        ],
      ),
    );
  }

  void _showTutorial(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.black, // Make dialog background transparent
          child: Container(
            height: MediaQuery.of(context).size.height * 0.6,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Expanded(
                  child: PageView(
                    controller:
                        _pageController, // Use the initialized controller here
                    children: [
                      _tutorialPage(
                        "Recognize Your Thoughts",
                        "Start by acknowledging your negative thoughts. It's the first step towards transformation.",
                        'assets/animations/thought_recognition.json',
                      ),
                      _tutorialPage(
                        "Evaluate Your Thoughts",
                        "Consider the evidence for and against your thoughts. Challenge them to see the bigger picture.",
                        'assets/animations/thought_evaluation.json',
                      ),
                      _tutorialPage(
                        "Shift Your Perspective",
                        "Adopt a new viewpoint. Reframe your thoughts to empower positivity and resilience.",
                        'assets/animations/thought_reframing.json',
                      ),
                    ],
                  ),
                ),
                SmoothPageIndicator(
                  controller: _pageController, // Use the same controller here
                  count: 3,
                  effect: WormEffect(
                    dotWidth: 10.0,
                    dotHeight: 10.0,
                    activeDotColor: Colors.deepPurple,
                    dotColor: Colors.grey.shade300,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("Got It"),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _tutorialPage(String title, String description, String lottieAsset) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Lottie.asset(lottieAsset, fit: BoxFit.contain),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(fontSize: 14, color: Colors.grey[800]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _negativeThoughtInputSection() {
    return Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Text(
                  "What's on Your Mind?",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Text(
                "Share the thought that's bothering you. Remember, this is a safe space to explore your feelings.",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _negativeThoughtController,
                decoration: InputDecoration(
                  hintText: "Type here...",
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade100),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade600),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.white70),
                  ),
                  // fillColor: Colors.deepPurple.shade50,
                  filled: false,
                ),
                maxLines: null,
                keyboardType: TextInputType.multiline,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ));
  }

  Widget _evidenceSection() {
    return Card(
        margin: const EdgeInsets.symmetric(vertical: 0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(0.0),
                child: Text(
                  "Balancing Your Thoughts",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              Text(
                "Consider the evidence for and against your thought. This can help you see the situation more objectively.",
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 18),
              _evidenceSlider("Evidence Supporting My Thought", _evidenceFor,
                  (value) {
                setState(() => _evidenceFor = value);
              }),
              const SizedBox(height: 12),
              _evidenceSlider(
                  "Evidence Contradicting My Thought", _evidenceAgainst,
                  (value) {
                setState(() => _evidenceAgainst = value);
              }),
              TextButton(
                onPressed: _showEvidenceReflectionDialog,
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white54,
                  backgroundColor: Colors.transparent,
                  textStyle:
                      const TextStyle(decoration: TextDecoration.underline),
                ),
                child: const Align(
                  alignment: Alignment.bottomRight,
                  child: Text("Need help? Tap for examples"),
                ),
              ),
            ],
          ),
        ));
  }

  Widget _evidenceSlider(
      String title, double value, Function(double) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white70)),
        Slider(
          value: value,
          onChanged: onChanged,
          min: 0,
          max: 100,
          divisions: 10,
          label: "${value.round()}%",
          activeColor: Colors.deepPurple,
          inactiveColor: Colors.deepPurple.shade100,
        ),
      ],
    );
  }

  void _showEvidenceReflectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Reflection Examples", textAlign: TextAlign.center),
          content: const Text(
            "For evidence supporting your thought, consider past experiences or facts that align with your view.\n\n"
            "For evidence against it, think about times when the opposite was true or situations that challenge your current perspective.",
            textAlign: TextAlign.justify,
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Got It",
                  style: TextStyle(color: Colors.deepPurpleAccent)),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  Widget _cognitiveReframingSection() {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Reframe Your Perspective",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              "Select a reframing technique to view your thought in a new light. Tap on the info icon for a brief guide on each technique.",
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 4),
            DropdownButtonFormField<String>(
              value: selectedTechnique,
              onChanged: (value) => setState(() => selectedTechnique = value!),
              items: techniques.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Row(
                    children: [
                      const Icon(Icons.psychology,
                          color: Colors.deepPurpleAccent),
                      const SizedBox(width: 8),
                      Text(value),
                    ],
                  ),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: "Techniques",
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.info_outline,
                      color: Colors.deepPurpleAccent),
                  onPressed: _showTechniqueHelp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTechniqueHelp() {
    showDialog(
      context: context,
      barrierDismissible: true, // Allow dismissal without selecting a technique
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Techniques Explained",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SizedBox(
            width: double.maxFinite, // Ensure dialog width is adjusted
            child: ListView(
              shrinkWrap:
                  true, // Ensure the ListView only occupies needed space
              children: techniques
                  .map((technique) => ListTile(
                        title: Text(technique,
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.deepPurple.shade300,
                                fontWeight: FontWeight.bold)),
                        subtitle: Text(_getTechniqueDescription(technique),
                            style: const TextStyle(
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                                color: Colors.white38)),
                        leading: const Icon(Icons.lightbulb_outline,
                            color: Colors.deepPurpleAccent),
                      ))
                  .toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Understood",
                  style: TextStyle(color: Colors.deepPurpleAccent)),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  String _getTechniqueDescription(String technique) {
    switch (technique) {
      case "Decatastrophizing":
        return "Question the worst-case scenarios to challenge catastrophic thoughts.";
      case "Examining the Evidence":
        return "Assess the facts to see if your thoughts are supported by evidence.";
      case "The Double-Standard Method":
        return "Speak to yourself as kindly as you would to a friend in the same situation.";
      default:
        return "No description available.";
    }
  }

  Widget _buildDailyChallengeSection() {
    // Placeholder values for title, description, and today's challenge
    const String sectionTitle = "Your Mindfulness Journey";
    const String sectionDescription =
        "Embark on daily challenges designed to enhance your mindfulness and mental well-being.";
    const String todaysChallenge = "Reflect on a positive moment";
    const String challengeDescription =
        "Today, focus on the positive aspects of your day. What moment brought you joy, peace, or satisfaction?\n\nReflect on this moment to cultivate gratitude. Additionally journal your gratitude";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                sectionTitle,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                sectionDescription,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
        Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Today's Challenge",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Take a moment to engage with today's challenge and enhance your thought mindfulness.",
                  style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => _showChallengeDialog(
                      todaysChallenge, challengeDescription),
                  style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.deepPurple),
                  child: const Text("Show Challenge"),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showChallengeDialog(String challenge, String description) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset('assets/animations/positive_reflection.json',
                repeat:
                    false), // Make sure to have a Lottie file ready for this
            const SizedBox(height: 20),
            Text(
              challenge,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 12),
            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Colors.white38),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('Let\'s Go!'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _completeChallengeButton() {
    return Align(
      alignment: Alignment.center,
      child: ElevatedButton.icon(
        onPressed: () async {
          if (!_validateChallengeInput()) return;

          // Proceed with saving the challenge if validation passes
          if (_currentChallenge != null) {
            _currentChallenge!
              ..negativeThought = _negativeThoughtController.text
              ..evidenceFor = [] // This should be updated based on user input
              ..evidenceAgainst = [] // This too
              ..cognitiveReframingTechnique = selectedTechnique
              ..reframedThought = '' // And this
              ..progress = 0.0; // Consider how progress is handled

            if (await _saveChallenge()) {
              _updateProgressAndAchievements();
              _showSuccessDialog();
            } else {
              _showFailureDialog();
            }
          }
        },
        icon: const Icon(Icons.check),
        label: const Text('Complete Challenge'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset('assets/animations/celebration.json', repeat: false),
            const SizedBox(height: 20),
            const Text("🎉 Hooray! 🎉",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const Text(
              "Great job on completing your challenge. Keep up the fantastic work!",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white30 // Adjusted color for theme consistency
                  ),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  void _showFailureDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset('assets/animations/error.json',
                repeat:
                    false), // Assuming you have an appropriate Lottie animation for failure
            const SizedBox(height: 20),
            const Text(
              "Oops! Something went wrong.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              "Failed to save challenge. Please try again.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white30),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('Try Again'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _negativeThoughtController.dispose();
    super.dispose();
  }
}

class ProgressDashboard extends StatefulWidget {
  const ProgressDashboard({super.key});

  @override
  _ProgressDashboardState createState() => _ProgressDashboardState();
}

class _ProgressDashboardState extends State<ProgressDashboard> {
  late Future<int> _currentStreakFuture;
  late Future<List<double>> _progressPointsFuture;

  @override
  void initState() {
    super.initState();
    _currentStreakFuture = DatabaseHelper.instance.getCurrentStreak();
    _progressPointsFuture = DatabaseHelper.instance.getProgressPoints();
  }

  Widget _buildProgressChart(List<double> progressPoints) {
    if (progressPoints.isEmpty) {
      progressPoints = [60];
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 16.0), // Add padding around the chart for breathing room
      child: AspectRatio(
        aspectRatio: 1.7, // Adjust aspect ratio if needed
        child: LineChart(
          LineChartData(
            minX: 0, // Starting point of the X-axis
            maxX: progressPoints.length.toDouble() -
                1, // Ending point of the X-axis
            minY: 0, // Start minY from 0 for percentage representation
            maxY: 100,
            gridData: FlGridData(
              show: true,
              drawVerticalLine: true,
              horizontalInterval: 20, // Adjust based on your data range
              getDrawingHorizontalLine: (value) {
                return FlLine(color: Colors.grey[700], strokeWidth: 1);
              },
            ),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40, // Increase space for Y-axis titles
                  interval: 20, // Adjust based on your data range
                  getTitlesWidget: (double value, TitleMeta meta) {
                    return Text('${value.toInt()}%',
                        style:
                            TextStyle(color: Colors.grey[600], fontSize: 12));
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize:
                      22, // Increase space for X-axis titles if needed
                  interval: 1, // Adjust based on the number of data points
                  getTitlesWidget: (value, meta) {
                    if (progressPoints.length > 10 && value % 2 != 0) {
                      return const SizedBox
                          .shrink(); // Optional: Skip every other label for clarity
                    }
                    return Text('Day ${value.toInt() + 1}',
                        style:
                            TextStyle(color: Colors.grey[600], fontSize: 10));
                  },
                ),
              ),
              topTitles: const AxisTitles(
                sideTitles:
                    SideTitles(showTitles: false), // Remove top axis titles
              ),
              rightTitles: const AxisTitles(
                sideTitles:
                    SideTitles(showTitles: false), // Remove right axis titles
              ),
            ),
            borderData: FlBorderData(show: false),
            lineBarsData: [
              LineChartBarData(
                spots: progressPoints
                    .asMap()
                    .entries
                    .map((e) => FlSpot(e.key.toDouble(), e.value))
                    .toList(),
                isCurved: true,
                color: Colors.deepPurple,
                barWidth: 3,
                dotData: const FlDotData(show: false),
                belowBarData: BarAreaData(
                    show: true, color: Colors.deepPurple.withOpacity(0.1)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Your Progress",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            FutureBuilder<int>(
              future: _currentStreakFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                final currentStreak = snapshot.data ?? 0;
                return Text("Current Streak: $currentStreak days",
                    style: const TextStyle(
                        fontSize: 14, color: Colors.deepPurpleAccent));
              },
            ),
            const SizedBox(height: 16),
            const Text("Progress Over Time",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            FutureBuilder<List<double>>(
              future: _progressPointsFuture,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();
                return _buildProgressChart(snapshot.data!);
              },
            ),
          ],
        ),
      ),
    );
  }
}
