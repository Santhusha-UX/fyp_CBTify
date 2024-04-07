// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:convert';

class Mood {
  final String name;
  final String lottieAsset;
  final Color color;
  final int value;

  Mood(this.name, this.lottieAsset, this.color, this.value);
}

final List<Mood> moods = [
  Mood("Happy", 'assets/animations/happy.json', Colors.yellow, 5),
  Mood("Sad", 'assets/animations/sad.json', Colors.blue, 1),
  Mood("Angry", 'assets/animations/angry.json', Colors.red, 2),
  Mood("Anxious", 'assets/animations/anxious.json', Colors.orange, 3),
  Mood("Excited", 'assets/animations/excited.json', Colors.green, 4),
  Mood("Loved", 'assets/animations/loved.json', Colors.pinkAccent, 6),
];

int moodValue(String moodName) =>
    moods.firstWhere((mood) => mood.name == moodName).value;

class MoodTrackerScreen extends StatefulWidget {
  const MoodTrackerScreen({super.key});

  @override
  _MoodTrackerScreenState createState() => _MoodTrackerScreenState();
}

class _MoodTrackerScreenState extends State<MoodTrackerScreen> {
  Mood? selectedMood;
  final TextEditingController _contextController = TextEditingController();

  List<FlSpot> moodData = [];

  @override
  void initState() {
    super.initState();
    _loadMoodData();
  }

  Future<void> _loadMoodData() async {
    final prefs = await SharedPreferences.getInstance();
    final moodEntries = prefs.getStringList('moodEntries');
    if (moodEntries != null) {
      List<FlSpot> loadedData = [];
      for (var i = 0; i < moodEntries.length; i++) {
        final entry = json.decode(moodEntries[i]);
        final mood = entry['mood'];
        final dateTime = DateTime.parse(entry['date']);
        final moodValue =
            moods.firstWhere((m) => m.name == mood).value.toDouble();
        // Using day of year for simplicity, you might want to adjust this
        loadedData.add(FlSpot(dateTime.day.toDouble(), moodValue));
      }
      setState(() {
        moodData = loadedData;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Track Your Mood"),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                margin: const EdgeInsets.only(top: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'How do you feel today?',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "Select a mood that best describes your current state. Your feelings are a valuable insight into your well-being.",
                        style: TextStyle(
                            color: Colors.white38,
                            fontSize: 14,
                            fontStyle: FontStyle.italic),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: Wrap(
                          spacing: 20,
                          runSpacing: 20,
                          children: moods
                              .map((mood) => GestureDetector(
                                    onTap: () =>
                                        setState(() => selectedMood = mood),
                                    child: Opacity(
                                      opacity: selectedMood == mood ? 1.0 : 0.5,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Lottie.asset(mood.lottieAsset,
                                              width: 90,
                                              animate: selectedMood == mood),
                                          Text(mood.name),
                                        ],
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                      if (selectedMood != null) ...[
                        const SizedBox(height: 20),
                        RichText(
                          text: TextSpan(
                            text: "Today's mood: ",
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white54),
                            children: <TextSpan>[
                              TextSpan(
                                text: selectedMood!.name,
                                style: TextStyle(
                                    color: Colors.deepPurpleAccent[100]),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 24),
                      const Text(
                        "What's influencing your mood?",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "Context can give us great insight into our emotions. Share what's happening or how your day went.",
                        style: TextStyle(
                            color: Colors.white38,
                            fontSize: 14,
                            fontStyle: FontStyle.italic),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _contextController,
                        decoration: const InputDecoration(
                          labelText: "What's on your mind?",
                          labelStyle: TextStyle(color: Colors.white70),
                          hintText: "Describe what influenced your mood today.",
                          hintStyle: TextStyle(
                              color: Colors.white30,
                              fontWeight: FontWeight.normal,
                              fontStyle: FontStyle.italic),
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 4,
                      ),
                      const SizedBox(height: 24),
                      Center(
                        child: ElevatedButton(
                          onPressed: _confirmSaveMood,
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.deepPurple,
                          ),
                          child: const Text("Save Mood"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Card(
                margin: const EdgeInsets.only(bottom: 8),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Mood Trends',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      const SizedBox(height: 4), // Adjust the spacing as needed
                      const Text(
                        "Each point represents your mood on a specific day, helping you to identify trends and triggers.",
                        style: TextStyle(
                            color: Colors.white38,
                            fontSize: 14,
                            fontStyle: FontStyle.italic),
                      ),
                      const SizedBox(height: 30),
                      Container(
                        height: 300, // Placeholder height for a chart
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: _buildMoodChart(),
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

  Widget _buildMoodChart() {
    if (moodData.isEmpty) {
      return const Center(
        child: Text(
            "No mood data available. Start tracking your mood to see trends."),
      );
    }

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          verticalInterval: 3,
          horizontalInterval: 1,
          getDrawingHorizontalLine: (value) {
            return FlLine(color: Colors.grey[700], strokeWidth: 1);
          },
        ),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 3,
              getTitlesWidget: (double value, TitleMeta meta) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(value.toInt().toString(),
                        style: const TextStyle(
                            color: Colors.white60, fontSize: 10)),
                    const Text(
                      'Days',
                      style: TextStyle(color: Colors.white60, fontSize: 10),
                    ),
                  ],
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 45,
              getTitlesWidget: (double value, TitleMeta meta) {
                String moodName = moods
                    .firstWhere(
                      (mood) => mood.value.toDouble() == value,
                      orElse: () => Mood("", "", Colors.white, 0),
                    )
                    .name;
                return Text(moodName,
                    style:
                        const TextStyle(color: Colors.white60, fontSize: 10));
              },
            ),
          ),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(
            color: Colors.white10, // Customize the border color as needed
            width: 1, // Customize the border width as needed
          ),
        ),
        minX: 0,
        maxX: 30,
        minY: 0,
        maxY: moods.length.toDouble(),
        lineBarsData: [
          LineChartBarData(
            spots: moodData,
            isCurved: true,
            color: Colors.deepPurpleAccent,
            barWidth: 1,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(
                show: true, color: Colors.deepPurple.withOpacity(0.1)),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmSaveMood() async {
    if (selectedMood == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select a mood before saving.")));
      return;
    }
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm"),
          content: const Text("Are you sure you want to save this mood?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text("Save"),
              onPressed: () {
                _saveMood();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveMood() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> moodEntries = prefs.getStringList('moodEntries') ?? [];
    final entry = json.encode({
      'mood': selectedMood!.name,
      'date': DateTime.now().toIso8601String(),
      'context': _contextController.text,
    });
    moodEntries.add(entry);
    await prefs.setStringList('moodEntries', moodEntries);
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Mood saved successfully!")));
    // Clear the input fields after saving
    setState(() {
      _contextController.clear();
      selectedMood = null;
    });
  }
}
