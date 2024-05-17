import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mybluetoothapp/widgets/property_card.dart';

class SensorPropertiesPage extends StatelessWidget {
  const SensorPropertiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: ListView(
            padding:
                const EdgeInsets.only(right: 18.0, left: 12.0, top: 48, bottom: 12),
              children: const <Widget>
              [
                PropertyCard(),
                PropertyCard(),
                PropertyCard(),
              ],
            ));
  }
}
