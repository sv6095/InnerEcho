import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// API Response model matching backend
class ApiResponse {
  final String message;
  final dynamic data;
  final String status;

  ApiResponse.fromJson(Map<String, dynamic> json)
      : message = json['message'] ?? '',
        data = json['data'],
        status = json['status'] ?? '';
}

// User Profile model matching backend
class UserProfile {
  final String id;
  final String name;
  final String email;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }

  UserProfile copyWith({
    String? name,
    String? email,
  }) {
    return UserProfile(
      id: this.id,
      name: name ?? this.name,
      email: email ?? this.email,
    );
  }
}

// API Service for profile operations
class ProfileService {
  static const String baseUrl = 'http://10.0.2.2:8080/api';

  Future<List<UserProfile>> getAllProfiles() async {
    final response = await http.get(
      Uri.parse('$baseUrl/userProfiles'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => UserProfile.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load profiles');
    }
  }

  Future<UserProfile> updateProfile(UserProfile profile) async {
    final response = await http.post(
      Uri.parse('$baseUrl/userProfiles'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(profile.toJson()),
    );

    if (response.statusCode == 201) {
      return UserProfile.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update profile');
    }
  }

  Future<void> deleteProfile(String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/userProfiles/$id'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete profile');
    }
  }
}

// Edit Profile Dialog
class EditProfileDialog extends StatefulWidget {
  final UserProfile profile;

  const EditProfileDialog({Key? key, required this.profile}) : super(key: key);

  @override
  _EditProfileDialogState createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profile.name);
    _emailController = TextEditingController(text: widget.profile.email);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Profile'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final updatedProfile = widget.profile.copyWith(
              name: _nameController.text,
              email: _emailController.text,
            );
            Navigator.pop(context, updatedProfile);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}

// Main Profile Screen
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileService _profileService = ProfileService();
  UserProfile? _userProfile;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final profiles = await _profileService.getAllProfiles();
      if (profiles.isNotEmpty) {
        setState(() {
          _userProfile = profiles[0]; // For demo, using first profile
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'No profile found';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
      _showErrorSnackbar(e.toString());
    }
  }

  Future<void> _handleEditProfile() async {
    if (_userProfile == null) return;

    final updatedProfile = await showDialog<UserProfile>(
      context: context,
      builder: (context) => EditProfileDialog(profile: _userProfile!),
    );

    if (updatedProfile != null) {
      try {
        final savedProfile = await _profileService.updateProfile(updatedProfile);
        setState(() => _userProfile = savedProfile);
        _showSuccessSnackbar('Profile updated successfully');
      } catch (e) {
        _showErrorSnackbar('Failed to update profile: ${e.toString()}');
      }
    }
  }

  Future<void> _handleDeleteProfile() async {
    if (_userProfile == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Profile'),
        content: const Text('Are you sure you want to delete your profile? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _profileService.deleteProfile(_userProfile!.id);
        _showSuccessSnackbar('Profile deleted successfully');
        Navigator.of(context).pushReplacementNamed('/profile-selection'); // Navigate to profile selection after deletion
      } catch (e) {
        _showErrorSnackbar('Failed to delete profile: ${e.toString()}');
      }
    }
  }

 void _switchProfile() async {
  setState(() {
    _isLoading = true;
  });

  try {
    // Fetch all profiles and load the next one for demonstration.
    final profiles = await _profileService.getAllProfiles();
    if (profiles.isNotEmpty) {
      // Load the next profile or loop back to the first profile
      int currentIndex = profiles.indexOf(_userProfile!);
      int nextIndex = (currentIndex + 1) % profiles.length;
      setState(() {
        _userProfile = profiles[nextIndex];
        _isLoading = false;
      });
      _showSuccessSnackbar('Switched to ${_userProfile!.name}\'s profile');
    }
  } catch (e) {
    setState(() {
      _error = 'Failed to switch profile: ${e.toString()}';
      _isLoading = false;
    });
    _showErrorSnackbar(_error!);
  }
}


  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        action: SnackBarAction(
          label: 'Retry',
          onPressed: _loadProfile,
          textColor: Colors.white,
        ),
      ),
    );
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  Widget _buildProfileContent() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFB3B3FF)),
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _error!,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadProfile,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_userProfile == null) {
      return const Center(
        child: Text(
          'No profile found',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return Column(
      children: [
        const SizedBox(height: 20.0),
        const CircleAvatar(
          radius: 60.0,
          backgroundImage: AssetImage('assets/images/profile_avatar.png'),
        ),
        const SizedBox(height: 16.0),
        Text(
          _userProfile!.name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          _userProfile!.email,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 16.0,
          ),
        ),
        const SizedBox(height: 40.0),
        _buildProfileOption(
          context,
          Icons.edit,
          'Edit Profile',
          const Color(0xFFB3B3FF),
          _handleEditProfile,
        ),
        const Divider(color: Colors.grey),
        _buildProfileOption(
          context,
          Icons.delete,
          'Delete Profile',
          Colors.red,
          _handleDeleteProfile,
        ),
        const Divider(color: Colors.grey),
        _buildProfileOption(
          context,
          Icons.switch_account,
          'Switch Profile',
          const Color.fromARGB(218, 254, 31, 191),
          _switchProfile,
        ),
      ],
    );
  }

  Widget _buildProfileOption(
    BuildContext context,
    IconData icon,
    String title,
    Color color,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 18.0),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white70),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101010),
      appBar: AppBar(
        backgroundColor: const Color(0xFFB3B3FF),
        title: const Text('Profile'),
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: _loadProfile,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildProfileContent(),
          ),
        ),
      ),
    );
  }
}
