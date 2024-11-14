import 'package:flutter/material.dart';

class DailyAffirmationsScreen extends StatefulWidget {
  const DailyAffirmationsScreen({super.key});

  @override
  _DailyAffirmationsScreenState createState() => _DailyAffirmationsScreenState();
}

class _DailyAffirmationsScreenState extends State<DailyAffirmationsScreen> {
  final List<String> _affirmations = [
    '“I am grateful for all the good in my life.”',
    '“I am capable of achieving my goals.”',
    '“I choose to be happy and positive.”',
    '“I believe in myself and my abilities.”',
    '“I am surrounded by love and support.”',
  ];

  int _currentAffirmationIndex = 0; // Track the current affirmation

  void _showNextAffirmation() {
    setState(() {
      _currentAffirmationIndex = (_currentAffirmationIndex + 1) % _affirmations.length; // Loop through affirmations
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB3B3FF), // Set background to lavender color
      appBar: AppBar(
        title: const Text(
          'Daily Affirmations',
          style: TextStyle(color: Colors.white), // Set title text color to white for visibility
        ),
        backgroundColor: Colors.black, // Set app bar color to black
        iconTheme: const IconThemeData(color: Colors.white), // Set back icon color to white
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Affirmation Text
              Container(
                decoration: BoxDecoration(
                  color: Colors.white, // Background color for the text container
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10.0,
                      spreadRadius: 2.0,
                      offset: const Offset(0, 5), // Shadow position
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20.0), // Padding inside the container
                child: Text(
                  _affirmations[_currentAffirmationIndex],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 28, // Increased font size
                    fontStyle: FontStyle.italic,
                    color: Colors.black, // Set text color to black for visibility
                    shadows: [
                      Shadow(
                        color: Colors.grey,
                        blurRadius: 5.0,
                        offset: Offset(2.0, 2.0), // Shadow offset
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _showNextAffirmation, // Show next affirmation
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, // Set button color to black
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: const TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)), // Rounded corners
                  elevation: 5, // Add elevation for a floating effect
                ),
                child: const Text('Next Affirmation', style: TextStyle(color: Colors.white)), // Set button text color to white
              ),
            ],
          ),
        ),
      ),
    );
  }
}
