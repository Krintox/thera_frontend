import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class GameData {
  final String gameName;
  final double score;
  final String? param1;
  final String? param2;
  final String? param3;
  final int? timeTaken;
  final int? trials;
  final int? correctGuesses;
  final int? wrongGuesses;
  final double? progress;
  final bool? gameOver;
  final String? level;
  final String? secondsLeft;
  final String? figurePath;
  final bool? isTracing;

  GameData({
    required this.gameName,
    required this.score,
    this.param1,
    this.param2,
    this.param3,
    this.timeTaken,
    this.trials,
    this.correctGuesses,
    this.wrongGuesses,
    this.progress,
    this.gameOver,
    this.level,
    this.secondsLeft,
    this.figurePath,
    this.isTracing,
  });
}

class ProgressTracking extends StatefulWidget {
  const ProgressTracking({Key? key}) : super(key: key);

  @override
  _ProgressTrackingState createState() => _ProgressTrackingState();
}

class _ProgressTrackingState extends State<ProgressTracking> {
  List<GameData> historicalData = [];

  @override
  void initState() {
    super.initState();
    // Fetch data when the widget is initialized
    fetchData();
  }

  String? getUserIdFromToken(String jwtToken) {
    Map<String, dynamic>? decodedToken = JwtDecoder.decode(jwtToken);
    if (decodedToken != null && decodedToken.containsKey('userId')) {
      return decodedToken['userId'];
    } else {
      return null;
    }
  }

  Future<void> fetchData() async {
    // Retrieve JWT token from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jwtToken = prefs.getString('jwtToken');

    // Make sure JWT token is not null
    if (jwtToken != null) {
      // Extract user ID from JWT token
      String? userId = getUserIdFromToken(jwtToken);

      if (userId != null) {
        // Make HTTP request to fetch data from your API endpoint
        try {
          final gameDetailsResponse = await http.get(
            Uri.parse('https://occ-therapy-backend.onrender.com/api/games/user/$userId'),
            headers: {'Authorization': 'Bearer $jwtToken'},
          );

          if (gameDetailsResponse.statusCode == 200) {
            // Parse the JSON response
            final List<dynamic> gamesData = json.decode(gameDetailsResponse.body);

            // Log fetched data into the console
            print('Games Data:');
            print(gamesData);

            // Update your UI with the fetched data
            setState(() {
              // Clear previous data
              historicalData.clear();

              // Iterate over each game data and add it to historicalData
              gamesData.forEach((game) {
                String gameName = game['gameName'];
                double score = game['score'].toDouble();

                // Extract unique parameters for each game
                String? param1 = game['param1'];
                String? param2 = game['param2'];
                String? param3 = game['param3'];
                int? timeTaken = game['timeTaken'];
                int? trials = game['trials'];
                int? correctGuesses = game['correctGuesses'];
                int? wrongGuesses = game['wrongGuesses'];
                double? progress = game['progress'];
                bool? gameOver = game['gameOver'];
                String? level = game['level'];
                String? secondsLeft = game['secondsLeft'];
                String? figurePath = game['figurePath'];
                bool? isTracing = game['isTracing'];

                // Create a GameData object for each game
                historicalData.add(
                  GameData(
                    gameName: gameName,
                    score: score,
                    param1: param1,
                    param2: param2,
                    param3: param3,
                    timeTaken: timeTaken,
                    trials: trials,
                    correctGuesses: correctGuesses,
                    wrongGuesses: wrongGuesses,
                    progress: progress,
                    gameOver: gameOver,
                    level: level,
                    secondsLeft: secondsLeft,
                    figurePath: figurePath,
                    isTracing: isTracing,
                  ),
                );
              });
            });
          } else {
            // Handle error if request fails
            print('Failed to load data: ${gameDetailsResponse.statusCode}');
          }
        } catch (e) {
          // Handle network errors
          print('Failed to fetch data: $e');
        }
      } else {
        // Handle case where user ID cannot be extracted from JWT token
        print('Failed to extract user ID from JWT token');
      }
    } else {
      // Handle case where JWT token is null
      print('JWT token not found');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text('Progress Tracking'),
        backgroundColor: Colors.green[200],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Historical Data Box
              Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Historical Data',
                      style: TextStyle(color: Colors.white, fontSize: 18.0),
                    ),
                    SizedBox(height: 8.0),
                    SfCartesianChart(
                      primaryXAxis: CategoryAxis(),
                      series: <LineSeries<GameData, String>>[
                        LineSeries<GameData, String>(
                          dataSource: historicalData,
                          xValueMapper: (GameData data, _) => data.gameName,
                          yValueMapper: (GameData data, _) => data.score,
                          name: 'Score',
                          dataLabelSettings: DataLabelSettings(isVisible: true),
                          color: Colors.green[200],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              // Parameters of Last 5 Responses
              Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Parameters of Last 5 Responses',
                      style: TextStyle(color: Colors.white, fontSize: 18.0),
                    ),
                    SizedBox(height: 8.0),
                    // Display parameters here
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: historicalData.length,
                      itemBuilder: (BuildContext context, int index) {
                        GameData gameData = historicalData[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Game: ${gameData.gameName}',
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              'Score: ${gameData.score}',
                              style: TextStyle(color: Colors.white),
                            ),
                            if (gameData.timeTaken != null)
                              Text(
                                'Time Taken: ${gameData.timeTaken}',
                                style: TextStyle(color: Colors.white),
                              ),
                            if (gameData.trials != null)
                              Text(
                                'Trials: ${gameData.trials}',
                                style: TextStyle(color: Colors.white),
                              ),
                            if (gameData.correctGuesses != null)
                              Text(
                                'Correct Guesses: ${gameData.correctGuesses}',
                                style: TextStyle(color: Colors.white),
                              ),
                            if (gameData.wrongGuesses != null)
                              Text(
                                'Wrong Guesses: ${gameData.wrongGuesses}',
                                style: TextStyle(color: Colors.white),
                              ),
                            if (gameData.progress != null)
                              Text(
                                'Progress: ${gameData.progress}',
                                style: TextStyle(color: Colors.white),
                              ),
                            if (gameData.gameOver != null)
                              Text(
                                'Game Over: ${gameData.gameOver}',
                                style: TextStyle(color: Colors.white),
                              ),
                            if (gameData.level != null)
                              Text(
                                'Level: ${gameData.level}',
                                style: TextStyle(color: Colors.white),
                              ),
                            if (gameData.secondsLeft != null)
                              Text(
                                'Seconds Left: ${gameData.secondsLeft}',
                                style: TextStyle(color: Colors.white),
                              ),
                            if (gameData.figurePath != null)
                              Text(
                                'Figure Path: ${gameData.figurePath}',
                                style: TextStyle(color: Colors.white),
                              ),
                            if (gameData.isTracing != null)
                              Text(
                                'Is Tracing: ${gameData.isTracing}',
                                // style: TextStyle(color: Colors.white),
                              ),
                            SizedBox(height: 8.0),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
