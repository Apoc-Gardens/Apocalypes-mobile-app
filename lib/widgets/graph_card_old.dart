import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:apoc_gardens/models/graph_data.dart';

@Deprecated('Use GraphCard instead')
class GraphCardOld extends StatelessWidget {
  final GraphData graphData;

  const GraphCardOld({super.key, required this.graphData});

  @override
  Widget build(BuildContext context) {
    return Card.outlined(
        color: Colors.white,
        child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(graphData.dataType!.name,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                Text(graphData.dataType!.description,
                    style: const TextStyle(fontSize: 12)),
                const Divider(
                  height: 30,
                  thickness: 1,
                  color: Colors.grey,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: AspectRatio(
                    aspectRatio: 2,
                    child: LineChart(graph()),
                  ),
                )
              ],
            )));
  }

  LineChartData graph() {
    return LineChartData(
      gridData: const FlGridData(
        show: false,
      ),
      lineTouchData: const LineTouchData(
        enabled: true,
        touchTooltipData: LineTouchTooltipData(),
      ),
      titlesData: const FlTitlesData(show: false),
      borderData: FlBorderData(
        show: false,
      ),
      minX: graphData.minX,
      maxX: graphData.maxX,
      minY: graphData.minY,
      maxY: graphData.maxY,
      lineBarsData: [
        LineChartBarData(
          spots: graphData.dataSpots!
              .map((dataSpot) => FlSpot(dataSpot.x.millisecond as double, dataSpot.y))
              .toList(),
          isCurved: false,
          gradient: LinearGradient(
            colors: graphData.gradientColors ??
                const [Colors.blue, Colors.blueAccent],
          ),
          barWidth: 4,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: true,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: graphData.gradientColors
                      ?.map((color) => color.withOpacity(0.2))
                      .toList() ??
                  const [Colors.blue, Colors.blueAccent]
                      .map((color) => color.withOpacity(0.3))
                      .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
