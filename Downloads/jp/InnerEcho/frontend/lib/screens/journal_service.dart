import 'dart:convert';
import 'package:http/http.dart' as http;

class JournalEntry {
  final String id;
  final String title;
  final String body;
  final DateTime date;
  final List<String> tags;

  JournalEntry({
    required this.id,
    required this.title,
    required this.body,
    required this.date,
    required this.tags,
  });

  factory JournalEntry.fromJson(Map<String, dynamic> json) {
    return JournalEntry(
      id: json['_id'],
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
      'tags': tags,
    };
  }
}

class JournalService {
  static const String apiUrl = 'http://10.0.2.2:8080/api/journal';

  static Future<List<JournalEntry>> getJournalEntries() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => JournalEntry.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load journal entries: ${response.statusCode} - ${response.body}');
    }
  }

  static Future<JournalEntry> addJournalEntry(JournalEntry entry) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(entry.toJson()),
    );
    if (response.statusCode == 201) {
      final createdEntry = JournalEntry.fromJson(json.decode(response.body));
      return createdEntry;
    } else {
      throw Exception('Failed to add journal entry: ${response.statusCode} - ${response.body}');
    }
  }

  static Future<void> updateJournalEntry(String id, JournalEntry entry) async {
    final response = await http.put(
      Uri.parse('$apiUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(entry.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update journal entry: ${response.statusCode} - ${response.body}');
    }
  }

  static Future<void> deleteJournalEntry(String id) async {
    final response = await http.delete(Uri.parse('$apiUrl/$id'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete journal entry: ${response.statusCode} - ${response.body}');
    }
  }
}