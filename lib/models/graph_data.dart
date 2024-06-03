import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:mybluetoothapp/models/datatype.dart';
import 'package:mybluetoothapp/models/graph_interval.dart';
import 'package:mybluetoothapp/models/node.dart';

class GraphData {
  DataType? dataType;
  Node? node;
  List<FlSpot>? dataSpots;
  GraphInterval? interval;
  DateTime? startTime;
  DateTime? endTime;
  double? maxY;
  double? minY;
  double? avgY;
  double? maxX;
  double? minX;
  double? avgX;
  List<Color>? gradientColors;
}
