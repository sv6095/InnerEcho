import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';

class UserProfile {
  final String? id;
  final String name;
  final String email;

  UserProfile({
    this.id,
    required this.name,
    required this.email,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
    };
  }
}

class UserProfileService {
  // Get user profile by ID
  static Future<UserProfile> getUserProfile(String id) async {
    final response = await http.get(Uri.parse(ApiConfig.userProfileById(id)));
    
    if (response.statusCode == 200) {
      return UserProfile.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load user profile: ${response.statusCode} - ${response.body}');
    }
  }

  // Create a new user profile
  static Future<UserProfile> createUserProfile(UserProfile profile) async {
    final response = await http.post(
      Uri.parse(ApiConfig.userProfiles),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(profile.toJson()),
    );
    
    if (response.statusCode == 201) {
      return UserProfile.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create user profile: ${response.statusCode} - ${response.body}');
    }
  }

  // Update an existing user profile
  static Future<UserProfile> updateUserProfile(String id, UserProfile profile) async {
    final response = await http.put(
      Uri.parse(ApiConfig.userProfileById(id)),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(profile.toJson()),
    );
    
    if (response.statusCode == 200) {
      return UserProfile.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update user profile: ${response.statusCode} - ${response.body}');
    }
  }

  // Delete a user profile
  static Future<void> deleteUserProfile(String id) async {
    final response = await http.delete(Uri.parse(ApiConfig.userProfileById(id)));
    
    if (response.statusCode != 200) {
      throw Exception('Failed to delete user profile: ${response.statusCode} - ${response.body}');
    }
  }

  // Logout user
  static Future<void> logout() async {
    final response = await http.post(Uri.parse(ApiConfig.logout));
    
    if (response.statusCode != 200) {
      throw Exception('Failed to logout: ${response.statusCode} - ${response.body}');
    }
  }
} 