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

  Widget _buildDashboardItem(String title, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Card(
        color: Colors.green[300], // Set the card color to green[300]
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
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text('Dashboard'),
        backgroundColor: Colors.green[300],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green[300],
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                ),
              ),
            ),
            ListTile(
              title: Text('Settings'),
              onTap: _navigateToSettings, // Connect Settings button to SettingsPage
            ),
            // Add more ListTile items for navigation
          ],
        ),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.all(18.0),
        children: [
          _buildDashboardItem('Fine Motor Skills', Icons.brush, _navigateToFineMotorSkills),
          _buildDashboardItem('Cognitive Abilities', Icons.lightbulb, _navigateToCognitiveAbilities),
          _buildDashboardItem('Sensory Integration', Icons.touch_app, _navigateToSensoryIntegration),
          _buildDashboardItem('Progress Tracking', Icons.trending_up, _navigateToProgressTracking),
          _buildDashboardItem('Goal Setting', Icons.checklist, _navigateToGoalSetting),
          _buildDashboardItem('Trace the Path', Icons.timeline, _navigateToTracePath), // Add Trace the Path item
          // Add more dashboard items as needed
        ],
      ),
    );
  }
}
