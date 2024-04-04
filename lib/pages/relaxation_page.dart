// ignore_for_file: library_private_types_in_public_api, deprecated_member_use

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'main_page.dart';

// Screen for guiding users through relaxation exercises.
class RelaxationScreen extends StatefulWidget {
  const RelaxationScreen({super.key});

  @override
  _RelaxationScreenState createState() => _RelaxationScreenState();
}

class _RelaxationScreenState extends State<RelaxationScreen> {
  bool isRelaxing = false; // Flag indicating whether the relaxation process is active.
  int countdown = 60; // Countdown timer for relaxation duration

  // Audio players for various sounds used during relaxation
  final player = AudioPlayer();
  final player2 = AudioPlayer();
  final player3 = AudioPlayer();
  final player4 = AudioPlayer();
  final player5 = AudioPlayer();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await player.setSource(AssetSource('audio/relax1.mp3'));
      await player.resume();
      await Future.delayed(const Duration(seconds: 17));
      await player.setSource(AssetSource('audio/ambient_music.mp3'));
      await player.resume();
      startRelaxation();
    });
  }

  @override
  void dispose() {
    player.dispose();
    player2.dispose();
    player3.dispose();
    player4.dispose();
    player5.dispose();
    super.dispose();
  }

  // Starts the relaxation process and handles audio cues and countdown.
  void startRelaxation() async {
    setState(() {
      isRelaxing = true;
    });

    // Gyroscope listener for detecting shaking movements
    gyroscopeEvents.listen((GyroscopeEvent event) async {
      if (event.y > 0.2 || event.x > 0.2 || event.z > 0.2) {
        await player5.setSource(AssetSource('audio/relaxShake.mp3'));
        player5.resume();
      }
    });

    // Countdown timer
    for (int i = countdown; i > 0; i--) {
      if (i == 30) {
        await player2.setSource(AssetSource('audio/relax2.mp3'));
        await player2.resume();
      } else if (i == 15) {
        await player3.setSource(AssetSource('audio/relax3.mp3'));
        await player3.resume();
      }
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        countdown--;
      });
    }

    // Play completion message
  await player4.setSource(AssetSource('audio/relaxComplete.mp3'));
  await player4.resume();
  await Future.delayed(const Duration(seconds: 9)); // Wait for completion message

  if (!mounted) return;

  // Navigate with a fade transition
  Navigator.of(context).pushReplacement(PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => const MainScreen(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: animation, child: child);
    },
  ));

    setState(() {
      isRelaxing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Set background color to black.
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Display image if not relaxing.
            if (!isRelaxing)
              Padding(
                padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.1), // Add padding around the image.
                child: Image.asset(
                  'assets/images/meditation.gif',
                  width: MediaQuery.of(context).size.width * 0.6, // Adjust image width based on screen width.
                ),
              ),
            // Display text if not relaxing.
            if (!isRelaxing)
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.1 // Add horizontal padding.
                ),
                child: Text(
                  'Take a moment to relax before we begin.', // Display instruction text.
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.06, // Set font size.
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Set text color to white.
                  ),
                ),
              ),
            // Display text if not relaxing.
            if (!isRelaxing)
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.1, // Add horizontal padding.
                  vertical: MediaQuery.of(context).size.height * 0.05, // Add vertical padding.
                ),
                child: Text(
                  'Listen to the voice. Close your eyes, take deep breaths, and let go of any tension in your body.', // Display instruction text.
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.035, // Set font size.
                    color: Colors.white, // Set text color to white.
                  ),
                ),
              ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05), // Add empty space with height based on screen height.
            // Display countdown text if relaxing.
            if (isRelaxing)
              Text(
                'Relax for ${countdown ~/ 60}:${(countdown % 60).toString().padLeft(2, '0')}', // Display countdown timer.
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.05, // Set font size.
                  color: Colors.white, // Set text color to white.
                ),
              ),
            // Display animated candle flame if relaxing.
            if (isRelaxing)
              const CandleWithAnimatedFlame(),
            if (isRelaxing)
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.1, // Add horizontal padding.
                  vertical: MediaQuery.of(context).size.height * 0.05, // Add vertical padding.
                ),
                child: Text(
                  'Don\'t shake the flame. Be in control. Relax', // Display countdown timer.
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.04, // Set font size.
                    color: Colors.white, // Set text color to white.
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// Widget for displaying a candle with an animated flame.
class CandleWithAnimatedFlame extends StatefulWidget {
  const CandleWithAnimatedFlame({super.key});

  @override
  _CandleWithAnimatedFlameState createState() =>
      _CandleWithAnimatedFlameState();
}

class _CandleWithAnimatedFlameState extends State<CandleWithAnimatedFlame> {
  double flameHeight = 100.0; // Initial height of the flame.
  StreamSubscription<GyroscopeEvent>? _gyroscopeSubscription; // Subscription to gyroscope events

  @override
  void initState() {
    super.initState();
    _gyroscopeSubscription = gyroscopeEvents.listen((GyroscopeEvent event) {
      // Calculate total movement based on gyroscope data.
      double totalMovement = event.x.abs() + event.y.abs() + event.z.abs();
      if (mounted) {
        setState(() {
          // Adjust flame height based on total movement.
          flameHeight = 50.0 + totalMovement * 20.0; 
        });
      }
    });
  }

  @override
  void dispose() {
    _gyroscopeSubscription?.cancel(); // Cancel the subscription
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Candle base.
        Container(
          width: 60,
          height: 250,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        // Candle body.
        Positioned(
          bottom: 0,
          child: Container(
            width: 20,
            height: 160,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFD2B48C), // Light brown color at the top.
                  Color(0xFF8B4513), // Dark brown color at the bottom.
                ],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        // Candle wick.
        Positioned(
          bottom: 160,
          child: Container(
            width: 10,
            height: 10,
            decoration: const BoxDecoration(
              color: Colors.white, // Set wick color to white.
              shape: BoxShape.circle,
            ),
          ),
        ),
        // Flame.
        Positioned(
          bottom: 150, // Adjust position to align with the top of the candle body.
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200), // Set duration for flame animation.
            height: flameHeight, // Set flame height.
            width: 20,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.yellow.withOpacity(0.8), // Light yellow color at the top.
                  Colors.orange.withOpacity(0.8), // Orange color at the bottom.
                ],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }
}