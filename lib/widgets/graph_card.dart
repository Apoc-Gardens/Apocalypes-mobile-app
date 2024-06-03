import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:mybluetoothapp/models/graph_data.dart';

class GraphCard extends StatelessWidget {
  final GraphData graphData;
  const GraphCard({super.key, required this.graphData});

  @override
  Widget build(BuildContext context) {
    return Card.outlined(
        color: Colors.white,
        child: Padding(
            padding: const EdgeInsets.all(
              20.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(graphData.dataType!.name,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                Text(graphData.dataType!.information, style: const TextStyle(fontSize: 12)),
                const Divider(
                  height: 30,
                  thickness: 1,
                  color: Colors.grey,
                ),
                AspectRatio(
                  aspectRatio: 4,
                  child: LineChart(graph()),
                ),
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
          spots: graphData.dataSpots!,
          isCurved: true,
          gradient: const LinearGradient(
            colors: [Colors.black, Colors.black],
          ),
          barWidth: 4,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: true,
          ),
          belowBarData: BarAreaData(
            show: false,
            gradient: const LinearGradient(
              colors: [Colors.black, Colors.black],
            ),
          ),
        ),
      ],
    );
  }
}
