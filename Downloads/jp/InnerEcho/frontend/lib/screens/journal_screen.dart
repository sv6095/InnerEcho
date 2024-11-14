import 'package:flutter/material.dart';
import 'add_journal_entry_screen.dart';
import 'journal_service.dart'; // MongoDB service for database operations

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  _JournalScreenState createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  List<JournalEntry> entries = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadJournalEntries();
  }

  // Loads journal entries from MongoDB using JournalService and updates the state
  Future<void> _loadJournalEntries() async {
    try {
      final journalEntries = await JournalService.getJournalEntries();
      setState(() {
        entries = journalEntries;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Show an error message (optional)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load entries: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB3B3FF),
      appBar: AppBar(
        title: const Text('My Journal', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Show loading indicator
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'You have ${entries.length} entries',
                    style: const TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
                Expanded(
                  child: entries.isEmpty
                      ? _buildEmptyState()
                      : _buildJournalList(),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addJournalEntry(context),
        backgroundColor: Colors.black,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // Displayed when there are no journal entries
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.note, size: 50, color: Colors.white),
          SizedBox(height: 16),
          Text(
            'No journal entries yet.',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          SizedBox(height: 8),
          Text(
            'Tap the + button to create your first entry.',
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  // Displays the list of journal entries
  Widget _buildJournalList() {
    return ListView.builder(
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        return Card(
          margin: const EdgeInsets.all(8.0),
          elevation: 4,
          color: Colors.white,
          child: ListTile(
            title: Text(
              entry.title ?? 'Untitled Entry',  // Provide default value for title
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.body ?? 'No content provided.',  // Default if body is null
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
                const SizedBox(height: 4),
                Text(
                  'Date: ${entry.date?.toLocal().toString().split(' ')[0] ?? 'No date available'}',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deleteJournalEntry(entry.id),
            ),
          ),
        );
      },
    );
  }

  // Opens AddJournalEntryScreen and adds a new entry if available
  Future<void> _addJournalEntry(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddJournalEntryScreen()),
    );
    if (result != null && result is JournalEntry) {
      await JournalService.addJournalEntry(result);
      _loadJournalEntries(); // Reload entries after adding a new one
    }
  }

  // Deletes a journal entry from MongoDB and reloads the entries
  Future<void> _deleteJournalEntry(String id) async {
    await JournalService.deleteJournalEntry(id);
    _loadJournalEntries(); // Reload entries after deletion
  }
}
