import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'tracethepath.dart'; // Assuming TraceThePath is imported from another file

class FineMotorSkills extends StatefulWidget {
  const FineMotorSkills({Key? key}) : super(key: key);

  @override
  _FineMotorSkillsState createState() => _FineMotorSkillsState();
}

class _FineMotorSkillsState extends State<FineMotorSkills> {
  String? selectedExercise;

  List<String> exercises = [
    'Hand-eye coordination',
    'Grip strength',
    'Finger dexterity',
    'Precision movements'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Fine Motor Skills',
        style: TextStyle(
          color: Colors.white,
        ),),
        backgroundColor: Colors.pink[100],
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop(); // Navigate back to previous screen
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Exercises Dropdown
            Text(
              'Exercises',
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(height: 8.0),
            DropdownButtonFormField<String>(
              value: selectedExercise,
              onChanged: (value) {
                setState(() {
                  selectedExercise = value;
                });
              },
              items: exercises.map((String exercise) {
                return DropdownMenuItem<String>(
                  value: exercise,
                  child: Text(exercise, style: TextStyle(color: Colors.white)),
                );
              }).toList(),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.pink[100],
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.pink[100]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.pink[100]!),
                ),
              ),
              style: TextStyle(color: Colors.black),
              dropdownColor: Colors.pink[100],
            ),
            SizedBox(height: 16.0),
            // Video Placeholder
            if (selectedExercise != null)
              Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      // Full Video Placeholder
                      Container(
                        width: 200,
                        height: 200, // Square box
                        color: Colors.pink[100],
                        child: Center(
                          child: Text(
                            'Video Placeholder',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            SizedBox(height: 16.0),
            // Spacer to push the button to the end
            Spacer()
          ],
        ),
      ),
    );
  }
}
