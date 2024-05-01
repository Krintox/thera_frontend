import 'package:flutter/material.dart';
import 'homepage.dart';

class StressAndCopingPage extends StatefulWidget {
  @override
  _StressAndCopingPageState createState() => _StressAndCopingPageState();
}

class _StressAndCopingPageState extends State<StressAndCopingPage> {
  String? _selectedActivityLevel;
  String? _selectedLearningStyle;
  String? _selectedAccessibilityNeeds;
  String? _selectedTherapyExperience;

  List<String> _activityLevelOptions = [
    'Sedentary (little to no physical activity)',
    'Moderately active (regular light physical activity)',
    'Highly active (regular vigorous physical activity)',
  ];

  List<String> _learningStyleOptions = [
    'Visual (learn best through seeing)',
    'Auditory (learn best through hearing)',
    'Hands-on (learn best through doing)',
    'Reading/Writing (learn best reading/writing)',
  ];

  List<String> _accessibilityNeedsOptions = [
    'Visual impairment',
    'Hearing impairment',
    'Motor impairment',
    'Cognitive impairment',
    'No specific accessibility needs',
  ];

  List<String> _therapyExperienceOptions = [
    'Yes',
    'No',
  ];

  void _showSubmitConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.green[100],
          title: Text('Submission Confirmation', style: TextStyle(color: Colors.black)),
          content: Text('Your response has been submitted.'),
        );
      },
    );

    Future.delayed(Duration(milliseconds: 1500), () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '4. Activity Level:',
                style: TextStyle(fontSize: 16.0, color: Colors.white),
              ),
              SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedActivityLevel,
                onChanged: (String? value) {
                  setState(() {
                    _selectedActivityLevel = value;
                  });
                },
                items: _activityLevelOptions.map((String level) {
                  return DropdownMenuItem<String>(
                    value: level,
                    child: Text(level, style: TextStyle(color: Colors.white)),
                  );
                }).toList(),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[800],
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green[100]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green[100]!),
                  ),
                ),
                style: TextStyle(color: Colors.white),
                dropdownColor: Colors.grey[800],
              ),
              SizedBox(height: 32),
              Text(
                '5. Preferred Learning Style:',
                style: TextStyle(fontSize: 16.0, color: Colors.white),
              ),
              SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedLearningStyle,
                onChanged: (String? value) {
                  setState(() {
                    _selectedLearningStyle = value;
                  });
                },
                items: _learningStyleOptions.map((String style) {
                  return DropdownMenuItem<String>(
                    value: style,
                    child: Text(style, style: TextStyle(color: Colors.white)),
                  );
                }).toList(),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[800],
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green[100]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green[100]!),
                  ),
                ),
                style: TextStyle(color: Colors.white),
                dropdownColor: Colors.grey[800],
              ),
              SizedBox(height: 32),
              Text(
                '6. Accessibility Needs:',
                style: TextStyle(fontSize: 16.0, color: Colors.white),
              ),
              SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedAccessibilityNeeds,
                onChanged: (String? value) {
                  setState(() {
                    _selectedAccessibilityNeeds = value;
                  });
                },
                items: _accessibilityNeedsOptions.map((String needs) {
                  return DropdownMenuItem<String>(
                    value: needs,
                    child: Text(needs, style: TextStyle(color: Colors.white)),
                  );
                }).toList(),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[800],
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green[100]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green[100]!),
                  ),
                ),
                style: TextStyle(color: Colors.white),
                dropdownColor: Colors.grey[800],
              ),
              SizedBox(height: 32),
              Text(
                '7. Previous Therapy Experience:',
                style: TextStyle(fontSize: 16.0, color: Colors.white),
              ),
              SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedTherapyExperience,
                onChanged: (String? value) {
                  setState(() {
                    _selectedTherapyExperience = value;
                  });
                },
                items: _therapyExperienceOptions.map((String experience) {
                  return DropdownMenuItem<String>(
                    value: experience,
                    child: Text(experience, style: TextStyle(color: Colors.white)),
                  );
                }).toList(),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[800],
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green[100]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green[100]!),
                  ),
                ),
                style: TextStyle(color: Colors.white),
                dropdownColor: Colors.grey[800],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Handle button press
                  _showSubmitConfirmation(context); // Show confirmation dialog and navigate after delay
                },
                child: Text('Submit', style: TextStyle(color: Colors.white)),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.green[200]!),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}