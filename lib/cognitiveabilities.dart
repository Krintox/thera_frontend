import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CognitiveAbilities extends StatefulWidget {
  @override
  _CognitiveAbilitiesState createState() => _CognitiveAbilitiesState();
}

class _CognitiveAbilitiesState extends State<CognitiveAbilities> {
  final List<String> emojis = [
    "assets/images/1.jpg",
    "assets/images/1.jpg",
    "assets/images/2.jpg",
    "assets/images/2.jpg",
    "assets/images/3.jpg",
    "assets/images/3.jpg",
    "assets/images/4.jpg",
    "assets/images/4.jpg",
    "assets/images/5.jpg",
    "assets/images/5.jpg",
    "assets/images/6.jpg",
    "assets/images/6.jpg",
    "assets/images/7.jpg",
    "assets/images/7.jpg",
    "assets/images/8.jpg",
    "assets/images/8.jpg",
  ];

  late List<String> shuffledEmojis;
  late List<bool> cardFlips;
  int moves = 0;
  int pairsFound = 0;
  int? selectedIndex;
  late Timer timer;
  int seconds = 0;
  int minutes = 0;
  bool showInstructions = false; // Track if instructions dialog should be shown

  @override
  void initState() {
    super.initState();
    shuffledEmojis = emojis.toList()
      ..shuffle();
    cardFlips = List<bool>.filled(emojis.length, false);
    selectedIndex = null;
    startTimer();
    showInstructionsDialog(context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Matching Tiles Game'),
          backgroundColor: Colors.lightBlue[200],
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(40.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Time: $minutes:$seconds"),
                Text("Moves: $moves"),
                Text("Pairs Found: $pairsFound"),
              ],
            ),
          ),
        ),
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
              ),
              itemCount: emojis.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () => handleCardTap(index),
                  child: Card(
                    color: Colors.lightBlue[200],
                    child: Center(
                      child: cardFlips[index]
                          ? Image.asset(
                        shuffledEmojis[index],
                        width: 50,
                        height: 50,
                      )
                          : Text(''),
                    ),
                  ),
                );
              },
            ),
            ElevatedButton(
              onPressed: resetGame,
              child: Text("Reset"),
            ),
          ],
        ),
      ),
    );
  }

  void handleCardTap(int index) {
    if (cardFlips[index]) return;

    setState(() {
      cardFlips[index] = true;
      if (selectedIndex != null) {
        moves++;
        if (shuffledEmojis[selectedIndex!] == shuffledEmojis[index]) {
          pairsFound++;
          selectedIndex = null;
          if (pairsFound == emojis.length ~/ 2) {
            // All pairs found, show win message or perform any desired action
          }
        } else {
          Future.delayed(Duration(milliseconds: 500), () {
            cardFlips[selectedIndex!] = false;
            cardFlips[index] = false;
            setState(() {});
            selectedIndex = null;
          });
        }
      } else {
        selectedIndex = index;
      }
    });
  }

  void resetGame() async {
    // Save game data to the backend
    await saveGameData();

    setState(() {
      shuffledEmojis = emojis.toList()
        ..shuffle();
      cardFlips = List<bool>.filled(emojis.length, false);
      moves = 0;
      pairsFound = 0;
      selectedIndex = null;
      seconds = 0;
      minutes = 0;
    });
    startTimer();
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

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  // Function to save game data to the backend
  Future<void> saveGameData() async {
    final String apiUrl = 'https://occ-therapy-backend.onrender.com/api/games/memory-match';

    // Fetch JWT token from shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String jwtToken = prefs.getString('jwtToken') ?? '';
    int totalTimeInSeconds = minutes * 60 + seconds;

    final Map<String, dynamic> gameData = {
      'score': pairsFound,
      // Assuming pairs found represents the score
      'timeTaken': totalTimeInSeconds,
      'trials': moves,
      // Assuming moves represents the number of trials
      'correctGuesses': pairsFound,
      // Assuming pairs found represents correct guesses
      'wrongGuesses': moves - pairsFound,
      // Assuming moves - pairs found represents wrong guesses
      // Add other parameters as needed
    };


    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $jwtToken',
      },
      body: jsonEncode(gameData),
    );

    if (response.statusCode == 201) {
      print('Memory Match game data saved successfully');
    } else {
      print('Failed to save Memory Match game data');
    }
  }

 void showInstructionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Game Instructions"),
          content: Text(
              "Match pairs of tiles by flipping them over two at a time."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }
}
}
