import 'package:flutter/material.dart';
import 'package:apoc_gardens/models/datatype.dart';
import 'package:apoc_gardens/models/graph_interval.dart';
import 'package:apoc_gardens/models/node.dart';

class GraphData {
  DataType? dataType;
  Node? node;
  List<DataSpots> dataSpots = [];
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

class DataSpots {
  final DateTime x;
  final double y;

  DataSpots(this.x, this.y);
}
