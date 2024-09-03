import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:apoc_gardens/pages/receivers.dart';
import 'package:provider/provider.dart';
import 'package:apoc_gardens/pages/landing_page.dart';
import 'package:apoc_gardens/pages/scan_devices.dart';
import 'package:apoc_gardens/pages/sensors.dart';
import 'package:apoc_gardens/providers/receivers_provider.dart';
import 'package:apoc_gardens/test/dbpage.dart';
import 'package:apoc_gardens/pages/characteristics.dart';
import 'dao/receiver_dao.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ReceiverDao _receiverDao = ReceiverDao();

  @override
  void initState() {
    super.initState();
  }

  Future<int> getReceiverCount() async {
    return await _receiverDao.getReceiverCount() ?? 0;
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
              ChangeNotifierProvider(create: (_) => ReceiversProvider()),
            ],
            child: MaterialApp(
              initialRoute: receiverCount == 0 ? '/' : '/sensors',
              routes: {
                '/': (context) => const Welcome(),
                '/scan': (context) => ScanDevices(),
                '/sensors': (context) => const Sensors(),
                '/receivers': (context) => Receivers(),
                '/characteristics': (context) => CharacteristicViewer(
                    connectedDevice: ModalRoute.of(context)!.settings.arguments
                        as BluetoothDevice),
                '/test': (context) => const dbpage(),
              },
            ),
          );
        }
      },
    );
  }
}
