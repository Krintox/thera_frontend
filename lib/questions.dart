import 'package:flutter/material.dart';
import 'stresspage.dart'; // Import your StressPage

class Questions extends StatefulWidget {
  const Questions({Key? key}) : super(key: key);

  @override
  _QuestionsState createState() => _QuestionsState();
}

class _QuestionsState extends State<Questions> {
  String? _selectedAge;
  List<String> _selectedConditions = [];
  List<String> _selectedGoals = [];
  String? _customCondition;
  String? _customGoal;

  List<String> _ageOptions = [
    'Under 18',
    '18-30',
    '31-50',
    '51-65',
    'Over 65',
  ];

  List<String> _conditionOptions = [
    'Stroke',
    'Spinal cord injury',
    'Traumatic brain injury',
    'Arthritis',
    'Multiple sclerosis',
    "Parkinson's disease",
    'Cerebral palsy',
    'Developmental delay',
    'Other (Please specify)',
  ];

  List<String> _goalsOptions = [
    'Improve fine motor skills',
    'Enhance cognitive abilities',
    'Manage chronic pain',
    'Increase mobility',
    'Improve ADLs',
    'Enhance sensory integration',
    'Manage stress and anxiety',
    'Improve social skills',
    'Other (Please specify)',
  ];

  bool _isCustomConditionVisible = false;
  bool _isCustomGoalVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text(
          "Questionnaire",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green[200],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '1. How old are you?',
              style: TextStyle(fontSize: 16.0, color: Colors.white),
            ),
            DropdownButtonFormField<String>(
              value: _selectedAge,
              onChanged: (String? value) {
                setState(() {
                  _selectedAge = value;
                });
              },
              items: _ageOptions.map((String age) {
                return DropdownMenuItem<String>(
                  value: age,
                  child: Text(age, style: TextStyle(color: Colors.white)),
                );
              }).toList(),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[900],
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green[100]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green[100]!),
                ),
              ),
              style: TextStyle(color: Colors.white), // Text color when dropdown is closed
              dropdownColor: Colors.grey[900], // Dropdown box color when opened
            ),
            SizedBox(height: 12),
            Text(
              '2. What is your condition?',
              style: TextStyle(fontSize: 16.0, color: Colors.white),
            ),
            Wrap(
              spacing: 8.0,
              children: _conditionOptions.map((String condition) {
                return InputChip(
                  label: Text(condition, style: TextStyle(color: Colors.white)),
                  selected: _selectedConditions.contains(condition),
                  onSelected: (bool selected) {
                    setState(() {
                      selected
                          ? _selectedConditions.add(condition)
                          : _selectedConditions.remove(condition);
                      _isCustomConditionVisible =
                          condition == 'Other (Please specify)';
                    });
                  },
                  deleteIconColor: Colors.white,
                  backgroundColor: _selectedConditions.contains(condition)
                      ? Colors.green[200]
                      : Colors.green[200],
                );
              }).toList(),
            ),
            if (_isCustomConditionVisible)
              Container(
                margin: EdgeInsets.only(top: 8),
                child: TextFormField(
                  initialValue: _customCondition,
                  onChanged: (value) {
                    setState(() {
                      _customCondition = value;
                    });
                  },
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[900],
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green[100]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green[100]!),
                    ),
                    labelText: 'Other (Please specify)',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            SizedBox(height: 12),
            Text(
              '3. What are your therapy goals?',
              style: TextStyle(fontSize: 16.0, color: Colors.white),
            ),
            Wrap(
              spacing: 8.0,
              children: _goalsOptions.map((String goal) {
                return InputChip(
                  label: Text(goal, style: TextStyle(color: Colors.white)),
                  selected: _selectedGoals.contains(goal),
                  onSelected: (bool selected) {
                    setState(() {
                      selected
                          ? _selectedGoals.add(goal)
                          : _selectedGoals.remove(goal);
                      _isCustomGoalVisible = goal == 'Other (Please specify)';
                    });
                  },
                  deleteIconColor: Colors.white,
                  backgroundColor: _selectedGoals.contains(goal)
                      ? Colors.green[200]
                      : Colors.green[200],
                );
              }).toList(),
            ),
            if (_isCustomGoalVisible)
              Container(
                margin: EdgeInsets.only(top: 8),
                child: TextFormField(
                  initialValue: _customGoal,
                  onChanged: (value) {
                    setState(() {
                      _customGoal = value;
                    });
                  },
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[900],
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green[100]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green[100]!),
                    ),
                    labelText: 'Other (Please specify)',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StressAndCopingPage()),
                );
              },
              child: Text('Next', style: TextStyle(color: Colors.white)),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.green[200]!),
              ),
            ),
          ],
        ),
      ),
    );
  }
}