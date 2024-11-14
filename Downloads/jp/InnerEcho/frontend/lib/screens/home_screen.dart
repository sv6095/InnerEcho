import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart'; // Import audioplayers package
import 'journal_screen.dart';
import 'mood_tracking_screen.dart';
import 'meditation_screen.dart';
import 'breathing_exercises_screen.dart';
import 'daily_affirmations_screen.dart';
import 'chatbot_screen.dart';
import 'profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  static const Color backgroundLavender = Color(0xFFB3B3FF);

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Color cardColor = const Color.fromARGB(255, 250, 249, 249);
  final Color accentBlue = const Color(0xFF4D79FF);
  final Color textBlack = Colors.black;
  final Color textWhite = Colors.white;

  final AudioPlayer _audioPlayer = AudioPlayer(); // Initialize AudioPlayer
  bool _isPlaying = false;
  String? _currentPlayingUrl;

  bool _showMoodCheck = true;
  String? _selectedMood;
  DateTime? _lastCheckIn;

  @override
  void initState() {
    super.initState();
    _loadMoodState();
  }

  Future<void> _loadMoodState() async {
    final prefs = await SharedPreferences.getInstance();
    final lastCheckInStr = prefs.getString('lastCheckIn');
    final savedMood = prefs.getString('selectedMood');

    if (lastCheckInStr != null) {
      final lastCheckIn = DateTime.parse(lastCheckInStr);
      final now = DateTime.now();

      if (!_isSameDay(lastCheckIn, now)) {
        setState(() {
          _showMoodCheck = true;
          _selectedMood = null;
        });
        await prefs.remove('lastCheckIn');
        await prefs.remove('selectedMood');
      } else {
        setState(() {
          _showMoodCheck = false;
          _selectedMood = savedMood;
          _lastCheckIn = lastCheckIn;
        });
      }
    }
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  Future<void> _saveMoodSelection(String mood) async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();

    await prefs.setString('lastCheckIn', now.toIso8601String());
    await prefs.setString('selectedMood', mood);

    setState(() {
      _showMoodCheck = false;
      _selectedMood = mood;
      _lastCheckIn = now;
    });
  }

  Future<void> _playOrPauseMusic(String url) async {
    if (_isPlaying && _currentPlayingUrl == url) {
      await _audioPlayer.pause();
      setState(() {
        _isPlaying = false;
      });
    } else {
      if (_currentPlayingUrl != url) {
        await _audioPlayer.stop(); // Stop any current playback before starting new one
        await _audioPlayer.play(url as Source); // Play new audio
      } else {
        await _audioPlayer.resume(); // Resume if paused
      }
      setState(() {
        _isPlaying = true;
        _currentPlayingUrl = url;
      });
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose(); // Dispose AudioPlayer when widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HomeScreen.backgroundLavender,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome, User!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                const Text(
                  '"Peace starts within."',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 10.0),

                _buildDailyCheckInSection(),
                const SizedBox(height: 10.0),

                _buildAffirmationsSection(context),
                const SizedBox(height: 10.0),

                _buildFeatureCard(
                  context,
                  'Breathing Exercises',
                  'assets/images/breathing_image.jpg',
                  'Bring a sense of spaciousness into your day',
                  const BreathingExercisesScreen(),
                ),
                const SizedBox(height: 10.0),

                _buildFeatureCard(
                  context,
                  'Mood Tracking',
                  'assets/images/mood_tracking_image.jpg',
                  'Check in with your mood daily',
                  const MoodTrackingScreen(),
                ),
                const SizedBox(height: 10.0),

                _buildHorizontalListSection(
                  title: 'Start Meditating',
                  items: [
                    _buildMeditationCard(context, 'Release Stress', 'Morning', '12 min', ''),
                    _buildMeditationCard(context, 'Relationships', 'Course', '12 min', 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3'),
                  ],
                ),
                const SizedBox(height: 10.0),

                _buildHorizontalListSection(
                  title: 'Music for Relaxation',
                  items: [
                    _buildMusicCard(context, 'A Night in Yellowstone', '15-19 min', 'https://open.spotify.com/track/23khhseCLQqVMCIT1WMAns?si=5f893112f5f4435b'),
                    _buildMusicCard(context, 'A Tranquil Night', '16-20 min', 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3'),
                    _buildMusicCard(context, 'Prana', '14-18 min', 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-5.mp3'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.black,
        shape: const CircularNotchedRectangle(),
        notchMargin: 6.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.home, color: Colors.white),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.chat_bubble_outline, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ChatbotScreen()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.book, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const JournalScreen()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.person, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfileScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyCheckInSection() {
    if (!_showMoodCheck) {
      return _buildMoodSummary();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "How are you today?",
          style: TextStyle(
            color: Color.fromARGB(255, 255, 250, 250),
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16.0),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildMoodButton('Great', const Color.fromARGB(255, 4, 251, 12)),
              const SizedBox(width: 8),
              _buildMoodButton('Good', const Color.fromARGB(255, 0, 8, 255)),
              const SizedBox(width: 8),
              _buildMoodButton('Okay', const Color.fromARGB(255, 255, 230, 0)),
              const SizedBox(width: 8),
              _buildMoodButton('Not Great', const Color.fromARGB(255, 255, 153, 0)),
              const SizedBox(width: 8),
              _buildMoodButton('Bad', const Color.fromARGB(255, 252, 17, 0)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMoodSummary() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Today's Mood",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                _selectedMood ?? '',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _showMoodCheck = true;
              });
            },
            child: const Text(
              'Update',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodButton(String label, Color color) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _saveMoodSelection(label),
        borderRadius: BorderRadius.circular(30.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: color.withOpacity(0.8),
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAffirmationsSection(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DailyAffirmationsScreen()),
        );
      },
      child: Container(
        height: 250, // Increased height here
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                child: Image.asset(
                  'assets/images/affirmations_image.jpg',
                  fit: BoxFit.cover,
                  height: 150, // Adjust image height accordingly
                ),
              ),
              const SizedBox(height: 10.0),
              const Text(
                'Daily Affirmations',
                style: TextStyle(color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4.0),
              const Text(
                'Cultivate a positive mindset',
                style: TextStyle(color: Colors.black, fontSize: 14.0),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard(BuildContext context, String title, String imagePath, String subtitle, Widget screen) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
      },
      child: Container(
        height: 250, // Increased height to ensure the image fits well
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  height: 150, // Adjust image height accordingly
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                title,
                style: const TextStyle(color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              Text(
                subtitle,
                style: const TextStyle(color: Colors.black54, fontSize: 14.0),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHorizontalListSection({required String title, required List<Widget> items}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.black, fontSize: 22.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8.0),
        SizedBox(
          height: 150,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: items.map((item) {
              return Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: item,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildMeditationCard(BuildContext context, String title, String duration, String durationDescription, String audioUrl) {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4.0),
            Text(
              duration,
              style: const TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 4.0),
            Text(
              durationDescription,
              style: const TextStyle(color: Colors.black54),
            ),
            const Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: IconButton(
                icon: const Icon(Icons.play_circle_fill, color: Colors.blueAccent),
                onPressed: () => _playOrPauseMusic(audioUrl), // Play or pause audio
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMusicCard(BuildContext context, String title, String duration, String audioUrl) {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4.0),
            Text(
              duration,
              style: const TextStyle(color: Colors.black54),
            ),
            const Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: IconButton(
                icon: const Icon(Icons.play_circle_fill, color: Colors.blueAccent),
                onPressed: () => _playOrPauseMusic(audioUrl), // Play or pause audio
              ),
            ),
          ],
        ),
      ),
    );
  }
}
