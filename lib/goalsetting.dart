import 'package:flutter/material.dart';

class GoalSettingPage extends StatefulWidget {
  const GoalSettingPage({Key? key}) : super(key: key);

  @override
  _GoalSettingPageState createState() => _GoalSettingPageState();
}

class _GoalSettingPageState extends State<GoalSettingPage> {
  TextEditingController goalController = TextEditingController();
  List<Map<String, dynamic>> goalsList = [];

  void addGoal() {
    setState(() {
      String newGoal = goalController.text.trim();
      if (newGoal.isNotEmpty) {
        goalsList.add({'goal': newGoal, 'completed': false});
        goalController.clear();
      }
    });
  }

  void removeGoal(int index) {
    setState(() {
      goalsList.removeAt(index);
    });
  }

  bool allTasksCompleted() {
    return goalsList.every((goal) => goal['completed']);
  }

  void showCompletionPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.green[100],
          title: Text('you\'re done for the day!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Goal Setting'),
        backgroundColor: Colors.deepPurple[200],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: goalController,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                hintText: 'Enter your goal',
                hintStyle: TextStyle(color: Colors.black),
                suffixIcon: IconButton(
                  icon: Icon(Icons.add, color: Colors.black),
                  onPressed: addGoal,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.deepPurple[200]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.deepPurple[200]!),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Your Goals:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8.0),
            Expanded(
              child: ListView.builder(
                itemCount: goalsList.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: Key(goalsList[index]['goal']),
                    onDismissed: (direction) => removeGoal(index),
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      child: Icon(Icons.delete, color: Colors.black),
                    ),
                    child: ListTile(
                      leading: Checkbox(
                        value: goalsList[index]['completed'],
                        onChanged: (value) {
                          setState(() {
                            goalsList[index]['completed'] = value;
                            if (allTasksCompleted()) {
                              showCompletionPopup(context);
                            }
                          });
                        },
                        checkColor: Colors.black,
                        activeColor: Colors.deepPurple[200],
                      ),
                      title: Text(
                        goalsList[index]['goal'],
                        style: TextStyle(color: Colors.black),
                      ),

                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


