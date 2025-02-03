import 'package:flutter/material.dart';
import 'package:solution_cha/phoneSignup.dart';
import 'package:solution_cha/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: TextTheme(
          bodyLarge: TextStyle(fontFamily: 'K2D'),
          bodyMedium: TextStyle(fontFamily: 'K2D'),
          displayLarge: TextStyle(fontFamily: 'K2D'),
          displayMedium: TextStyle(fontFamily: 'K2D'),
          displaySmall: TextStyle(fontFamily: 'K2D'),
          headlineMedium: TextStyle(fontFamily: 'K2D'),
          headlineSmall: TextStyle(fontFamily: 'K2D'),
          titleLarge: TextStyle(fontFamily: 'K2D'),
          titleMedium: TextStyle(fontFamily: 'K2D'),
          titleSmall: TextStyle(fontFamily: 'K2D'),
          labelLarge: TextStyle(fontFamily: 'K2D'),
          bodySmall: TextStyle(fontFamily: 'K2D'),
          labelSmall: TextStyle(fontFamily: 'K2D'),
        ),
      ),
      debugShowCheckedModeBanner: false,
      title: "Hearth",
      home: phoneSignup(),
    );
  }
}
