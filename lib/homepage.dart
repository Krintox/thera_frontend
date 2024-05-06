import 'package:flutter/material.dart';
import 'finemotorskills.dart';
import 'cognitiveabilities.dart';
import 'sensory.dart';
import 'progresstracking.dart';
import 'goalsetting.dart';
import 'settings.dart';
import 'tracethepath.dart'; // Import the TraceThePath widget

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  void _navigateToFineMotorSkills() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FineMotorSkills()),
    );
  }

  void _navigateToCognitiveAbilities() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CognitiveAbilities()),
    );
  }

  void _navigateToSensoryIntegration() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SoundMatchingGame()),
    );
  }

  void _navigateToProgressTracking() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProgressTracking()),
    );
  }

  void _navigateToGoalSetting() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GoalSettingPage()),
    );
  }

  void _navigateToSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Settings()), // Navigate to SettingsPage
    );
  }

  void _navigateToTracePath() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TraceThePath()), // Navigate to TraceThePath
    );
  }

  Widget _buildDashboardItem(String title, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Card(
        color: color, // Use the provided color for the card
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 50,
                color: Colors.black, // Change icon color to black
              ),
              SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        children: [
          _buildDashboardItem('Fine Motor Skills', Icons.build, Colors.pink[100]!, _navigateToFineMotorSkills),
          _buildDashboardItem('Cognitive Abilities', Icons.lightbulb, Colors.lightBlue[200]!, _navigateToCognitiveAbilities),
          _buildDashboardItem('Trace The Path', Icons.alt_route, Colors.yellow[200]!, _navigateToTracePath),
          _buildDashboardItem('Sensory Integration', Icons.speaker, Colors.lightGreen[200]!, _navigateToSensoryIntegration),
          _buildDashboardItem('Goal Setting', Icons.flag, Colors.deepPurple[200]!, _navigateToGoalSetting),
          _buildDashboardItem('Progress Tracking', Icons.timeline, Colors.amber[200]!, _navigateToProgressTracking),
          _buildDashboardItem('Settings', Icons.settings, Colors.teal[200]!, _navigateToSettings),
        ],
      ),
    );
  }
}
