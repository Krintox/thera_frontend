import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:math';

class ProgressTracking extends StatefulWidget {
  const ProgressTracking({Key? key}) : super(key: key);

  @override
  _ProgressTrackingState createState() => _ProgressTrackingState();
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



