import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../games/mood_match.dart';
import '../games/thought_reframe.dart';
import '../games/word_web.dart';

class ChallengePage extends StatelessWidget {
  const ChallengePage({super.key});

  Widget _buildBanner(BuildContext context) {
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
          Lottie.asset('assets/animations/game.json', width: MediaQuery.of(context).size.width * 0.8, repeat: true),
          const Text(
            "Welcome to CBTify Game Hub",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Explore, learn, and grow with fun and engaging CBT-based mini-games designed with industry professionals just for you!',
            style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.9)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CBTify Game Hub'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildBanner(context),
            // const SizedBox(height: 12),
            const GameList(),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class GameList extends StatelessWidget {
  const GameList({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> miniGames = [
      {
        'title': 'Mood Match',
        'description': 'Match emotions with scenarios to enhance emotional awareness.',
        'lottieAsset': 'assets/animations/mini_game1.json',
        'widget': const MoodMatch(), 
      },
      {
        'title': 'Thought Reframe',
        'description': 'Challenge and reframe negative thoughts into positive ones.',
        'lottieAsset': 'assets/animations/mini_game2.json',
        'widget': const ThoughtReframeGame(), 
      },
      {
        'title': 'Word Web',
        'description': 'Discover how thoughts are interconnected to our mood and behavior.',
        'lottieAsset': 'assets/animations/mini_game3.json',
        'widget': const WordWebGame(), 
      },
    ];

    return Column(
      children: miniGames.map((game) {
        return GameCard(
          title: game['title'],
          description: game['description'],
          lottieAsset: game['lottieAsset'],
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => game['widget']));
          },
        );
      }).toList(),
    );
  }
}

class GameCard extends StatelessWidget {
  final String title;
  final String description;
  final String lottieAsset;
  final VoidCallback onTap;

  const GameCard({
    super.key,
    required this.title,
    required this.description,
    required this.lottieAsset,
    required this.onTap,
  });

  @override
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Lottie.asset(
                lottieAsset,
                width: 100, 
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white38,
                        fontStyle: FontStyle.italic,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
