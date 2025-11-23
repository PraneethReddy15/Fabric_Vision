import 'package:flutter/material.dart';
import 'intro_screen.dart'; // Replace with the path to your IntroScreen file

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FabricVision',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const IntroScreen(), // Set IntroScreen as the initial screen
    );
  }
}