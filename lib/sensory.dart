import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SoundMatchingGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.lightGreen[200],
          title: Text('Sensory Integration'),
        ),
        body: SoundMatchingGameScreen(),
      ),
    );
  }
}

class SoundMatchingGameScreen extends StatefulWidget {
  @override
  _SoundMatchingGameScreenState createState() =>
      _SoundMatchingGameScreenState();
}

class _SoundMatchingGameScreenState extends State<SoundMatchingGameScreen> {
  List<String> soundOptions = ['notes_1', 'notes_2', 'notes_3', 'notes_4'];
  List<String> shuffledOptions = [];
  String selectedSound1 = '';
  String selectedSound2 = '';
  late Timer timer;
  int seconds = 0;
  int minutes = 0;

  @override
  void initState() {
    super.initState();
    shuffledOptions = List.from(soundOptions)..shuffle();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      showStartPopup();
    });
  }

  void showStartPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Instructions'),
          content: Text('Click on sounds to listen and match them'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                startTimer();
              },
              child: Text('Start'),
            ),
          ],
        );
      },
    );
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        seconds++;
        if (seconds == 60) {
          minutes++;
          seconds = 0;
        }
      });
    });
  }

  void selectSound1(String sound) {
    setState(() {
      selectedSound1 = sound;
    });
  }

  void selectSound2(String sound) {
    setState(() {
      selectedSound2 = sound;
    });
  }

void checkMatch() {
  if (selectedSound1.isNotEmpty && selectedSound2.isNotEmpty) {
    if (selectedSound1 == selectedSound2) {
      int totalTimeInSeconds = minutes * 60 + seconds;
      // Call the method to save the game data here if needed
      saveSoundMatchingGameData(totalTimeInSeconds);
    } else {
      print('No match found!');
    }
  } else {
    print('Please select sounds in both columns to check match.');
  }
}



  Future<void> saveSoundMatchingGameData(int timeTaken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jwtToken = prefs.getString('jwtToken');

    if (jwtToken == null) {
      print('JWT token not found!');
      return;
    }

    final response = await http.post(
      Uri.parse('https://occ-therapy-backend.onrender.com/api/games/sound-matching'),
      headers: {
        'Authorization': 'Bearer $jwtToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'score': timeTaken,
        'param1': 'game1',
        'param2': 'game2',
        'param3': 'game3',
      }),
    );

    if (response.statusCode == 201) {
      print('Sound Matching game data saved successfully');
    } else {
      print('Failed to save Sound Matching game data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Sound Matching Game',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Time: $minutes:$seconds',
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: soundOptions.map((sound) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: SoundOptionCard(
                      sound: sound,
                      onSelectSound: selectSound1,
                      isSelected: selectedSound1 == sound,
                      label: sound, // Pass the sound as label for now
                    ),
                  );
                }).toList(),
              ),
              Column(
                children: List.generate(shuffledOptions.length, (index) {
                  final sound = shuffledOptions[index];
                  final soundLabel = String.fromCharCode(index + 65);
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: SoundOptionCard(
                      sound: sound,
                      onSelectSound: selectSound2,
                      isSelected: selectedSound2 == sound,
                      label: soundLabel,
                    ),
                  );
                }),
              ),
            ],
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (selectedSound1 == 'notes_1' &&
                  selectedSound2 == 'notes_1') {
                checkMatch();
              } else {
                print('Please match all options before checking.');
              }
            },
            child: Text('Check Match'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}

class SoundOptionCard extends StatelessWidget {
  final String sound;
  final Function(String) onSelectSound;
  final bool isSelected;
  final String label;

  const SoundOptionCard({
    Key? key,
    required this.sound,
    required this.onSelectSound,
    required this.isSelected,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onSelectSound(sound);
        playSound(sound); // Call playSound here
      },
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? Colors.lightGreen[200] : Colors.lightGreen[300],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 10),
            Text(
              sound,
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }


  void playSound(String sound) async {
    final player = AudioPlayer();
    await player.play(AssetSource('assets/sounds/asset_note1.wav'));
  }

}
