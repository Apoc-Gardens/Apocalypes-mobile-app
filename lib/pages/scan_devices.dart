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
    } catch (e) {
      print('Error connecting to device: $e');
    }
    if(device.isConnected){
       print('<========= Device is connected ======>');
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
            title: Text(device.device.platformName),
            subtitle: Text(device.device.remoteId.toString()),
            trailing: OutlinedButton(
              onPressed: () {
                // Add your onPressed logic here
                connectToDevice(device.device);
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Color(0xFF0AA061), side: BorderSide(color: Color(0xFF0AA061), width: 1.0), // Outline color and thickness
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0), // Border radius
                ),
                padding: EdgeInsets.all(6.0), // Padding
              ),
              child: Text('Connect'),
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