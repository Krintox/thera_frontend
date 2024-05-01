import 'package:flutter/material.dart';
import 'begin.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToBeginPageAfterDelay(context); // Pass context here
  }

  void _navigateToBeginPageAfterDelay(BuildContext context) async {
    await Future.delayed(Duration(milliseconds: 2500));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => BeginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Grey background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/thera.jpg'), // Image on top
            SizedBox(height: 20.0), // Add spacing between image and texts
            Text(
              'Thera',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Your Emotional Wellbeing Companion',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
