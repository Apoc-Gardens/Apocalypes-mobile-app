import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import 'characteristic_value.dart';

class CharacteristicViewer extends StatefulWidget {
  final BluetoothDevice connectedDevice;

  const CharacteristicViewer({required this.connectedDevice});

  @override
  _CharacteristicViewerState createState() => _CharacteristicViewerState();
}

class _CharacteristicViewerState extends State<CharacteristicViewer> {
  List<BluetoothCharacteristic> _characteristics = [];

  @override
  void initState() {
    super.initState();
    _discoverCharacteristics();
  }

  void _readCharacteristic(BluetoothCharacteristic characteristic) async {
    try {
      List<int> value = await characteristic.read();
      String valueString = value.map((e) => e.toRadixString(16).padLeft(2, '0')).join(' ');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CharacteristicValuePage(characteristicValue: valueString),
        ),
      );
    } catch (e) {
      print('Error reading characteristic: $e');
    }
  }


  void _discoverCharacteristics() async {
    List<BluetoothService> services = await widget.connectedDevice.discoverServices();
    List<BluetoothCharacteristic> characteristics = [];

    services.forEach((service) {
      characteristics.addAll(service.characteristics);
    });

    setState(() {
      _characteristics = characteristics;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BLE Characteristics Viewer'),
      ),
      body: ListView.builder(
        itemCount: _characteristics.length,
        itemBuilder: (context, index) {
          BluetoothCharacteristic characteristic = _characteristics[index];
          bool isReadable = characteristic.properties.read;
          return ListTile(
            title: Text('Characteristic ${characteristic.uuid.toString()}'),
            subtitle: Text('Properties: ${characteristic.properties.toString()}'),
            trailing: isReadable
                ? ElevatedButton(
              onPressed: () {
                _readCharacteristic(characteristic);
              },
              child: Text('Read'),
            )
                : null,
            onTap: () {
              // Handle characteristic selection
            },
          );
        },
      ),

    );
  }
}
