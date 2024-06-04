import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:provider/provider.dart';
import 'package:mybluetoothapp/pages/landing_page.dart';
import 'package:mybluetoothapp/pages/scan_devices.dart';
import 'package:mybluetoothapp/pages/sensor_properties.dart';
import 'package:mybluetoothapp/pages/sensors.dart';
import 'package:mybluetoothapp/providers/bluetooth_provider.dart';
import 'package:mybluetoothapp/test/dbpage.dart';
import 'package:mybluetoothapp/pages/characteristics.dart';
import '../services/database_service.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DatabaseHelper databaseHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    databaseHelper.database;
  }

  Future<int> getReceiverCount() async {
    return await databaseHelper.getReceiverCount() ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: getReceiverCount(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        } else {
          final receiverCount = snapshot.data ?? 0;
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => BluetoothProvider()),
            ],
            child: MaterialApp(
              initialRoute: receiverCount == 0 ? '/' : '/sensors',
              routes: {
                '/': (context) => Welcome(),
                '/scan': (context) => ScanDevices(),
                '/sensors': (context) => Sensors(),
                '/characteristics': (context) => CharacteristicViewer(
                    connectedDevice: ModalRoute.of(context)!.settings.arguments as BluetoothDevice),
                '/test': (context) => dbpage(),
                '/properties': (context) => const SensorPropertiesPage(),
              },
            ),
          );
        }
      },
    );
  }
}
