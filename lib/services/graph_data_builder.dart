import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:mybluetoothapp/dao/data_dao.dart';
import 'package:mybluetoothapp/daoImpl/data_dao_impl.dart';
import 'package:mybluetoothapp/models/datatype.dart';
import 'package:mybluetoothapp/models/graph_data.dart';
import 'package:mybluetoothapp/models/graph_interval.dart';
import 'package:mybluetoothapp/models/data.dart';

class GraphBuilder {
  final GraphData _graphData = GraphData();

  bool _isCustomInterval = false;

  GraphBuilder setGraphInterval(GraphInterval interval) {
    switch (interval) {
      case GraphInterval.twentyFourHoursBefore:
        _graphData
          ..startTime = DateTime.now().subtract(const Duration(days: 1))
          ..endTime = DateTime.now()
          ..interval = GraphInterval.twentyFourHoursBefore;
        break;

      case GraphInterval.lastSevenDays:
        _graphData
          ..startTime = DateTime.now().subtract(const Duration(days: 7))
          ..endTime = DateTime.now()
          ..interval = GraphInterval.lastSevenDays;
        break;

      case GraphInterval.lastThirtyDays:
        _graphData
          ..startTime = DateTime.now().subtract(const Duration(days: 30))
          ..endTime = DateTime.now()
          ..interval = GraphInterval.lastThirtyDays;
        break;

      case GraphInterval.custom:
        _graphData.interval = GraphInterval.custom;
        _isCustomInterval = true;
        break;
    }
    return this;
  }

  GraphBuilder setDataType(DataType dataType) {
    _graphData.dataType = dataType;
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
    if (_graphData.dataType == null) {
      throw Exception('Data type must be set');
    }

    if (_isCustomInterval) {
      if (_graphData.startTime == null || _graphData.endTime == null) {
        throw Exception('Custom interval requires start and end time');
      }
    }

    if(_graphData.interval == null) {
      throw Exception('Interval must be set');
    }

    final dataList = await _retrieveDataPointsFromDatabaseAndFilter();
    _graphData.dataSpots = dataList
        .map((data) => FlSpot(data.timestamp.toDouble(), data.value))
        .toList();

    return _graphData;
  }

  Future<List<Data>> _retrieveDataPointsFromDatabaseAndFilter() async {
    DataDao dataDao = DataDaoImpl();

    int dataTypeId = _graphData.dataType?.id ?? -1;
    int startTime = _graphData.startTime?.millisecondsSinceEpoch ?? 0;
    int endTime = _graphData.endTime?.millisecondsSinceEpoch ??
        DateTime.now().millisecondsSinceEpoch;

    final datapoints = await dataDao.getDataInTimeRangeByDataTypeId(
        dataTypeId, startTime, endTime);

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
    
    if(_graphData.interval == GraphInterval.twentyFourHoursBefore) {
      datapoints.removeWhere((data) => data.timestamp < DateTime.now().subtract(const Duration(days: 1)).millisecondsSinceEpoch);
      datapoints.sort((a, b) => a.timestamp.compareTo(b.timestamp));

      List<Data> newDatapoints = [];
      int timestamp = DateTime.now().subtract(const Duration(days: 1)).millisecondsSinceEpoch;

      for(int i = 0; i < 24; i++) {
        Data? data = datapoints.firstWhere((element) => element.timestamp >= timestamp && element.timestamp < timestamp + const Duration(hours: 1).inMilliseconds, 
          orElse: () => Data(nodeId: 1, dataTypeId: 1, value: 0, timestamp: timestamp));
        newDatapoints.add(data);
        timestamp += const Duration(hours: 1).inMilliseconds;
      }
      datapoints.clear();
      datapoints.addAll(newDatapoints);

    } else if(_graphData.interval == GraphInterval.lastSevenDays) {

      datapoints.removeWhere((data) => data.timestamp < DateTime.now().subtract(const Duration(days: 7)).millisecondsSinceEpoch);
      datapoints.sort((a, b) => a.timestamp.compareTo(b.timestamp));

      List<Data> newDatapoints = [];
      int timestamp = DateTime.now().subtract(const Duration(days: 7)).millisecondsSinceEpoch;

      for(int i = 0; i < 7; i++) {
        Data? data = datapoints.firstWhere((element) => element.timestamp >= timestamp && element.timestamp < timestamp + const Duration(days: 1).inMilliseconds, 
          orElse: () => Data(nodeId: 1, dataTypeId: 1, value: 0, timestamp: timestamp));
        newDatapoints.add(data);
        timestamp += const Duration(days: 1).inMilliseconds;
      }

      datapoints.clear();
      datapoints.addAll(newDatapoints);

    } else if(_graphData.interval == GraphInterval.lastThirtyDays) {

      datapoints.removeWhere((data) => data.timestamp < DateTime.now().subtract(const Duration(days: 30)).millisecondsSinceEpoch);
      datapoints.sort((a, b) => a.timestamp.compareTo(b.timestamp));

      List<Data> newDatapoints = [];
      int timestamp = DateTime.now().subtract(const Duration(days: 30)).millisecondsSinceEpoch;

      for(int i = 0; i < 31; i++) {
        Data? data = datapoints.firstWhere((element) => element.timestamp >= timestamp && element.timestamp < timestamp + const Duration(days: 1).inMilliseconds, 
          orElse: () => Data(nodeId: 1, dataTypeId: 1, value: 0, timestamp: timestamp));
        newDatapoints.add(data);
        timestamp += const Duration(days: 1).inMilliseconds;
      }

      datapoints.clear();
      datapoints.addAll(newDatapoints);
    }


    final maxY =
        datapoints.map((data) => data.value).reduce((a, b) => a > b ? a : b);
    final minY =
        datapoints.map((data) => data.value).reduce((a, b) => a < b ? a : b);
    final avgY = datapoints.map((data) => data.value).reduce((a, b) => a + b) /
        datapoints.length;

    final maxX = datapoints
        .map((data) => data.timestamp)
        .reduce((a, b) => a > b ? a : b)
        .toDouble();
    final minX = datapoints
        .map((data) => data.timestamp)
        .reduce((a, b) => a < b ? a : b)
        .toDouble();
    final avgX =
        datapoints.map((data) => data.timestamp).reduce((a, b) => a + b) /
            datapoints.length;

    _graphData
      ..maxY = maxY
      ..minY = minY
      ..avgY = avgY
      ..maxX = maxX
      ..minX = minX
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
    
  }
}
