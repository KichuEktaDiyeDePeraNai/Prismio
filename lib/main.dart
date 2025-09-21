import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/lesson_page.dart';

void main() {
  runApp(const MyApp());
}

/// Main application widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '3D Model Viewer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(title: '3D Model Viewer - HORNET'),
      routes: {
        '/lesson': (context) => const LessonPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}