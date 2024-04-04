// ignore_for_file: deprecated_member_use, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:overlay_support/overlay_support.dart';
import 'pages/relaxation_page.dart';
import 'utils/notification_manager.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NotificationManager(),
      child: OverlaySupport.global(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'CBTify',
          theme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.grey,
            hintColor: Colors.white,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            textTheme: const TextTheme(
              headline6: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),
              bodyText2: TextStyle(fontSize: 14.0, color: Colors.white70),
            ),
            floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: Colors.grey[800],
              foregroundColor: Colors.white,
            ),
            appBarTheme: const AppBarTheme(
              color: Colors.deepPurple,
              elevation: 2,
            ),
            inputDecorationTheme: const InputDecorationTheme(
              labelStyle: TextStyle(color: Colors.white70),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
            buttonTheme: ButtonThemeData(
              buttonColor: Colors.grey[800],
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          home: RelaxationScreen(),
        ),
      )
    );
  }
}
