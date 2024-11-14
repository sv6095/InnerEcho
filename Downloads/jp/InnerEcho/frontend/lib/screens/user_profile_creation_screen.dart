import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Import HTTP package
import 'dart:convert'; // Import for JSON encoding/decoding
import 'home_screen.dart'; // Import HomeScreen

class UserProfileCreationScreen extends StatefulWidget {
  const UserProfileCreationScreen({super.key});

  @override
  _UserProfileCreationScreenState createState() => _UserProfileCreationScreenState();
}

class _UserProfileCreationScreenState extends State<UserProfileCreationScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB3B3FF), // Set background to lavender color
      appBar: AppBar(
        title: const Text(
          'Create Profile',
          style: TextStyle(color: Colors.white), // Set title text color to white
        ),
        backgroundColor: Colors.black, // Set app bar color to black
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person, size: 50, color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Personal Information',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const SizedBox(height: 20),
              _buildInputField(label: 'Full Name', controller: _nameController, icon: Icons.person),
              const SizedBox(height: 10),
              _buildInputField(label: 'Email Address', controller: _emailController, icon: Icons.email),
              const SizedBox(height: 10),
              _buildInputField(label: 'Phone Number', controller: _phoneController, icon: Icons.phone),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    _saveProfile(); // Call save profile function
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black, // Button color
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    textStyle: const TextStyle(fontSize: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)), // Rounded corners
                  ),
                  child: const Text('Save Profile', style: TextStyle(color: Colors.white)), // Button text color
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({required String label, required TextEditingController controller, required IconData icon}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black), // Label text color
        border: const OutlineInputBorder(),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black), // Border color when enabled
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 2), // Border color when focused
        ),
        prefixIcon: Icon(icon, color: Colors.black), // Icon in the input field
      ),
      style: const TextStyle(color: Colors.black), // Text color in text field
    );
  }

  Future<void> _saveProfile() async {
    // Prepare the data to send
    final String name = _nameController.text;
    final String email = _emailController.text;
    final String phone = _phoneController.text;

    // Create the JSON object
    final Map<String, String> profileData = {
      'name': name,
      'email': email,
      'phone': phone,
    };

    // Make the HTTP POST request to the backend
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8080/api/userProfiles'), // Update to http://localhost:8080/api/userProfiles if emulator is not used
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(profileData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // If the server returns a 200 OK or 201 Created response, navigate to HomeScreen
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile saved for $name')),
        );

        // Navigate to the HomeScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        // If the server did not return a success response, show an error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save profile. Please try again.')),
        );
        print('Error: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      // Handle any errors during the HTTP request
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save profile. Please try again.')),
      );
      print('Exception: $e');
    }
  }
}
