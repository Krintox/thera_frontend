import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
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
  double _accuracyScore = 0;

  @override
  void initState() {
    super.initState();
    _startTimer();
    _figurePath = _generateFigure(_level);
    _currentPath = Path();
    _initializePreferences();
  }

  void _initializePreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
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
    saveGameData(0); // Call saveGameData when the game is over
    // Add logic for displaying "Game Over" screen or transitioning to results
  }
  void _resetGame() {
    setState(() {
      _currentPath.reset();
      _gameOver = false;
      seconds = 0;
      minutes = 0;
      _level = 1;
      _accuracyScore = 0;
      _figurePath = _generateFigure(_level);
    });
  }

  void _nextLevel() {
    setState(() {
      if (_level < 4) {
        _level++;
        _currentPath.reset();
        _figurePath = _generateFigure(_level);
        seconds = 0;
        minutes = 0;
        _accuracyScore = 0;
      } else {
        _gameOver = true;
        saveGameData(0);
         timer?.cancel();
        timer?.cancel();
      }
    });
  }

  void _prevLevel() {
    setState(() {
      if (_level > 1) {
        _level--;
        _currentPath.reset();
        _figurePath = _generateFigure(_level);
        seconds = 0;
        minutes = 0;
        _accuracyScore = 0;
      }
    });
  }

  void _showInstructions() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Instructions'),
          content: Text('Trace the path shown on the screen. Accuracy will be scored on a scale of 1-100.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Start'),
            ),
          ],
        );
      },
    );
  }

  Future<void> saveGameData(double tracedPathLength) async {
    final String apiUrl =
        'https://occ-therapy-backend.onrender.com/api/games/trace-path'; // API URL
    final String jwtToken =
        _prefs?.getString('jwtToken') ?? ''; // Fetch JWT token from SharedPreferences

    final Map<String, dynamic> gameData = {
      'score': minutes * 60 + seconds, // Time taken in seconds
      'accuracy': _accuracyScore,
      'progress': tracedPathLength,
      'gameOver': _gameOver,
      'level': _level,
      'secondsLeft': _secondsLeft,
      'figurePath': _figurePath.toString(), // Convert Path to string for storage
      'isTracing': _isTracing,
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
      print('Trace the Path game data saved successfully');
    } else {
      print('Failed to save Trace the Path game data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trace the Path - Level $_level'),
        backgroundColor: Colors.yellow[100],
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _resetGame,
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: GestureDetector(
              onPanStart: (details) {
                setState(() {
                  _isTracing = true;
                  _currentPath.moveTo(
                    details.localPosition.dx,
                    details.localPosition.dy,
                  );
                });
              },
              onPanUpdate: (details) {
                if (_isTracing) {
                  setState(() {
                    _currentPath.lineTo(
                      details.localPosition.dx,
                      details.localPosition.dy,
                    );
                  });
                }
              },
              onPanEnd: (details) {
                setState(() {
                  _isTracing = false;
                  if (_checkWinCondition()) {
                    _nextLevel();
                  }
                });
              },
              child: CustomPaint(
                painter: SymbolPainter(
                  symbolPath: _figurePath,
                  tracePath: _currentPath,
                ),
                size: Size.infinite,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.grey[300],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: _prevLevel,
                      child: Text('Prev Level'),
                    ),
                    SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: _nextLevel,
                      child: Text('Next Level'),
                    ),
                    SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: _showInstructions,
                      child: Text('Instructions'),
                    ),
                  ],
                ),
                Text(
                  'Time: $minutes:$seconds',
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  'Accuracy: ${_accuracyScore.toStringAsFixed(2)}%',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool _checkWinCondition() {
    if (_level == 1) {
      // For simplicity, we assume the user wins if the current path matches the figure path.
      // In a real game, you would implement a more accurate win condition.
      bool isMatching = _currentPath == _figurePath;
      _accuracyScore = isMatching ? 100 : 0;
      return isMatching;
    } else {
      // Check if the traced path length is close to the figure path length
      double figureLength = _measurePathLength(_figurePath);
      double tracedLength = _measurePathLength(_currentPath);
      if ((tracedLength / figureLength) > 0.8) {
        saveGameData(tracedLength); // Call saveGameData when the user wins
        return true;
      } else {
        return false;
      }
      double accuracy = (tracedLength / figureLength) * 100;
      _accuracyScore = accuracy.clamp(0, 100);
      return accuracy > 80; // 80% similarity threshold
    }
  }

  double _measurePathLength(Path path) {
    final metrics = path.computeMetrics();
    double length = 0.0;
    for (final metric in metrics) {
      length += metric.length;
    }
    return length;
  }

  Path _generateFigure(int level) {
    switch (level) {
      case 1:
        return Path()
          ..moveTo(50, 50)
          ..lineTo(250, 50)
          ..lineTo(250, 250)
          ..lineTo(50, 250)
          ..close();
      case 2:
        return Path()
          ..moveTo(50, 50)
          ..lineTo(100, 150)
          ..quadraticBezierTo(150, 100, 200, 150)
          ..lineTo(250, 250)
          ..lineTo(150, 200)
          ..lineTo(50, 250)
          ..close();
      case 3:
        return _generateQuadraticBezierWithLineAndStud();
      case 4:
        return _generateComplexFigureWithStud();
      default:
        return Path();
    }
  }

  Path _generateQuadraticBezierWithLineAndStud() {
    Path path = Path();
// Move to the starting point
    path.moveTo(50, 150);

    // Add quadratic bezier curve
    path.quadraticBezierTo(150, 50, 250, 150);

    // Add a line segment
    path.lineTo(250, 250);

    // Add a "stud"
    path.addOval(Rect.fromCircle(center: Offset(150, 250), radius: 20));

    return path;
  }

  Path _generateComplexFigureWithStud() {
    Path path = Path();
    // Move to the starting point
    path.moveTo(50, 150);

    // Add multiple curves and lines
    path.quadraticBezierTo(150, 50, 250, 150);
    path.lineTo(250, 250);
    path.cubicTo(200, 200, 150, 300, 100, 250);
    path.quadraticBezierTo(50, 200, 50, 150);

    // Add a second complex shape
    path.moveTo(150, 100);
    path.lineTo(200, 50);
    path.cubicTo(250, 100, 250, 200, 200, 250);
    path.quadraticBezierTo(150, 300, 100, 250);
    path.cubicTo(50, 200, 50, 100, 100, 100);
    path.close();

    // Add a "stud" for both shapes
    path.addOval(Rect.fromCircle(center: Offset(150, 150), radius: 20));
    path.addOval(Rect.fromCircle(center: Offset(150, 200), radius: 20));

    return path;
  }
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

class SymbolPainter extends CustomPainter {
  final Path symbolPath;
  final Path tracePath;

  const SymbolPainter({required this.symbolPath, required this.tracePath});

  @override
  void paint(Canvas canvas, Size size) {
    final symbolPaint = Paint()
      ..color = Colors.green
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;

    canvas.drawPath(symbolPath, symbolPaint);

    final tracePaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    canvas.drawPath(tracePath, tracePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
    }
}

