import 'dart:math';

import 'package:mybluetoothapp/models/datatype.dart';
import 'package:mybluetoothapp/models/graph_data.dart';
import 'package:mybluetoothapp/models/graph_interval.dart';
import 'package:mybluetoothapp/models/node.dart';
import 'package:mybluetoothapp/services/graph_data_builder.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:test/test.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  final testNode = Node(
      id: 1,
      nid: "12",
      name: "test node",
      description: "test node description");
  final testDataType =
  DataType(id: 1, name: "temperature", unit: "C");

  group(
      "Testing Custom Graph Object Builder",
      () {
        test(
            'graph object should consists of correct startTime and endTime given the relevant attributes for the builder',
                () async {
              final startTime = DateTime(2024, 06, 8);
              final endTime = DateTime(2024, 06, 10);

              final GraphData graphData = await GraphBuilder()
                  .setNode(testNode)
                  .setGraphInterval(GraphInterval.Custom)
                  .setStartTime(startTime)
                  .setEndTime(endTime)
                  .setDataType(testDataType)
                  .build();

              expect(graphData.startTime?.hour, startTime.hour);
              expect(graphData.endTime?.hour, endTime.hour);
            });

        test("graph object contains the correct number of dataSpots given a custom time interval",() async{
          final endTime = DateTime(2024, 06, 10);
          final startTime = endTime.subtract(const Duration(days: 7));

          final GraphData graphData = await GraphBuilder()
              .setNode(testNode)
              .setGraphInterval(GraphInterval.Custom)
              .setStartTime(startTime)
              .setEndTime(endTime)
              .setDataType(testDataType)
              .build();

          // PRINTING DATA SPOTS
          // graphData.dataSpots.forEach((element) {
          //   print("x: ${element.x}y: ${element.y}");
          // });

          expect(7, graphData.dataSpots.length);
        });
      }
  );

  group("Testing last seven days ago graphData", (){
    const GraphInterval graphInterval = GraphInterval.LastSevenDays ;
    DateTime startTime = DateTime.now();
    DateTime endTime = DateTime.now().subtract(const Duration(days: 7));

    test("graph object should consist of the correct endTime and startTime given the correct interval value", () async{

      final GraphData graphData = await GraphBuilder()
          .setNode(testNode)
          .setDataType(testDataType)
      .setGraphInterval(graphInterval)
      .build();

      expect(startTime.hour, graphData.startTime?.hour);
      expect(endTime.hour, graphData.endTime?.hour);
    });

    test("graph object should consist of 7 dataspots given the correct interval value", () async{

      final GraphData graphData = await GraphBuilder()
          .setNode(testNode)
          .setDataType(testDataType)
          .setGraphInterval(graphInterval)
          .build();

      expect(7, graphData.dataSpots.length);
    });
  });
}
