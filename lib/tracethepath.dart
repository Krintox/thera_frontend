import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert'; // Add this import for JSON encoding
import 'package:http/http.dart'
    as http; // Add this import for making HTTP requests
import 'package:shared_preferences/shared_preferences.dart'; // Add this import for SharedPreferences
import 'dart:math';

void main() {
  runApp(TraceThePath());
}

class TraceThePath extends StatefulWidget {
  @override
  _TraceThePath createState() => _TraceThePath();
}

class _TraceThePath extends State<TraceThePath> {
  Path _figurePath = Path(); // Path for the figure
  Path _currentPath = Path(); // Path for the user's tracing
  bool _isTracing = false;
  bool _gameOver = false;
  int _level = 1;
  Timer? timer;
  int seconds = 0;
  int minutes = 0;
  int _secondsLeft = 0; // Change as needed
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    startTimer();
    _figurePath = _generateFigure(_level); // Generate the figure path
    _initializePreferences();
    _loadGameData(); // Load saved game data during initialization
  }

  void _initializePreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
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

  void gameOver() {
    setState(() {
      _gameOver = true;
    });
    // Add logic for displaying "Game Over" screen or transitioning to results
  }

  void resetGame() {
    setState(() {
      _currentPath = Path();
      _isTracing = false;
      _gameOver = false;
      _secondsLeft = 0;
      _level = 1;
      _figurePath = _generateFigure(_level);
    });
    saveGameData(); // Save game data when resetting the game
  }

  class GameDataService {
  static const String apiUrl = 'https://occ-therapy-backend.onrender.com/api/games/trace-path';
  static const String jwtToken = 'Bearer JWT_token'; // Replace with your JWT token
  static const int previousGamesLimit = 5; // Limit of previous games to consider

  Future<Map<String, dynamic>> saveGameData(Map<String, dynamic> gameData) async {
  try {
  // Fetch previous game data
  final previousData = await fetchPreviousGamesData();

  final response = await http.post(
  Uri.parse(apiUrl),
  headers: {
  'Content-Type': 'application/json',
  'Authorization': 'Bearer $jwtToken',
  },
  body: jsonEncode(gameData),
  );

  if (response.statusCode == 201) {
  print('Trace the Path game data saved successfully');
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
  print('Failed to save Trace the Path game data');
  // Handle error response
  return null;
  }
  } catch (e) {
  print('Error: $e');
  // Handle network or server error
  return null;
  }
  }

  Future<List<Map<String, dynamic>>> fetchPreviousGamesData() async {
  try {
  final response = await http.get(
  Uri.parse(apiUrl),
  headers: {
  'Authorization': 'Bearer $jwtToken',
  },
  );

  if (response.statusCode == 200) {
  final responseData = jsonDecode(response.body) as List;
  // Fetch last 5 games data
  final lastGamesData = responseData.sublist(0, previousGamesLimit);
  return lastGamesData.cast<Map<String, dynamic>>();
  } else {
  print('Failed to fetch Trace the Path game data');
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

  Path _parseSvgPath(String pathString) {
    final path = Path();
    // Use your own logic to parse the SVG path string here
    return path;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey[900],
        appBar: AppBar(
          backgroundColor: Colors.green[200],
          title: Text('Trace the Symbol - Level $_level'),
          actions: [
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: resetGame,
            ),
            IconButton(
              icon: Icon(Icons.info),
              onPressed: () {
                // Show instructions popup
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: Colors.green[200], // Set background color
                    title: Text('Instructions'),
                    content: Text(
                      'Trace the symbol without lifting your finger.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('OK'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
          bottom: PreferredSize(
            preferredSize:
                Size.fromHeight(40.0), // Set the height of the PreferredSize
            child: Center(
              child: Text(
                "Time: $minutes:$seconds",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                ),
              ),
            ),
          ),
        ),
        body: Center(
          child: Stack(
            children: [
              // Symbol drawing
              CustomPaint(
                size: Size(MediaQuery.of(context).size.width * 0.8,
                    MediaQuery.of(context).size.height * 0.5),
                painter: SymbolPainter(symbolPath: _figurePath),
              ),
              // Tracing area with instructions
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    'Trace the symbol without lifting your finger.',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onPanStart: (details) {
                  setState(() {
                    if (_gameOver) return;
                    _isTracing = true;
                    _currentPath = Path(); // Clear the user's tracing path
                    _currentPath.moveTo(
                        details.localPosition.dx, details.localPosition.dy);
                  });
                },
                onPanUpdate: (details) {
                  setState(() {
                    if (_gameOver) return;
                    _currentPath.lineTo(
                        details.localPosition.dx, details.localPosition.dy);
                  });
                },
                onPanEnd: (details) async {
                  setState(() {
                    _isTracing = false;
                    if (!_gameOver && _checkWinCondition()) {
                      _level++;
                      if (_level <= 3) {
                        _figurePath = _generateFigure(
                            _level); // Generate the new figure path
                        _secondsLeft = 0; // Reset timer for the next level
                        startTimer(); // Start timer for the next level
                      } else {
                        // Game completed
                        gameOver();
                        // Add logic to display
                      }
                    }
                  });
                  // Calculate length of traced path
                  double tracedPathLength = calculatePathLength(_currentPath);
                  // Save
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: Stack(
                    children: [
                      // Traced path
                      CustomPaint(
                        size: Size.infinite,
                        painter: PathPainter(
                            path: _currentPath,
                            strokeWidth: 5.0), // Set stroke width to 5.0
                      ),
                      // Game over message
                      if (_gameOver)
                        Center(
                          child: Text(
                            'Game Over!',
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _checkWinCondition() {
    // Implement logic to check if the traced path meets the figure
    // For now, we'll just return true after a few seconds to simulate winning
    Future.delayed(Duration(seconds: 3), () {
      setState(() {});
    });
    return true;
  }

  Path _generateFigure(int level) {
    switch (level) {
      case 1:
        return Path()
          ..moveTo(100, 100)
          ..lineTo(200, 100)
          ..lineTo(200, 200)
          ..lineTo(100, 200)
          ..lineTo(100, 150)
          ..lineTo(150, 150)
          ..lineTo(150, 200)
          ..close(); // Square
      case 2:
        return Path()
          ..moveTo(100, 100)
          ..quadraticBezierTo(150, 50, 200, 100) // Custom curved path
          ..quadraticBezierTo(250, 150, 200, 200)
          ..quadraticBezierTo(150, 250, 100, 200)
          ..quadraticBezierTo(50, 150, 100, 100)
          ..quadraticBezierTo(150, 150, 200, 150)
          ..quadraticBezierTo(250, 100, 200, 50)
          ..quadraticBezierTo(150, 0, 100, 50)
          ..quadraticBezierTo(50, 100, 100, 150)
          ..lineTo(150, 150)
          ..lineTo(150, 200)
          ..close(); // Custom curved shape with more curves
      case 3:
        return Path()
          ..moveTo(100, 100)
          ..lineTo(200, 100)
          ..lineTo(200, 200)
          ..lineTo(100, 200)
          ..lineTo(100, 150)
          ..lineTo(150, 150)
          ..lineTo(150, 200)
          ..lineTo(200, 200)
          ..lineTo(200, 250)
          ..lineTo(150, 250)
          ..lineTo(150, 200)
          ..lineTo(100, 200)
          ..lineTo(100, 250)
          ..lineTo(50, 250)
          ..lineTo(50, 200)
          ..lineTo(100, 200)
          ..lineTo(100, 150)
          ..lineTo(50, 150)
          ..lineTo(50, 100)
          ..lineTo(100, 100)
          ..quadraticBezierTo(150, 50, 200, 100) // Custom curved path
          ..quadraticBezierTo(250, 150, 200, 200)
          ..quadraticBezierTo(150, 250, 100, 200)
          ..quadraticBezierTo(50, 150, 100, 100)
          ..close(); // Complex shape with more lines and curves
      case 4:
        return _generateComplexFigure();
      default:
        return Path(); // Empty path for levels beyond 4
    }
  }

  Path _generateComplexFigure() {
    Path path = Path();

    // Random number generator for creating varying shapes
    Random random = Random();

    // Move to a random starting point within the canvas bounds
    path.moveTo(random.nextDouble() * 400, random.nextDouble() * 300);

    // Generate a series of random curves, lines, and shapes
    for (int i = 0; i < 10; i++) {
      double controlX1 = random.nextDouble() * 400;
      double controlY1 = random.nextDouble() * 300;
      double controlX2 = random.nextDouble() * 400;
      double controlY2 = random.nextDouble() * 300;
      double endX = random.nextDouble() * 400;
      double endY = random.nextDouble() * 300;

      // Randomly choose between quadratic and cubic Bezier curves
      if (random.nextBool()) {
        path.quadraticBezierTo(controlX1, controlY1, endX, endY);
      } else {
        path.cubicTo(controlX1, controlY1, controlX2, controlY2, endX, endY);
      }
    }

    // Close the path to create a closed shape
    path.close();

    return path;
  }

  // Function to calculate the length of a path
  double calculatePathLength(Path path) {
    final metrics = path.computeMetrics();
    double length = 0.0;
    for (final metric in metrics) {
      length += metric.length;
    }
    return length;
  }
}

class SymbolPainter extends CustomPainter {
  final Path symbolPath;

  const SymbolPainter({required this.symbolPath});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green[200]!
      ..strokeWidth = 5.0
      ..style = PaintingStyle.stroke;

    canvas.drawPath(symbolPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class PathPainter extends CustomPainter {
  final Path path;
  final double strokeWidth;

  const PathPainter(
      {required this.path,
      this.strokeWidth = 1.0}); // Default stroke width set to 1.0

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    canvas.drawPath(path, paint); // Draw the traced path in red
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
