import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';

class JournalEntry {
  final String? id;
  final String title;
  final String body;
  final DateTime date;
  final List<String> tags;

  JournalEntry({
    this.id,
    required this.title,
    required this.body,
    required this.date,
    required this.tags,
  });

  factory JournalEntry.fromJson(Map<String, dynamic> json) {
    return JournalEntry(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      date: DateTime.parse(json['date']),
      tags: List<String>.from(json['tags']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'body': body,
      'date': date.toIso8601String(),
      'tags': tags,
    };
  }
}

class JournalService {
  // Get all journal entries
  static Future<List<JournalEntry>> getJournalEntries() async {
    final response = await http.get(Uri.parse(ApiConfig.journalEntries));
    
    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => JournalEntry.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load journal entries: ${response.statusCode} - ${response.body}');
    }
  }

  // Get a journal entry by ID
  static Future<JournalEntry> getJournalEntry(String id) async {
    final response = await http.get(Uri.parse(ApiConfig.journalEntryById(id)));
    
    if (response.statusCode == 200) {
      return JournalEntry.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load journal entry: ${response.statusCode} - ${response.body}');
    }
  }

  // Create a new journal entry
  static Future<JournalEntry> addJournalEntry(JournalEntry entry) async {
    final response = await http.post(
      Uri.parse(ApiConfig.journalEntries),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(entry.toJson()),
    );
    
    if (response.statusCode == 201) {
      return JournalEntry.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to add journal entry: ${response.statusCode} - ${response.body}');
    }
  }

  // Update an existing journal entry
  static Future<JournalEntry> updateJournalEntry(String id, JournalEntry entry) async {
    final response = await http.put(
      Uri.parse(ApiConfig.journalEntryById(id)),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(entry.toJson()),
    );
    
    if (response.statusCode == 200) {
      return JournalEntry.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update journal entry: ${response.statusCode} - ${response.body}');
    }
  }

  // Delete a journal entry
  static Future<void> deleteJournalEntry(String id) async {
    final response = await http.delete(Uri.parse(ApiConfig.journalEntryById(id)));
    
    if (response.statusCode != 204) {
      throw Exception('Failed to delete journal entry: ${response.statusCode} - ${response.body}');
    }
  }
} 