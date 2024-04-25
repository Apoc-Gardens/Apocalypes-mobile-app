import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<ScanResult> devicesList = [];

  @override
  void initState() {
    super.initState();
    startScan();
  }

  void startScan() {
    FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult result in results) {
        if (!devicesList.contains(result)) {
          setState(() {
            devicesList.add(result);
          });
        }
      }
    });
    FlutterBluePlus.startScan();
  }

  void connectToDevice(BluetoothDevice device) async {
    try {
      await device.connect();
      // Add your logic to handle the connection
    } catch (e) {
      print('Error connecting to device: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bluetooth Devices'),
      ),
      body: ListView.builder(
        itemCount: devicesList.length,
        itemBuilder: (context, index) {
          ScanResult device = devicesList[index];
          return ListTile(
            title: Text(device.device.platformName ?? 'Unknown device'),
            subtitle: Text(device.device.remoteId.toString()),
            trailing: ElevatedButton(
              onPressed: () {
                connectToDevice(device.device);
              },
              child: const Text('Connect'),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    FlutterBluePlus.stopScan();
  }
}