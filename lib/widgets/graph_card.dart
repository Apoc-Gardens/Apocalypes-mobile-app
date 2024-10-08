import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../models/graph_data.dart';

class GraphCard extends StatelessWidget {
  final GraphData graphData;
  const GraphCard({super.key, required this.graphData});

  @override
  Widget build(BuildContext context) {
    return Card.outlined(
        color: Colors.white,
        child: Padding(
            padding:
                const EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 0),
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
                AspectRatio(aspectRatio: 3 / 2, child: graph())
              ],
            )));
  }

  SfCartesianChart graph() {
    int? lastIndex;
    return SfCartesianChart(
      onTrackballPositionChanging: (TrackballArgs args){
        if (args.chartPointInfo.dataPointIndex != lastIndex) {
          HapticFeedback.lightImpact();
          lastIndex = args.chartPointInfo.dataPointIndex;
        }
      },
      trackballBehavior: TrackballBehavior(
        // Enables the trackball
          enable: true,
          tooltipAlignment: ChartAlignment.near,
          tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
          tooltipSettings: InteractiveTooltip(
              enable: true,
              format: 'point.y${graphData.dataType?.unit}',
          )
      ),
        primaryXAxis: DateTimeAxis(),
        primaryYAxis: NumericAxis(),
        zoomPanBehavior: ZoomPanBehavior(
          enablePinching: true,
          zoomMode: ZoomMode.x,
          enablePanning: true,
        ),
        // tooltipBehavior: TooltipBehavior(
        //     enable: true,
        //     header: graphData.dataType?.name,
        //     format: 'point.x: point.y${graphData.dataType?.unit}'),
        series: <CartesianSeries>[
          SplineSeries<DataSpots, DateTime>(
            color: const Color(0xFF0AA061),
              dataSource: graphData.dataSpots,
              xValueMapper: (DataSpots data, _) => data.x,
              yValueMapper: (DataSpots data, _) => data.y,
              width: 3.0,
              splineType: SplineType.monotonic,
              markerSettings: const MarkerSettings(isVisible: true),
              enableTooltip: true),
        ]);
  }
}
