import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../dao/receiver_dao.dart';
import '../models/receiver.dart';

class ReceiversProvider with ChangeNotifier {
  final ReceiverDao _receiverDao = ReceiverDao();
  final List<BluetoothDevice> _connectedDevices = [];
  Receiver? _selectedDevice;
  late BluetoothDevice _selectedDeviceBluetooth;
  List<Receiver> _savedDevices = [];

  List<BluetoothDevice> get connectedDevices => _connectedDevices;
  Receiver? get selectedDevice => _selectedDevice;
  List<Receiver> get savedDevices => _savedDevices;

  ReceiversProvider() {
    _init();
  }

  Future<void> _init() async {
    await _getSavedDevices();
    if (_savedDevices.isNotEmpty) {
      _selectFirstDevice();
    }
  }

  Future<void> _getSavedDevices() async {
    _savedDevices = await _receiverDao.getAllDevices();
    notifyListeners();
  }

  Future<void> _connectToSavedDevices() async {
    for (Receiver receiver in _savedDevices) {
      BluetoothDevice device = BluetoothDevice.fromId(receiver.mac);
      await device.connect();
      _connectedDevices.add(device);
    }
    notifyListeners();
  }

  void _selectFirstDevice() {
    _selectedDevice = _savedDevices.first;
    _selectedDeviceBluetooth = BluetoothDevice.fromId(_selectedDevice!.mac);
    notifyListeners();
  }

  void selectDevice(Receiver receiver) {
    _selectedDevice = receiver;
    notifyListeners();
  }

  Future<void> refreshDevices() async {
    await _getSavedDevices();
    if (_savedDevices.isNotEmpty) {
      _selectFirstDevice();
    } else {
      _selectedDevice = null;
    }
  }
}
