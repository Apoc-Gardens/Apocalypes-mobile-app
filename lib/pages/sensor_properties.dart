import 'package:flutter/material.dart';
import 'package:mybluetoothapp/widgets/property_graph.dart';

class SensorPropertiesPage extends StatelessWidget {
  const SensorPropertiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
            padding:
                EdgeInsets.only(right: 18.0, left: 12.0, top: 48, bottom: 12),
            child: Column(
              children: [
                Chart(),
              ],
            )));
  }
}
