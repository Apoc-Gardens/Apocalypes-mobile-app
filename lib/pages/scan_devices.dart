import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:apoc_gardens/navigation/side_menu.dart';
import '../dao/receiver_dao.dart';
import 'dart:async';

class ScanDevices extends StatefulWidget {
  const ScanDevices({super.key});

  @override
  _ScanDevicesState createState() => _ScanDevicesState();
}

class _ScanDevicesState extends State<ScanDevices> {
  List<ScanResult> devicesList = [];
  final ReceiverDao _receiverDao = ReceiverDao();
  bool isScanning = false;
  Timer? scanTimer;

  @override
  void initState() {
    super.initState();
    startScan();
  }

  void startScan() {
    setState(() {
      isScanning = true;
    });

    FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult result in results) {
        if (!devicesList.contains(result)) {
          setState(() {
            devicesList.add(result);
          });
        }
      }
    });
    //nn
    //FlutterBluePlus.startScan(withServices: [Guid('8292fed4-e037-4dd7-b0c8-c8d7c80feaae')]);
    FlutterBluePlus.startScan();

    // Automatically stop scanning after 1 minute
    scanTimer = Timer(const Duration(seconds: 30), stopScan);
  }

  void stopScan() {
    FlutterBluePlus.stopScan();
    setState(() {
      isScanning = false;
    });
    scanTimer?.cancel();
  }

  Future<void> insertReceiverDevice(BluetoothDevice device) async {
    int response = await _receiverDao.insertReceiverDevice(
      null,
      device.platformName,
      device.remoteId.toString(),
      null,
    );
    print("db response");
    print(response);
  }

  void connectToDevice(BluetoothDevice device) async {
    try {
      // Connect to the device just to check if it is working
      await device.connect();
      if (device.isConnected) {
        print(device.remoteId.toString());
        insertReceiverDevice(device);
        device.disconnect();
        // ToDo: put a toast saying "saved"
        Navigator.pushNamed(context, '/sensors');
        print('Redirecting to sensors page');

        // Navigator.pushNamed(context, '/characteristics', arguments: device);
        // print('Redirecting to characteristic view page');
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

  // This function can be removed in the future
  Future<bool> checkServices(BluetoothDevice device) async {
    List<BluetoothService> services = await scanServices(device);
    for (BluetoothService service in services) {
      print('Service found: ${service.uuid}');
      if (service.uuid.toString() == "4fafc201-1fb5-459e-8fcc-c5c9c331914b") {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bluetooth Devices'),
      ),
      drawer: const SideMenu(),
      body: ListView.builder(
        itemCount: devicesList.length,
        itemBuilder: (context, index) {
          ScanResult device = devicesList[index];
          return ListTile(
            title: Text(device.device.platformName),
            subtitle: Text(device.device.remoteId.toString()),
            trailing: OutlinedButton(
              onPressed: () {
                connectToDevice(device.device);
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF0AA061),
                side: const BorderSide(color: Color(0xFF0AA061), width: 1.0), // Outline color and thickness
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0), // Border radius
                ),
                padding: const EdgeInsets.all(6.0), // Padding
              ),
              child: const Text('Add'),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (isScanning) {
            stopScan();
          } else {
            startScan();
          }
        },
        backgroundColor: Colors.green,
        child: Icon(isScanning ? Icons.stop : Icons.search,
            color: Colors.white),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    FlutterBluePlus.stopScan();
    scanTimer?.cancel();
  }
}
