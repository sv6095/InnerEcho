// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'user_profile_creation_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0; // Track the current page index

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round(); // Update current page index
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB3B3FF), // Set background color
      body: Column(
        children: [
          // App Name
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'InnerEcho',
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Set text color to black
              ),
            ),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              children: [
                _buildFeaturePage(
                  title: 'Journaling',
                  description: 'Capture your thoughts and feelings.',
                  image: 'assets/images/journaling.jpg', // Add your image path
                ),
                _buildFeaturePage(
                  title: 'Meditation',
                  description: 'Find your inner peace with guided meditation.',
                  image: 'assets/images/meditation.jpg', // Add your image path
                ),
                _buildFeaturePage(
                  title: 'Mood Tracking',
                  description: 'Track your mood and reflect on your emotions.',
                  image: 'assets/images/mood_tracking.jpg', // Add your image path
                ),
                _buildFeaturePage(
                  title: 'Breathing Exercises',
                  description: 'Practice breathing techniques for relaxation.',
                  image: 'assets/images/breathing_exercises.jpg', // Add your image path
                ),
                _buildFeaturePage(
                  title: 'Daily Affirmations',
                  description: 'Start your day with positive affirmations.',
                  image: 'assets/images/affirmations.jpg', // Add your image path
                ),
              ],
            ),
          ),
          // Dots Indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) => _buildDot(index)),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const UserProfileCreationScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black, // Set button background color to black
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)), // Rounded corners
              ),
              child: const Text('Get Started', style: TextStyle(color: Colors.white)), // Set button text color to white
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturePage({required String title, required String description, required String image}) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(image, height: 200), // Load your feature image
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black), // Set title text color to black
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: const TextStyle(fontSize: 16, color: Colors.black), // Set description text color to black
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      height: 10.0,
      width: _currentPage == index ? 20.0 : 10.0,
      decoration: BoxDecoration(
        color: _currentPage == index ? const Color(0xFF1C7C8C) : Colors.grey,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
