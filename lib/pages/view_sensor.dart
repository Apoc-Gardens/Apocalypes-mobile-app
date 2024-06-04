import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mybluetoothapp/dao/data_type_dao.dart';
import 'package:mybluetoothapp/daoImpl/data_type_dao_impl.dart';
import 'package:mybluetoothapp/models/datatype.dart';
import 'package:mybluetoothapp/models/graph_data.dart';
import 'package:mybluetoothapp/models/graph_interval.dart';
import 'package:mybluetoothapp/models/node.dart';
import 'package:mybluetoothapp/services/graph_data_builder.dart';
import 'package:mybluetoothapp/widgets/graph_card.dart';

import '../services/database_service.dart';

class ViewSensor extends StatefulWidget {
  final Node node;
  const ViewSensor({super.key, required this.node});

  @override
  State<ViewSensor> createState() => _ViewSensorState();
}

class _ViewSensorState extends State<ViewSensor> {
  List<GraphData> graphDataList = [];
  DatabaseHelper databaseHelper = DatabaseHelper();
  int selectedIndex = 1;
  int noOfData = 0;
  int latestTime = 0;
  int oldestTime = 0;
  late List<Map<String, dynamic>> data;
  DateTime now = DateTime.now(); // Get the current time
  late String nodeName;
  late String nodeDescription;

  @override
  void initState() {
    super.initState();
    nodeName = widget.node.name;
    nodeDescription = widget.node.description ?? 'No description';
    getData();
    _loadGraphData(GraphInterval.LastTwentyFourHours);
  }

  Future<void> getData() async {
    await dataCount();
    await getLatestTime();
    await getOldestTime();
    setState(() {});
  }

  Future<void> dataCount() async {
    noOfData = await databaseHelper.countData(widget.node.id.toString()) ?? 0;
  }

  Future<void> getLatestTime() async {
    latestTime =
        await databaseHelper.latestDataTimeStamp(widget.node.id.toString()) ??
            0;
  }

  Future<void> getOldestTime() async {
    oldestTime =
        await databaseHelper.oldestDataTimeStamp(widget.node.id.toString()) ??
            0;
  }

  Future<void> getFilteredData(
      String tableId, int startTime, int endTime) async {
    data = await databaseHelper.getDataByNodeTime(tableId, startTime, endTime);
  }

  void updateName(newName) async {
    int response =
        await databaseHelper.updateNodeName(widget.node.id.toString(), newName);
    if (response > 0) {
      setState(() {
        nodeName = newName;
      });
    } else {
      print('update failed');
    }
  }

  void updateDescription(newDescription) async {
    int response = await databaseHelper.updateNodeDescription(
        widget.node.id.toString(), newDescription);
    if (response > 0) {
      setState(() {
        nodeDescription = newDescription;
      });
    } else {
      print('update failed');
    }
  }

  void selectButton(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  void showEditDialog(
      String title, String initialValue, Function(String) onSave) {
    TextEditingController controller =
        TextEditingController(text: initialValue);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: Text(
            'Edit $title',
            style: const TextStyle(color: Colors.green),
          ),
          content: TextField(
            cursorColor: Colors.green,
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Enter new $title',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child:
                  const Text('Cancel', style: TextStyle(color: Colors.green)),
            ),
            TextButton(
              onPressed: () {
                onSave(controller.text);
                Navigator.of(context).pop();
              },
              child: const Text('Save', style: TextStyle(color: Colors.green)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    showEditDialog('Name', widget.node.name, (newValue) {
                      updateName(newValue);
                    });
                  },
                  child: Text(
                    nodeName,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'inter',
                    ),
                  ),
                ),
                Text(widget.node.id.toString()),
              ],
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                showEditDialog('Description', widget.node.description ?? '',
                    (newValue) {
                  updateDescription(newValue);
                });
              },
              child: Text(
                nodeDescription,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Last Update'),
                    Text(DateFormat('HH:mm:ss').format(
                        DateTime.fromMillisecondsSinceEpoch(latestTime))),
                  ],
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('First Update'),
                    Text(DateFormat('HH:mm:ss').format(
                        DateTime.fromMillisecondsSinceEpoch(oldestTime))),
                  ],
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('No. Data'),
                    Text(noOfData.toString()),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            _timeRangeSelector(),
            const SizedBox(height: 12),
            graphDataList.isEmpty
                ? const Center(
                    child: Text("No data available"),
                  )
                : Column(
                    children: graphDataList
                        .map((GraphData data) => GraphCard(graphData: data))
                        .toList(),
                  )
          ],
        ),
      ),
    );
  }

/// Creates a widget that allows the user to select the time range for the graph.
///
/// This widget displays a label "TIME RANGE" followed by a row of buttons
/// representing different predefined time intervals (`24h`, `7d`, `30d`) and a
/// custom option. Clicking a button triggers the selection of the corresponding
/// `GraphInterval` enum value.
///
/// Returns: A `Widget` representing the time range selector.
Widget _timeRangeSelector() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      const Text(
        'TIME RANGE',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.normal,
          color: Color(0xFF0AA061),
        ),
      ),
      const SizedBox(height: 10),
      Wrap(
        spacing: 8.0,
        children: <Widget>[
          _timeRangeButton("24h", GraphInterval.LastTwentyFourHours),
          _timeRangeButton("7d", GraphInterval.LastSevenDays),
          _timeRangeButton("30d", GraphInterval.LastThirtyDays),
          _timeRangeButton("Custom", GraphInterval.Custom)
        ],
      )
    ],
  );
}

/// Creates a button for selecting a specific time range for the graph.
///
/// This method creates an `OutlinedButton` with the provided text label 
/// and associates it with the specified `GraphInterval` enum value. Clicking 
/// the button triggers the following actions:
///   1. Calls the `_loadGraphData` function to asynchronously load graph data 
///      for the corresponding `interval`.
///   2. Calls `selectButton` to visually select the button based on the 
///      `interval.index`.
///
/// Parameters:
/// * `text` (String): The text to be displayed on the button.
/// * `interval` (GraphInterval): The `GraphInterval` enum value representing 
///   the time range for the button.
///
/// Returns: A `Widget` representing the time range button.
Widget _timeRangeButton(String text, GraphInterval interval) {
  return OutlinedButton(
    onPressed: () async {
      await _loadGraphData(interval);
      selectButton(interval.index);
    },
    style: OutlinedButton.styleFrom(
      foregroundColor: const Color(0xFF0AA061),
      side: selectedIndex == 4
          ? const BorderSide(color: Colors.white, width: 0)
          : const BorderSide(color: Colors.black, width: 1.0),
      backgroundColor: selectedIndex == 4 ? Colors.green : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
    ),
    child: Text(
      text,
      style: TextStyle(
        color: selectedIndex == 4 ? Colors.white : Colors.black,
      ),
    ),
  );
}

  /// Loads graph data for the specified time interval asynchronously.
  ///
  /// This method retrieves all data types and for each type, builds a
  /// corresponding `GraphData` object using the provided [interval] and the
  /// widget's node. The built `GraphData` objects are then added to the
  /// `graphDataList`.
  ///
  /// Returns: A `Future<void>` that completes when the graph data has been loaded.
  Future<void> _loadGraphData(GraphInterval interval) async {
    // Get all data types
    DataTypeDao dataTypeDao = DataTypeDaoImpl();
    List<DataType> dataTypes = await dataTypeDao.getDataTypes();

    // Build GraphData for each data type
    for (DataType dataType in dataTypes) {
      GraphData graphData = await GraphBuilder()
          .setNode(widget.node)
          .setGraphInterval(interval)
          .setDataType(dataType)
          .build();
      graphDataList.add(graphData);
    }
  }
}
