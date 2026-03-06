import 'package:flutter/material.dart';
import 'package:next_stop/app/router.dart';

class NextStopApp extends StatelessWidget {
  const NextStopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Next Stop',
      debugShowCheckedModeBanner: false,

      // Light theme
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.teal,
        brightness: Brightness.light,
      ),

      // Dark theme
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.teal,
        brightness: Brightness.dark,
      ),

      // Follow system theme
      themeMode: ThemeMode.system,

      home: const RootScreen(),
    );
  }
}
