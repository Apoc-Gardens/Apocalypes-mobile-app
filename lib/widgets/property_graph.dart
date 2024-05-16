import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class Chart extends StatefulWidget {
  const Chart({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ChartState createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  List<Color> gradientColors = [
    const Color.fromARGB(255, 202, 29, 29),
    const Color.fromARGB(255, 200, 131, 82),
  ];
  String heading = "Humidity";
  String informationBody =
      "Plays a crucial role in agriculture by influencing plant growth, transpiration, and the development of pests and diseases.";

  static const dataSpots = [
    FlSpot(0, 3),
    FlSpot(1, 3.5),
    FlSpot(2, 5),
    FlSpot(3, 4.6),
    FlSpot(4, 5),
    FlSpot(5, 4.9),
    FlSpot(6, 5.2),
    FlSpot(7, 4.8),
    FlSpot(8, 5.3),
    FlSpot(9, 5.5),
    FlSpot(10, 5.25),
    FlSpot(11, 5.8),
    FlSpot(12, 5.6),
    FlSpot(13, 5.9),
    FlSpot(14, 5.4),
    FlSpot(15, 5.6),
    FlSpot(16, 5.8),
    FlSpot(17, 5.9),
    FlSpot(18, 5.4),
    FlSpot(19, 5.6),
    FlSpot(20, 5.8),
    FlSpot(21, 5.9),
    FlSpot(22, 5.4),
    FlSpot(23, 5.6),
    FlSpot(24, 5.8),
  ];

  bool showAvg = false;

  @override
  Widget build(BuildContext context) {
    return Card.outlined(
        color: Colors.white,
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(heading,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text(informationBody, style: const TextStyle(fontSize: 14)),
                AspectRatio(
                  aspectRatio: 1.70,
                  child: LineChart(mainData()),
                ),
              ],
            )));
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: const FlGridData(
        show: false,
      ),
      lineTouchData: const LineTouchData(enabled: true),
      titlesData: const FlTitlesData(show: false),
      borderData: FlBorderData(
        show: false,
      ),
      minX: 0,
      maxX: 24,
      minY: 0,
      maxY: 8,
      lineBarsData: [
        LineChartBarData(
          spots: dataSpots,
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 4,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: true,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.1))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
