import 'package:flutter/material.dart';
import 'package:mybluetoothapp/models/datatype.dart';
import 'package:mybluetoothapp/models/graph_data.dart';
import 'package:mybluetoothapp/models/graph_interval.dart';
import 'package:mybluetoothapp/services/graph_data_builder.dart';
import 'package:mybluetoothapp/widgets/graph_card.dart';

class SensorPropertiesPage extends StatefulWidget {
  const SensorPropertiesPage({super.key});

  @override
  State<SensorPropertiesPage> createState() => _SensorPropertiesPageState();
}

class _SensorPropertiesPageState extends State<SensorPropertiesPage> {
  late GraphData graphData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadGraphData();
  }

  Future<void> _loadGraphData() async {
    graphData = await GraphBuilder()
        .setGraphInterval(GraphInterval.twentyFourHoursBefore)
        .setDataType(DataType(id: 1, name: "Humidity", unit: ""))
        .build();

    setState(() {
      _isLoading = false;
    });
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
                  GraphCard(graphData: graphData),
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
            _timeRangeButton("24h", GraphInterval.twentyFourHoursBefore),
            _timeRangeButton("7d", GraphInterval.lastSevenDays),
            _timeRangeButton("30d", GraphInterval.lastThirtyDays)
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
        graphData = await GraphBuilder()
            .setGraphInterval(interval)
            .setDataType(DataType(id: 1, name: "Humidity", unit: ""))
            .build();
        setState(() {
          _isLoading = false;
        });
      },
      child: Text(text),
    );
  }
}
