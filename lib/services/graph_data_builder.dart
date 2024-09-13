import 'dart:math';

import 'package:apoc_gardens/dao/data_dao.dart';
import 'package:apoc_gardens/daoImpl/data_dao_impl.dart';
import 'package:apoc_gardens/models/datatype.dart';
import 'package:apoc_gardens/models/graph_data.dart';
import 'package:apoc_gardens/models/graph_interval.dart';
import 'package:apoc_gardens/models/data.dart';
import 'package:apoc_gardens/models/node.dart';

/// A builder class for constructing and configuring GraphData objects.
///
/// This class provides a fluent interface for setting various properties of a GraphData object,
/// including time intervals, nodes, data types, and custom time ranges. It also handles data
/// retrieval and processing for graph visualization.
///
/// Usage:
/// ```dart
/// final graphData = await GraphDataBuilder()
///   .setGraphInterval(GraphInterval.LastSevenDays)
///   .setNode(someNode)
///   .setDataType(someDataType)
///   .build();
/// ```
///
/// The builder supports the following graph intervals:
/// - LastTwentyFourHours
/// - LastSevenDays
/// - LastThirtyDays
/// - Custom (requires setting start and end times)
///
/// For custom intervals, use [setStartTime] and [setEndTime] methods.
///
/// The [build] method performs data retrieval, filtering, and statistical calculations
/// before returning the final GraphData object.
///
/// Throws exceptions for invalid configurations, such as missing required data
/// or attempting to set custom times for non-custom intervals.
class GraphDataBuilder {
  final GraphData _graphData = GraphData();
  bool _isCustomInterval = false;

  /// Sets the time interval for the graph data.
  ///
  /// This method configures the start and end times based on the selected [interval].
  /// For custom intervals, it only sets a flag and doesn't set times directly.
  ///
  /// @param interval The desired graph interval.
  /// @return This builder instance for method chaining.
  GraphDataBuilder setGraphInterval(GraphInterval interval) {
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

  /// Sets the node for the graph data.
  ///
  /// @param node The node to be set.
  /// @return This builder instance for method chaining.
  GraphDataBuilder setNode(Node node) {
    _graphData.node = node;
    return this;
  }


  /// Sets the data type for the graph data.
  ///
  /// @param dataType The data type to be set.
  /// @return This builder instance for method chaining.
  GraphDataBuilder setDataType(DataType dataType) {
    //TODO: Do a valid datatype check here
    _graphData.dataType = dataType;
    return this;
  }

  /// Sets the start time for custom interval graph data.
  ///
  /// @param startTime The start time to be set.
  /// @return This builder instance for method chaining.
  /// @throws Exception if not using a custom interval.
  GraphDataBuilder setStartTime(DateTime startTime) {
    if (_isCustomInterval == false) {
      throw Exception('Cannot set start time for non-custom interval');
    }

    _graphData.startTime = startTime;
    return this;
  }

  /// Sets the end time for custom interval graph data.
  ///
  /// @param endTime The end time to be set.
  /// @return This builder instance for method chaining.
  /// @throws Exception if not using a custom interval.
  GraphDataBuilder setEndTime(DateTime endTime) {
    if (_isCustomInterval == false) {
      throw Exception('Cannot set end time for non-custom interval');
    }
    // Adjusting to show the end of the selected date
    _graphData.endTime = endTime.add(const Duration(days: 1));
    return this;
  }

  /// Builds and returns the configured GraphData object.
  ///
  /// This method validates the configuration, retrieves data points,
  /// processes them, and sets additional statistical information.
  ///
  /// @return A Future<GraphData> representing the built graph data.
  /// @throws Exception for various configuration errors.
  Future<GraphData> build() async {
    // Checking data initialization validity
    if (_graphData.dataType == null) {
      throw Exception('Data type must be set');
    }
    if (_isCustomInterval) {
      if (_graphData.startTime == null || _graphData.endTime == null) {
        throw Exception('Custom interval requires start and end time');
      }
    }
    if (_graphData.interval == null) {
      throw Exception('Graph Interval must be set');
    }
    if (_graphData.node == null) {
      throw Exception('Node must be set');
    }

    final dataList = await _retrieveDataPointsFromDatabaseAndFilter();
    _graphData.dataSpots = dataList
        .map((data) => DataSpots(
            DateTime.fromMillisecondsSinceEpoch(data.timestamp),
            double.parse(data.value.toStringAsFixed(2))))
        .toList()
        .cast<DataSpots>();

    return _graphData;
  }

  /// Retrieves data points from the database and processes them based on the configured interval.
  ///
  /// This method queries the database for relevant data points, averages them over
  /// the specified intervals, and calculates various statistical measures (min, max, avg).
  ///
  /// @return A Future<List<Data>> containing the processed data points.
  /// @throws Exception for invalid custom interval configurations.
  Future<List<Data>> _retrieveDataPointsFromDatabaseAndFilter() async {
    DataDao dataDao = DataDaoImpl();

    int nodeId = _graphData.node?.id ?? -1;
    int dataTypeId = _graphData.dataType?.id ?? -1;
    int startTime = _graphData.startTime?.millisecondsSinceEpoch ?? 0;
    int endTime = _graphData.endTime?.millisecondsSinceEpoch ??
        DateTime.now().millisecondsSinceEpoch;

    final List<Data> dataPoints = await dataDao.getDataInTimeRangeByNodeIdAndDataTypeId(
        nodeId, dataTypeId, startTime, endTime);

    // Sorting the queried dataPoints
    dataPoints.sort((a,b)=> a.timestamp.compareTo(b.timestamp));

    List<Data> newDataPoints = [];
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
        maxTimeValue = 30;
        break;
      case GraphInterval.Custom:
        if (_graphData.startTime == null) {
          throw Exception("Start time cannot be null for custom interval");
        }

        if (_graphData.endTime == null) {
          throw Exception("End time cannot be null for custom interval");
        }

        timeStamp = _graphData.startTime?.millisecondsSinceEpoch ?? 0;
        timeIncrements = const Duration(days: 1).inMilliseconds;
        maxTimeValue =
            ((_graphData.endTime?.millisecondsSinceEpoch ?? 0) - timeStamp) ~/
                timeIncrements;
        break;
    }

    for (int i = 0; i < maxTimeValue; i++) {
      List<Data> intervalDataPoints = dataPoints.where(
            (element) =>
        element.timestamp >= timeStamp &&
            element.timestamp < timeStamp + timeIncrements,
      ).toList();

      if (intervalDataPoints.isNotEmpty) {
        double averageValue = intervalDataPoints
            .map((data) => data.value)
            .reduce((a, b) => a + b) / intervalDataPoints.length;

        Data averageData = Data(
          nodeId: _graphData.node!.id ?? -1,
          dataTypeId: _graphData.dataType!.id,
          value: averageValue,
          timestamp: timeStamp,
        );

        newDataPoints.add(averageData);
      } else {
        // If no data points in the interval, add a data point with value 0
        newDataPoints.add(Data(
          nodeId: _graphData.node!.id ?? -1,
          dataTypeId: _graphData.dataType!.id,
          value: 0,
          timestamp: timeStamp,
        ));
      }

      timeStamp += timeIncrements;
    }

    dataPoints.clear();
    dataPoints.addAll(newDataPoints);

    // Initialize variables to hold the values
    double maxY = double.negativeInfinity;
    double minY = double.infinity;
    double sumY = 0;
    int maxX = 0;
    int minX = 0;

    // Calculate maxY, minY, sumY, maxX, and minX in one loop
    for (Data data in dataPoints) {
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
    double avgY = sumY / dataPoints.length;
    double avgX = (maxX + minX) / 2;

    // Set the values in _graphData
    _graphData
      ..maxY = maxY
      ..minY = minY
      ..avgY = avgY
      ..maxX = maxX.toDouble()
      ..minX = minX.toDouble()
      ..avgX = avgX;

    return dataPoints;
  }

  /// Populates the database with random test data.
  ///
  /// This method is intended for development and testing purposes only.
  /// It generates random data points for multiple data types and inserts them into the database.
  ///
  /// @deprecated Do not use this method in production.
  @Deprecated("Do not use this method in production")
  void _populateData() {
    DataDao dataDao = DataDaoImpl();
    dataDao.deleteAllData();
    for (int i = 0; i < (24 * 30); i++) {
      Random random = Random();
      double value = random.nextDouble();
      int hoursAgo = i;

      dataDao.insertData(Data(
          nodeId: _graphData.node!.id ?? 1,
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
          nodeId: _graphData.node!.id ?? 1,
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
          nodeId: _graphData.node!.id ?? 1,
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
          nodeId: _graphData.node!.id ?? 1,
          dataTypeId: 4,
          value: value,
          timestamp: DateTime.now().millisecondsSinceEpoch -
              Duration(hours: hoursAgo).inMilliseconds));
    }
  }
}
