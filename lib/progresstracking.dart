import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class GameData {
  final String gameName;
  final double score;
  final double progress;
  final bool gameOver;
  final int? timeTaken;
  final int? trials;
  final int? correctGuesses;
  final int? wrongGuesses;
  final String? param1;
  final String? param2;
  final String? param3;
  final String? level;
  final String? secondsLeft;
  final String? figurePath;
  final bool? isTracing;

  GameData({
    required this.gameName,
    required this.score,
    required this.progress,
    required this.gameOver,
    this.timeTaken,
    this.trials,
    this.correctGuesses,
    this.wrongGuesses,
    this.param1,
    this.param2,
    this.param3,
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
  List<GameData> memoryMatchData = [];
  List<GameData> soundMatchingData = [];
  List<GameData> traceThePathData = [];

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

            // Clear previous data
            memoryMatchData.clear();
            soundMatchingData.clear();
            traceThePathData.clear();

            // Iterate over each game data and add it to the respective lists
            gamesData.forEach((game) {
              String gameName = game['gameName'] ?? '';
              double score = (gameName == 'memory-match' || gameName == 'sound-matching') ? double.tryParse(game['score'].toString()) ?? 0.0 : 0.0;
              double progress = double.tryParse(game['progress'].toString()) ?? 0.0;
              bool gameOver = game['gameOver'] ?? false;
              String? level = game['level'];
              String? secondsLeft = game['secondsLeft'];
              String? figurePath = game['figurePath'];
              bool? isTracing = game['isTracing'];

              // Add conditionals for specific game parameters
              if (gameName == 'memory-match') {
                int? timeTaken = game['timeTaken'];
                int? trials = game['trials'];
                int? correctGuesses = game['correctGuesses'];
                int? wrongGuesses = game['wrongGuesses'];
                // Create a GameData object for memory match
                memoryMatchData.add(
                  GameData(
                    gameName: gameName,
                    score: score,
                    progress: progress,
                    gameOver: gameOver,
                    timeTaken: timeTaken,
                    trials: trials,
                    correctGuesses: correctGuesses,
                    wrongGuesses: wrongGuesses,
                    level: level,
                    secondsLeft: secondsLeft,
                    figurePath: figurePath,
                    isTracing: isTracing,
                  ),
                );
              } else if (gameName == 'sound-matching') {
                String? param1 = game['param1'];
                String? param2 = game['param2'];
                String? param3 = game['param3'];
                // Create a GameData object for sound matching
                soundMatchingData.add(
                  GameData(
                    gameName: gameName,
                    score: score,
                    progress: progress,
                    gameOver: gameOver,
                    param1: param1,
                    param2: param2,
                    param3: param3,
                    level: level,
                    secondsLeft: secondsLeft,
                    figurePath: figurePath,
                    isTracing: isTracing,
                  ),
                );
              } else if (gameName == 'trace-path') {
                // Create a GameData object for trace the path
                traceThePathData.add(
                  GameData(
                    gameName: gameName,
                    score: score,
                    progress: progress,
                    gameOver: gameOver,
                    level: level,
                    secondsLeft: secondsLeft,
                    figurePath: figurePath,
                    isTracing: isTracing,
                  ),
                );
              }
            });
            // Update the UI after fetching data
            setState(() {});
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Progress Tracking'),
        backgroundColor: Colors.yellow[200],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Memory Match Chart
              if (memoryMatchData.isNotEmpty)
                _buildGameChart(
                  gameName: 'memory-match',
                  gameData: memoryMatchData,
                ),
              SizedBox(height: 20),
              // Sound Matching Chart
              if (soundMatchingData.isNotEmpty)
                _buildGameChart(
                  gameName: 'sound-matching',
                  gameData: soundMatchingData,
                ),
              SizedBox(height: 20),
              // Trace The Path Chart
              if (traceThePathData.isNotEmpty)
                _buildGameChart(
                  gameName: 'trace-path',
                  gameData: traceThePathData,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGameChart({
    required String gameName,
    required List<GameData> gameData,
  }) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$gameName Progress',
            style: TextStyle(color: Colors.white, fontSize: 18.0),
          ),
          SizedBox(height: 8.0),
          SfCartesianChart(
            primaryXAxis: CategoryAxis(),
            series: <LineSeries<GameData, String>>[
              LineSeries<GameData, String>(
                dataSource: gameData,
                xValueMapper: (GameData data, _) => data.progress.toString(),
                yValueMapper: (GameData data, _) => data.score,
                name: 'Score',
                dataLabelSettings: DataLabelSettings(isVisible: true),
                color: Colors.green[200],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
