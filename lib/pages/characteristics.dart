import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

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
          return ListTile(
            title: Text('Characteristic ${characteristic.uuid.toString()}'),
            subtitle: Text('Properties: ${characteristic.properties.toString()}'),
            onTap: () {
              // Handle characteristic selection
            },
          );
        },
      ),
    );
  }
}
