import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() => runApp(const InnerEchoApp());

class InnerEchoApp extends StatefulWidget {
  const InnerEchoApp({super.key});

  @override
  _InnerEchoAppState createState() => _InnerEchoAppState();
}

class _InnerEchoAppState extends State<InnerEchoApp> {
  final ThemeMode _themeMode = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inner Echo',
      theme: ThemeData(
        primaryColor: const Color(0xFF1C7C8C),
        scaffoldBackgroundColor: const Color(0xFFFFFFFF),
        fontFamily: 'Roboto',
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        primaryColor: const Color(0xFF1C7C8C),
        scaffoldBackgroundColor: const Color(0xFF212121),
        fontFamily: 'Roboto',
        brightness: Brightness.dark,
      ),
      themeMode: _themeMode,
      home: const SplashScreen(),
    );
  }
}
