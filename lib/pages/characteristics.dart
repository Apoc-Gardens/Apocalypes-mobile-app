import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import 'characteristic_value.dart';
import 'characteristic_value_list.dart';

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

    String asciiValues(List<int> value){
      String hexString = value.map((e) => e.toRadixString(16).padLeft(2, '0')).join(' ');
      List<int> asciiList = hexString.split(' ').map((e) => int.parse(e, radix: 16)).toList();
      return asciiList.map((e) => String.fromCharCode(e)).join('');
    }

    try {
      String property = characteristic.uuid.toString();
      List<String> sensordata = [];

      if(property == "870e104f-ba63-4de3-a3ac-106969eac292"){
        String asciiString = asciiValues(await characteristic.read());
        print(asciiString);

        while(asciiString != "end"){
          asciiString = asciiValues(await characteristic.read());
          sensordata.add(asciiString);
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CharacteristicValueListPage(characteristicValues: sensordata,),
          ),
        );
      }else{
        List<int> value = await characteristic.read();
        String asciiString = asciiValues(value);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CharacteristicValuePage(characteristicValue: asciiString),
          ),
        );
      }
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
        title: const Text('BLE Characteristics Viewer'),
      ),
      body: ListView.builder(
        itemCount: _characteristics.length,
        itemBuilder: (context, index) {
          BluetoothCharacteristic characteristic = _characteristics[index];
          bool isReadable = characteristic.properties.read;
          return ListTile(
            title: Text('Characteristic ${characteristic.uuid.toString()}'),
            subtitle: Text('Properties: ${characteristic.uuid.toString()}'),
            trailing: isReadable ? ElevatedButton(
              onPressed: () {
                  _readCharacteristic(characteristic);
                  print("pressed on characteristic read");
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
