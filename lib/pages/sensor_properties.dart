import 'package:flutter/material.dart';
import 'package:mybluetoothapp/dao/data_type_dao.dart';
import 'package:mybluetoothapp/daoImpl/data_type_dao_impl.dart';
import 'package:mybluetoothapp/models/datatype.dart';
import 'package:mybluetoothapp/models/graph_data.dart';
import 'package:mybluetoothapp/models/graph_interval.dart';
import 'package:mybluetoothapp/models/node.dart';
import 'package:mybluetoothapp/services/graph_data_builder.dart';
import 'package:mybluetoothapp/widgets/graph_card.dart';

class SensorPropertiesPage extends StatefulWidget {
  const SensorPropertiesPage({super.key});

  @override
  State<SensorPropertiesPage> createState() => _SensorPropertiesPageState();
}

class _SensorPropertiesPageState extends State<SensorPropertiesPage> {
  List<GraphData> graphDataList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadGraphData(GraphInterval.LastTwentyFourHours);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.only(
                    right: 18.0, left: 12.0, top: 48, bottom: 12),
                children: <Widget>[
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
              ));
  }

  Widget _timeRangeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text("Time Range"),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,

          children: <Widget>[
            _timeRangeButton("24h", GraphInterval.LastTwentyFourHours),
            _timeRangeButton("7d", GraphInterval.LastSevenDays),
            _timeRangeButton("30d", GraphInterval.LastThirtyDays)
          ],
        )
      ],
    );
  }

  Widget _timeRangeButton(String text, GraphInterval interval) {
    return ElevatedButton(
      onPressed: () async {
        setState(() {
          _isLoading = true;
        });
        graphDataList.clear();
        await _loadGraphData(interval);
        setState(() {
          _isLoading = false;
        });
      },
      child: Text(text),
    );
  }

  Future<void> _loadGraphData(GraphInterval interval) async {
    DataTypeDao dataTypeDao = DataTypeDaoImpl();

    List<DataType> dataTypes = await dataTypeDao.getDataTypes();

    for (DataType dataType in dataTypes) {
      GraphData graphData = await GraphBuilder()
          .setGraphInterval(interval)
          .setDataType(dataType)
          .setNode(Node(id: 1, nid: "1", name: "Carrot Patch", description: ""))
          .build();
      graphDataList.add(graphData);
    }

    setState(() {
      _isLoading = false;
    });
  }

}
