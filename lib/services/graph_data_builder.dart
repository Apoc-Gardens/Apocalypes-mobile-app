import 'dart:math';
import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
import 'package:mybluetoothapp/dao/data_dao.dart';
import 'package:mybluetoothapp/daoImpl/data_dao_impl.dart';
import 'package:mybluetoothapp/models/datatype.dart';
import 'package:mybluetoothapp/models/graph_data.dart';
import 'package:mybluetoothapp/models/graph_interval.dart';
import 'package:mybluetoothapp/models/data.dart';
import 'package:mybluetoothapp/models/node.dart';

class GraphBuilder {
  final GraphData _graphData = GraphData();

  bool _isCustomInterval = false;

  GraphBuilder setGraphInterval(GraphInterval interval) {
    switch (interval) {
      case GraphInterval.LastTwentyFourHours:
        _graphData
          ..startTime = DateTime.now().subtract(const Duration(days: 1))
          ..endTime = DateTime.now()
          ..interval = GraphInterval.LastTwentyFourHours;
        break;

      case GraphInterval.LastSevenDays:
        _graphData
          ..startTime = DateTime.now().subtract(const Duration(days: 7))
          ..endTime = DateTime.now()
          ..interval = GraphInterval.LastSevenDays;
        break;

      case GraphInterval.LastThirtyDays:
        _graphData
          ..startTime = DateTime.now().subtract(const Duration(days: 30))
          ..endTime = DateTime.now()
          ..interval = GraphInterval.LastThirtyDays;
        break;

      case GraphInterval.Custom:
        _graphData.interval = GraphInterval.Custom;
        _isCustomInterval = true;
        break;
    }
    return this;
  }

  GraphBuilder setNode(Node node) {
    _graphData.node = node;
    return this;
  }

  GraphBuilder setDataType(DataType dataType) {
    _graphData.dataType = dataType;

    if (dataType.id == 1) {
      _graphData.gradientColors = [
        const Color.fromARGB(255, 180, 23, 23),
        const Color.fromARGB(255, 244, 0, 0),
      ];
    } else if (dataType.id == 2) {
      _graphData.gradientColors = [
        const Color.fromARGB(255, 216, 155, 0),
        const Color.fromARGB(255, 226, 196, 28),
      ];
    } else if (dataType.id == 3) {
      _graphData.gradientColors = [
        const Color.fromARGB(255, 0, 198, 96),
        const Color.fromARGB(255, 0, 173, 52),
      ];
    } else if (dataType.id == 4) {
      _graphData.gradientColors = [
        const Color.fromARGB(255, 204, 35, 230),
        const Color.fromARGB(255, 173, 2, 211),
      ];
    }

    return this;
  }

  GraphBuilder setStartTime(DateTime startTime) {
    if (_isCustomInterval == false) {
      throw Exception('Cannot set start time for non-custom interval');
    }

    _graphData.startTime = startTime;
    return this;
  }

  GraphBuilder setEndTime(DateTime endTime) {
    if (_isCustomInterval == false) {
      throw Exception('Cannot set end time for non-custom interval');
    }

    _graphData.endTime = endTime;
    return this;
  }

  Future<GraphData> build() async {
    _populateData();
    if (_graphData.dataType == null) {
      throw Exception('Data type must be set');
    }

    if (_isCustomInterval) {
      if (_graphData.startTime == null || _graphData.endTime == null) {
        throw Exception('Custom interval requires start and end time');
      }
    }

    if (_graphData.interval == null) {
      throw Exception('Interval must be set');
    }

    if (_graphData.node == null) {
      throw Exception('Node must be set');
    }

    final dataList = await _retrieveDataPointsFromDatabaseAndFilter();
    _graphData.dataSpots = dataList
        .map((data) => FlSpot(data.timestamp.toDouble(),
            double.parse(data.value.toStringAsFixed(2))))
        .toList();

    return _graphData;
  }

  Future<List<Data>> _retrieveDataPointsFromDatabaseAndFilter() async {
    DataDao dataDao = DataDaoImpl();

    int nodeId = _graphData.node?.id ?? -1;
    int dataTypeId = _graphData.dataType?.id ?? -1;
    int startTime = _graphData.startTime?.millisecondsSinceEpoch ?? 0;
    int endTime = _graphData.endTime?.millisecondsSinceEpoch ??
        DateTime.now().millisecondsSinceEpoch;

    final datapoints = await dataDao.getDataInTimeRangeByNodeIdAndDataTypeId(
        nodeId, dataTypeId, startTime, endTime);

    if (datapoints.isEmpty) {
      _graphData
        ..maxY = 0
        ..minY = 0
        ..avgY = 0
        ..maxX = 0
        ..minX = 0
        ..avgX = 0;
      return [];
    }

    List<Data> newDatapoints = [];
    int timeStamp;
    int timeIncrements;
    int maxTimeValue;

    switch (_graphData.interval ?? GraphInterval.LastSevenDays) {
      case GraphInterval.LastTwentyFourHours:
        timeStamp = DateTime.now()
            .subtract(const Duration(days: 1))
            .millisecondsSinceEpoch;
        timeIncrements = const Duration(hours: 1).inMilliseconds;
        maxTimeValue = 24;
        break;
      case GraphInterval.LastSevenDays:
        timeStamp = DateTime.now()
            .subtract(const Duration(days: 7))
            .millisecondsSinceEpoch;
        timeIncrements = const Duration(days: 1).inMilliseconds;
        maxTimeValue = 7;
        break;
      case GraphInterval.LastThirtyDays:
        timeStamp = DateTime.now()
            .subtract(const Duration(days: 30))
            .millisecondsSinceEpoch;
        timeIncrements = const Duration(days: 1).inMilliseconds;
        maxTimeValue = 31;
        break;
      case GraphInterval.Custom:
        timeStamp = _graphData.startTime?.millisecondsSinceEpoch ?? 0;
        timeIncrements = const Duration(days: 1).inMilliseconds;
        maxTimeValue =
            ((_graphData.endTime?.millisecondsSinceEpoch ?? 0) - timeStamp) ~/
                timeIncrements;
        break;
    }

    for (int i = 0; i < maxTimeValue; i++) {
      Data? data = datapoints.firstWhere(
          (element) =>
              element.timestamp >= timeStamp &&
              element.timestamp < timeStamp + timeIncrements,
          orElse: () => Data(
              nodeId: _graphData.node!.id ?? -1,
              dataTypeId: _graphData.dataType!.id,
              value: 0,
              timestamp: timeStamp));
      newDatapoints.add(data);
      timeStamp += timeIncrements;
    }

    datapoints.clear();
    datapoints.addAll(newDatapoints);

    // Initialize variables to hold the values
    double maxY = double.negativeInfinity;
    double minY = double.infinity;
    double sumY = 0;
    int maxX = 0;
    int minX = 0;

// Calculate maxY, minY, sumY, maxX, and minX in one loop
    for (Data data in datapoints) {
      double value = data.value;
      int timestamp = data.timestamp;

      // Calculate maxY and minY
      if (value > maxY) {
        maxY = value;
      }
      if (value < minY) {
        minY = value;
      }

      // Calculate sumY
      sumY += value;

      // Calculate maxX and minX
      if (timestamp > maxX) {
        maxX = timestamp;
      }
      if (timestamp < minX || minX == 0) {
        minX = timestamp;
      }
    }

// Calculate avgY and avgX
    double avgY = sumY / datapoints.length;
    double avgX = (maxX + minX) / 2;

// Set the values in _graphData
    _graphData
      ..maxY = maxY
      ..minY = minY
      ..avgY = avgY
      ..maxX = maxX.toDouble()
      ..minX = minX.toDouble()
      ..avgX = avgX;

    return datapoints;
  }

  void _populateData() {
    DataDao dataDao = DataDaoImpl();
    dataDao.deleteAllData();
    for (int i = 0; i < (24 * 30); i++) {
      Random random = Random();
      double value = random.nextDouble();
      int hoursAgo = i;

      dataDao.insertData(Data(
          nodeId: 1,
          dataTypeId: 1,
          value: value,
          timestamp: DateTime.now().millisecondsSinceEpoch -
              Duration(hours: hoursAgo).inMilliseconds));
    }
    for (int i = 0; i < (24 * 30); i++) {
      Random random = Random();
      double value = random.nextDouble();
      int hoursAgo = i;

      dataDao.insertData(Data(
          nodeId: 1,
          dataTypeId: 2,
          value: value,
          timestamp: DateTime.now().millisecondsSinceEpoch -
              Duration(hours: hoursAgo).inMilliseconds));
    }
    for (int i = 0; i < (24 * 30); i++) {
      Random random = Random();
      double value = random.nextDouble();
      int hoursAgo = i;

      dataDao.insertData(Data(
          nodeId: 1,
          dataTypeId: 3,
          value: value,
          timestamp: DateTime.now().millisecondsSinceEpoch -
              Duration(hours: hoursAgo).inMilliseconds));
    }
    for (int i = 0; i < (24 * 30); i++) {
      Random random = Random();
      double value = random.nextDouble();
      int hoursAgo = i;

      dataDao.insertData(Data(
          nodeId: 1,
          dataTypeId: 4,
          value: value,
          timestamp: DateTime.now().millisecondsSinceEpoch -
              Duration(hours: hoursAgo).inMilliseconds));
    }
  }
}
