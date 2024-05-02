import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProgressTracking extends StatefulWidget {
  const ProgressTracking({Key? key}) : super(key: key);

  @override
  _ProgressTrackingState createState() => _ProgressTrackingState();
}

class ChartData {
  final DateTime date;
  double progress; // Make progress mutable

  ChartData(this.date, this.progress);
}

class _ProgressTrackingState extends State<ProgressTracking> {
  // Sample data for progress metrics
  double completionRate = 0.8;
  double accuracy = 0.75;
  double timeTaken = 2.5; // in hours
  List<ChartData> historicalData = [
    ChartData(DateTime(2023, 01, 01), 0.6),
    ChartData(DateTime(2023, 02, 01), 0.7),
    ChartData(DateTime(2023, 03, 01), 0.8),
    ChartData(DateTime(2023, 04, 01), 0.85),
    ChartData(DateTime(2023, 05, 01), 0.9),
  ]; // Sample historical data
  double improvementRate = 0.105; // Sample improvement rate

  @override
  void initState() {
    super.initState();
    fetchImprovementAnalysis(); // Fetch improvement analysis when the widget initializes
  }

  // Method to fetch improvement analysis based on previous games
  Future<void> fetchImprovementAnalysis() async {
    final String apiUrl =
        'https://occ-therapy-backend.onrender.com/api/user/improvement';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String jwtToken = prefs.getString('jwtToken') ?? '';

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $jwtToken',
      },
    );

    if (response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      final String improvement = responseData['improvement'];
      improvementRate = double.parse(improvement.replaceFirst('%', '')) /
          100; // Parse improvement rate
      print('Improvement: $improvement');
      updateGraph(); // Update graph with improvement data
    } else {
      print('Failed to fetch improvement analysis');
      // Handle error response
    }
  }

  // Method to update graph with improvement data
  void updateGraph() {
    setState(() {
      for (int i = 0; i < historicalData.length; i++) {
        // Update progress with improvement rate
        historicalData[i].progress +=
            historicalData[i].progress * improvementRate;
      }
    });
  }

  // Method to fetch details of a particular game
  Future<Map<String, dynamic>> fetchGameDetails(String gameName) async {
    final String apiUrl =
        'https://occ-therapy-backend.onrender.com/api/games/$gameName';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String jwtToken = prefs.getString('jwtToken') ?? '';

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $jwtToken',
      },
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      print('Failed to fetch game details');
      // Handle error response
      return {}; // Return a default value or handle it accordingly
    }
  }

  // Method to fetch details of a specific game for a specific user
  Future<Map<String, dynamic>> fetchGameDetailsForUser(
      String gameName, String userId) async {
    final String apiUrl =
        'https://your-backend-domain.com/api/games/$gameName/user/$userId';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String jwtToken = prefs.getString('jwtToken') ?? '';

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $jwtToken',
      },
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      print('Failed to fetch game details for user');
      // Handle error response
      return {}; // Return a default value or handle it accordingly
    }
  }

  // Method to fetch details of all games played by a specific user across all games
  Future<List<Map<String, dynamic>>> fetchAllGamesForUser(String userId) async {
    final String apiUrl =
        'https://occ-therapy-backend.onrender.com/api/games/user/$userId';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String jwtToken = prefs.getString('jwtToken') ?? '';

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $jwtToken',
      },
    );

    if (response.statusCode == 201) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      print('Failed to fetch all games for user');
      // Handle error response
      return []; // Return a default value or handle it accordingly
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Visual Progress Box
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
                    'Visual Progress',
                    style: TextStyle(color: Colors.white, fontSize: 18.0),
                  ),
                  SizedBox(height: 8.0),
                  LinearProgressIndicator(
                    value: completionRate,
                    color: Colors.green[200],
                    backgroundColor: Colors.grey[700],
                  ),
                ],
              ),
            ),
            SizedBox(height: 26.0),
            // Metrics Box
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
                    'Metrics',
                    style: TextStyle(color: Colors.white, fontSize: 18.0),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Completion Rate: ${(completionRate * 100).toStringAsFixed(0)}%',
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    'Accuracy: ${(accuracy * 100).toStringAsFixed(0)}%',
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    'Time Taken: ${timeTaken.toStringAsFixed(1)} hours',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            SizedBox(height: 26.0),
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
                    primaryXAxis: DateTimeAxis(),
                    series: <LineSeries<ChartData, DateTime>>[
                      LineSeries<ChartData, DateTime>(
                        dataSource: historicalData,
                        xValueMapper: (ChartData data, _) => data.date,
                        yValueMapper: (ChartData data, _) => data.progress,
                        name: 'Progress',
                        color: Colors.green[200],
                        markerSettings: MarkerSettings(isVisible: true),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 26.0),
            ),
          ],
        ),
      ),
    );
  }
}

class ChartData {
  final DateTime date;
  final double progress;

  ChartData(this.date, this.progress);
}
