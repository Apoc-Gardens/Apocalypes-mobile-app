import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:mybluetoothapp/pages/landing_page.dart';
import 'package:mybluetoothapp/pages/scan_devices.dart';
import 'package:mybluetoothapp/pages/sensor_properties.dart';
import 'package:mybluetoothapp/pages/sensors.dart';
import 'package:mybluetoothapp/providers/bluetooth_provider.dart';
import 'package:provider/provider.dart';
import 'package:mybluetoothapp/pages/characteristics.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (BuildContext context) { BluetoothProvider(); },)],
      child: MaterialApp(
        initialRoute: '/sensor_properties',
        routes: {
          '/': (context) => const Welcome(),
          '/scan': (context) => MyHomePage(),
          '/sensors': (context) => const Sensors(),
          '/characteristics': (context) => CharacteristicViewer(connectedDevice: ModalRoute.of(context)!.settings.arguments as BluetoothDevice),
          '/sensor_properties': (context) => const SensorPropertiesPage(),
        },
      ),
    );
  }
}