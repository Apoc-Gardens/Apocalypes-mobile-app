import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../dao/receiver_dao.dart';
import '../models/receiver.dart';

class ReceiversProvider with ChangeNotifier {
  final ReceiverDao _receiverDao = ReceiverDao();
  final List<BluetoothDevice> _connectedDevices = [];
  bool _isScanning = false;
  late Receiver selectedDevice;
  late List<Receiver> savedDevices;
  List<BluetoothDevice> get connectedDevices => _connectedDevices;
  bool get isScanning => _isScanning;

  ReceiversProvider() {
    _init();
  }

  Future<void> _connectToSavedDevices() async {
    savedDevices = await _receiverDao.getAllDevices();
    for (Receiver receiver in savedDevices) {
      BluetoothDevice device = BluetoothDevice.fromId(receiver.mac);
      _connectedDevices.add(device);
    }
    notifyListeners();
  }

  Future<void> _init() async {
    await _getSavedDevices();
    selectFirstDevice();
  }

  Future<void> selectFirstDevice()async {
    selectedDevice = savedDevices.first;
    notifyListeners();
  }

  Future<void> _getSavedDevices() async {
    savedDevices = await _receiverDao.getAllDevices();
    notifyListeners();
  }
}
