import 'package:flutter/foundation.dart';

class ApiConfig {
  // Base API URL - different for emulator vs physical device
  static String get baseUrl {
    if (kDebugMode) {
      // For Android emulator, use 10.0.2.2 to access host machine's localhost
      // For iOS simulator, use localhost
      return defaultTargetPlatform == TargetPlatform.android
          ? 'http://10.0.2.2:8080/api'
          : 'http://localhost:8080/api';
    } else {
      // For production, use your actual backend URL
      return 'https://your-production-backend.com/api';
    }
  }

  // API endpoints
  static String get userProfiles => '$baseUrl/userProfiles';
  static String userProfileById(String id) => '$baseUrl/userProfiles/$id';
  
  static String get journalEntries => '$baseUrl/journal';
  static String journalEntryById(String id) => '$baseUrl/journal/$id';
  
  // Add more endpoints as needed
  static String get logout => '$baseUrl/logout';
} 