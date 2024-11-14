import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MoodTrackingScreen extends StatefulWidget {
  final String? journalEntryId; // Optional - if updating existing entry
  final String? initialMood; // For editing existing mood

  const MoodTrackingScreen({
    super.key, 
    this.journalEntryId,
    this.initialMood,
  });

  @override
  _MoodTrackingScreenState createState() => _MoodTrackingScreenState();
}

class _MoodTrackingScreenState extends State<MoodTrackingScreen> {
  int _currentMood = 3;
  final List<String> _moodHistory = [];
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialMood != null) {
      _currentMood = _getMoodValue(widget.initialMood!);
    }
    _loadMoodHistory();
  }

  // Convert mood label to value
  int _getMoodValue(String moodLabel) {
    switch (moodLabel.toLowerCase()) {
      case 'very sad':
        return 1;
      case 'sad':
        return 2;
      case 'neutral':
        return 3;
      case 'happy':
        return 4;
      default:
        return 3;
    }
  }

  Future<void> _loadMoodHistory() async {
    try {
      // You might want to load mood history from your backend here
      // For now, we'll just initialize with the current mood if it exists
      if (widget.initialMood != null) {
        setState(() {
          _moodHistory.add(widget.initialMood!);
        });
      }
    } catch (e) {
      _showError('Failed to load mood history');
    }
  }

  Future<void> _saveMood() async {
    if (_isSaving) return;

    setState(() {
      _isSaving = true;
    });

    try {
      final moodLabel = _getMoodLabel(_currentMood);
      
      if (widget.journalEntryId != null) {
        // Update existing journal entry
        await _updateJournalEntryMood(widget.journalEntryId!, moodLabel);
      } else {
        // Create new journal entry with mood
        await _createJournalEntryWithMood(moodLabel);
      }

      setState(() {
        _moodHistory.add(moodLabel);
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Mood saved successfully!')),
        );
        Navigator.pop(context, moodLabel); // Return the mood to previous screen
      }
    } catch (e) {
      _showError('Failed to save mood');
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  Future<void> _updateJournalEntryMood(String entryId, String mood) async {
    final url = Uri.parse('YOUR_API_BASE_URL/api/journal/$entryId');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'mood': mood}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update mood');
    }
  }

  Future<void> _createJournalEntryWithMood(String mood) async {
    final url = Uri.parse('YOUR_API_BASE_URL/api/journal');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'title': 'Mood Entry - ${DateTime.now().toString()}',
        'body': 'Mood tracking entry',
        'mood': mood,
        'tags': ['mood'],
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create mood entry');
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB3B3FF),
      appBar: AppBar(
        title: const Text('Mood Tracking', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'How are you feeling today?',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(4, (index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentMood = index + 1;
                      });
                    },
                    child: _buildMoodIcon(index + 1),
                  );
                }),
              ),
              const SizedBox(height: 20),
              Slider(
                value: _currentMood.toDouble(),
                min: 1,
                max: 4,
                divisions: 3,
                activeColor: _getMoodColor(_currentMood),
                inactiveColor: Colors.grey,
                onChanged: (double value) {
                  setState(() {
                    _currentMood = value.toInt();
                  });
                },
                label: _getMoodLabel(_currentMood),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isSaving ? null : _saveMood,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                ),
                child: _isSaving
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Save Mood', style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: _moodHistory.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: const Color(0xFF1C1C1E),
                      margin: const EdgeInsets.symmetric(vertical: 5.0),
                      child: ListTile(
                        title: Text(
                          _moodHistory[index],
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getMoodLabel(int mood) {
    switch (mood) {
      case 1:
        return 'Very Sad';
      case 2:
        return 'Sad';
      case 3:
        return 'Neutral';
      case 4:
        return 'Happy';
      default:
        return 'Unknown';
    }
  }

  Color _getMoodColor(int mood) {
    switch (mood) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.yellow;
      case 4:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Widget _buildMoodIcon(int mood) {
    List<IconData> moodIcons = [
      Icons.sentiment_very_dissatisfied,
      Icons.sentiment_dissatisfied,
      Icons.sentiment_neutral,
      Icons.sentiment_satisfied,
    ];
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          moodIcons[mood - 1],
          color: _currentMood == mood ? _getMoodColor(mood) : Colors.grey,
          size: 40,
        ),
        const SizedBox(height: 4),
        Text(
          _getMoodLabel(mood),
          style: TextStyle(
            color: _currentMood == mood ? _getMoodColor(mood) : Colors.grey
          ),
        ),
      ],
    );
  }
}