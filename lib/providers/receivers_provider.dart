import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../dao/receiver_dao.dart';
import '../models/receiver.dart';

class ReceiversProvider with ChangeNotifier {
  final ReceiverDao _receiverDao = ReceiverDao();
  final List<BluetoothDevice> _connectedDevices = [];
  bool _isScanning = false;
  late BluetoothDevice selectedDevice;
  late List<Receiver> savedDevices;

  List<BluetoothDevice> get connectedDevices => _connectedDevices;
  bool get isScanning => _isScanning;

  ReceiversProvider() {
    _connectToSavedDevices();
  }

  Future<void> _connectToSavedDevices() async {
    savedDevices = await _receiverDao.getAllDevices();
    for (Receiver receiver in savedDevices) {
      BluetoothDevice device = BluetoothDevice.fromId(receiver.mac);
      _connectedDevices.add(device);
    }
    notifyListeners();
  }

  Future<void> startScan() async {
    _isScanning = true;
    notifyListeners();
    FlutterBluePlus.startScan();
    FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult result in results) {
        if (!_connectedDevices.contains(result.device)) {
          _connectedDevices.add(result.device);
          // Optionally save the device to the database here
        }
      }
      notifyListeners();
    });
    await Future.delayed(Duration(minutes: 1));
    _stopScan();
  }

  void _stopScan() {
    FlutterBluePlus.stopScan();
    _isScanning = false;
    notifyListeners();
  }

}
