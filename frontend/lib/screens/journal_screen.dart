import 'package:flutter/material.dart';
import 'add_journal_entry_screen.dart';
import '../services/journal_service.dart';

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
    setState(() {
      isLoading = true;
    });
    
    try {
      final journalEntries = await JournalService.getJournalEntries();
      if (mounted) {
        setState(() {
          entries = journalEntries;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        // Show an error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load entries: $e')),
        );
      }
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
      body: RefreshIndicator(
        onRefresh: _loadJournalEntries,
        child: isLoading
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
              entry.title,
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
                  entry.body,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
                const SizedBox(height: 4),
                Text(
                  'Date: ${entry.date.toLocal().toString().split(' ')[0]}',
                  style: const TextStyle(color: Colors.grey),
                ),
                if (entry.tags.isNotEmpty)
                  Wrap(
                    spacing: 6.0,
                    children: entry.tags.map((tag) => Chip(
                      label: Text(tag),
                      labelStyle: const TextStyle(fontSize: 10),
                      padding: EdgeInsets.zero,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    )).toList(),
                  ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => _editJournalEntry(entry),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteJournalEntry(entry.id!),
                ),
              ],
            ),
            isThreeLine: true,
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
      _loadJournalEntries(); // Reload entries after adding a new one
    }
  }
  
  // Opens AddJournalEntryScreen with existing entry data for editing
  Future<void> _editJournalEntry(JournalEntry entry) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddJournalEntryScreen(
          initialTitle: entry.title,
          initialBody: entry.body,
        ),
      ),
    );
    
    if (result != null && result is JournalEntry) {
      try {
        await JournalService.updateJournalEntry(entry.id!, result);
        _loadJournalEntries(); // Reload entries after updating
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update entry: $e')),
        );
      }
    }
  }

  // Deletes a journal entry and reloads the entries
  Future<void> _deleteJournalEntry(String id) async {
    try {
      await JournalService.deleteJournalEntry(id);
      _loadJournalEntries(); // Reload entries after deletion
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete entry: $e')),
      );
    }
  }
}
