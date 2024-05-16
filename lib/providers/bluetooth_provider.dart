import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothProvider extends ChangeNotifier {
  late BluetoothDevice _connectedDevice;

  BluetoothDevice get connectedDevice => _connectedDevice;

  set connectedDevice(BluetoothDevice device) {
    _connectedDevice = device;
    notifyListeners();
  }
}
