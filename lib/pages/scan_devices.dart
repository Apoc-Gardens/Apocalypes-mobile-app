import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../services/database_service.dart';

class ScanDevices extends StatefulWidget {
  @override
  _ScanDevicesState createState() => _ScanDevicesState();
}

class _ScanDevicesState extends State<ScanDevices> {
  List<ScanResult> devicesList = [];
  DatabaseHelper databaseHelper = DatabaseHelper();

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
    FlutterBluePlus.startScan(withServices: [Guid('8292fed4-e037-4dd7-b0c8-c8d7c80feaae')]);
  }

  Future<void> insertReceiverDevice(BluetoothDevice device) async {
    int response = await databaseHelper.insertReceiverDevice(null, device.platformName, device.remoteId.toString(),null);
    print("db response");
    print(response);
  }

  void connectToDevice(BluetoothDevice device) async {
    try {
      //connect to the device just to check is it is working
      await device.connect();
      if(device.isConnected){
        print(device.remoteId.toString());
        insertReceiverDevice(device);
        device.disconnect();
        //ToDo: put a toast saying "saved"
        Navigator.pushNamed(context, '/sensors');
        print('Redirecting to sensors page');

        //Navigator.pushNamed(context, '/characteristics', arguments: device);
        //print('Redirecting to characteristic view page');
      }
    } catch (e) {
      print('Error connecting to device: $e');
    }
  }

  Future<List<BluetoothService>> scanServices(BluetoothDevice device) async {
    try {
      List<BluetoothService> services = await device.discoverServices();
      return services;
    } catch (e) {
      print('Error discovering services: $e');
      return [];
    }
  }

  //this function can be removed in the future
  Future<bool> checkServices(BluetoothDevice device) async {
    List<BluetoothService> services = await scanServices(device);
    for (BluetoothService service in services) {
      print('Service found: ${service.uuid}');
      if(service.uuid.toString() == "4fafc201-1fb5-459e-8fcc-c5c9c331914b"){
          return true;
      }
    }
    return false;
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
              child: Text('Connect and save'),
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