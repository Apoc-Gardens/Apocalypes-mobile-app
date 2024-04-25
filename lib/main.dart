import 'package:flutter/material.dart';
import 'package:mybluetoothapp/pages/landing_page.dart';
import 'package:mybluetoothapp/pages/scan_devices.dart';
import 'package:mybluetoothapp/pages/sensors.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => Welcome(),
        '/scan': (context) => MyHomePage(),
        '/sensors': (context) => Sensors(),
      },
    );
  }
}