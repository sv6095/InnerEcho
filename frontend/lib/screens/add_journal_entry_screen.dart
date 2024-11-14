import 'package:flutter/material.dart';
import 'journal_service.dart';

class AddJournalEntryScreen extends StatefulWidget {
  final String? initialTitle;
  final String? initialBody;

  const AddJournalEntryScreen({
    super.key,
    this.initialTitle,
    this.initialBody,
  });

  @override
  _AddJournalEntryScreenState createState() => _AddJournalEntryScreenState();
}

class _AddJournalEntryScreenState extends State<AddJournalEntryScreen> {
  late String title;
  late String body;
  List<String> tags = [];
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    title = widget.initialTitle ?? '';
    body = widget.initialBody ?? '';
  }

  Widget _buildTextField({
    required String label,
    String? initialValue,
    int maxLines = 1,
    required Function(String) onChanged,
  }) {
    return TextFormField(
      initialValue: initialValue,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label is required';
        }
        return null;
      },
      onChanged: onChanged,
    );
  }

  Widget _buildTagsField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Tags (separate with commas)',
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
      ),
      onChanged: (value) {
        setState(() {
          tags = value.split(',').map((tag) => tag.trim()).toList();
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB3B3FF),
      appBar: AppBar(
        title: const Text(
          'Add Journal Entry',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTextField(
                  label: 'Title',
                  initialValue: title,
                  onChanged: (value) {
                    setState(() {
                      title = value;
                    });
                  },
                ),
                const SizedBox(height: 16.0),
                _buildTextField(
                  label: 'Body',
                  initialValue: body,
                  maxLines: 5,
                  onChanged: (value) {
                    setState(() {
                      body = value;
                    });
                  },
                ),
                const SizedBox(height: 16.0),
                _buildTagsField(),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      final now = DateTime.now();
                      Navigator.pop(
                        context,
                        JournalEntry(
                          title: title,
                          body: body,
                          tags: tags,
                          date: now,
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'Save Entry',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}