import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CognitiveAbilities extends StatefulWidget {
  @override
  _CognitiveAbilitiesState createState() => _CognitiveAbilitiesState();
}

class _CognitiveAbilitiesState extends State<CognitiveAbilities> {

  int savedScore = 0;
  int savedTimeTaken = 0;
  int savedTrials = 0;
  int savedCorrectGuesses = 0;
  int savedWrongGuesses = 0;

  final List<String> emojis = [
    "assets/images/1.jpeg",
    "assets/images/1.jpeg",
    "assets/images/2.jpeg",
    "assets/images/2.jpeg",
    "assets/images/3.jpeg",
    "assets/images/3.jpeg",
    "assets/images/4.jpeg",
    "assets/images/4.jpeg",
    "assets/images/5.jpeg",
    "assets/images/5.jpeg",
    "assets/images/6.jpeg",
    "assets/images/6.jpeg",
    "assets/images/7.jpeg",
    "assets/images/7.jpeg",
    "assets/images/8.jpeg",
    "assets/images/8.jpeg",
  ];

  late List<String> shuffledEmojis;
  late List<bool> cardFlips;
  int moves = 0;
  int pairsFound = 0;
  int? selectedIndex;
  late Timer timer;
  int seconds = 0;
  int minutes = 0;

  @override
  void initState() {
    super.initState();
    shuffledEmojis = emojis.toList()
      ..shuffle();
    cardFlips = List<bool>.filled(emojis.length, false);
    selectedIndex = null;
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Matching Tiles Game'),
          backgroundColor: Colors.green[200],
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
        backgroundColor: Colors.grey[900],
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
                    color: Colors.green[200],
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

   String _apiUrl = 'https://occ-therapy-backend.onrender.com/api/games/memory-match';
   String _jwtToken = 'Bearer JWT_token'; // Replace with your JWT token
   int _previousGamesLimit = 5; // Limit of previous games to consider

  Future<Map<String, dynamic>> saveGameData(String gameType, Map<String, dynamic> gameData) async {
    try {
      // Fetch previous game data
      final previousData = await fetchPreviousGamesData(gameType);

      final response = await http.post(
        Uri.parse('$_apiUrl$gameType'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$_jwtToken',
        },
        body: jsonEncode(gameData),
      );

      if (response.statusCode == 201) {
        print('$gameType game data saved successfully');
        final responseData = jsonDecode(response.body);
        final message = responseData['message'];

        // Calculate improvement
        double totalImprovement = 0;
        int validGamesCount = 0;
        for (final prevGameData in previousData) {
          if (prevGameData.containsKey('score')) {
            final previousScore = prevGameData['score'] as int;
            final currentScore = gameData['score'] as int;
            final improvement = ((currentScore - previousScore) / previousScore) * 100;
            totalImprovement += improvement;
            validGamesCount++;
          }
        }

        final overallImprovement = validGamesCount > 0 ? (totalImprovement / validGamesCount).toStringAsFixed(2) : 0;

        return {'message': message, 'improvement': '$overallImprovement%'};
      } else {
        print('Failed to save $gameType game data');
        // Handle error response
        return {'error': 'Failed to save $gameType game data'};
      }
    } catch (e) {
      print('Error: $e');
      // Handle network or server error
      return {'error': 'An error occurred while saving game data: $e'};
    }
  }


  Future<List<Map<String, dynamic>>> fetchPreviousGamesData(String gameType) async {
    try {
      final response = await http.get(
        Uri.parse('$_apiUrl$gameType'),
        headers: {
          'Authorization': '$_jwtToken',
        },
      );

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body) as List;
        // Fetch last 5 games data
        final lastGamesData = responseData.sublist(0, _previousGamesLimit);
        return lastGamesData.cast<Map<String, dynamic>>();
      } else {
        print('Failed to fetch $gameType game data');
        // Handle error response
        return [];
      }
    } catch (e) {
      print('Error: $e');
      // Handle network or server error
      return [];
    }
  }

}

