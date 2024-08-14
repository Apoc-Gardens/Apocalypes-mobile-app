import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:mybluetoothapp/dao/data_dao.dart';
import 'package:mybluetoothapp/dao/node_dao.dart';
import 'package:mybluetoothapp/dao/receiver_dao.dart';
import 'package:mybluetoothapp/models/node.dart';
import 'package:mybluetoothapp/models/receiver.dart';
import 'package:mybluetoothapp/models/data.dart';

class DataSync {
  static Future<void> syncData(
      BluetoothDevice bluetoothDevice,
      DataDao dataDao,
      NodeDao nodeDao,
      Receiver receiverDevice,
      ReceiverDao receiverDao,
      Function onSyncStart,
      Function onSyncEnd,
      ) async {
    final serviceUuid = Guid("8292fed4-e037-4dd7-b0c8-c8d7c80feaae");
    final syncUuid = Guid("870e104f-ba63-4de3-a3ac-106969eac292");
    final latestDate = Guid("d5641f9f-1d6f-4f8e-94db-49fbfe9192ab");
    List<String> sensorData = [];
    List<String> elements = [];
    List<List<String>> listOfElements = [];
    List<BluetoothService> services = await bluetoothDevice.discoverServices();
    BluetoothCharacteristic? selectedCharacteristic;

    String asciiValues(List<int> value) {
      String hexString = value.map((e) => e.toRadixString(16).padLeft(2, '0')).join(' ');
      List<int> asciiList = hexString.split(' ').map((e) => int.parse(e, radix: 16)).toList();
      return asciiList.map((e) => String.fromCharCode(e)).join('');
    }

    if (bluetoothDevice.isConnected) {
      for (BluetoothService service in services) {
        if (service.uuid == serviceUuid) {
          for (BluetoothCharacteristic characteristic in service.characteristics) {
            if (characteristic.uuid == syncUuid) {
              selectedCharacteristic = characteristic;
            }
          }
        }
      }

      if (selectedCharacteristic != null) {
        String asciiString = asciiValues(await selectedCharacteristic.read());
        print(asciiString);
        if (asciiString == "ok") {
          onSyncStart();
          while (asciiString != "end") {
            asciiString = asciiValues(await selectedCharacteristic.read()); //parsing starts ToDo: will need to make this a separate function
            if (asciiString != "end") {
              elements = asciiString.split(",");
              listOfElements.add(elements);
              sensorData.add(asciiString);
            }
          }
          onSyncEnd();
          print("data to be saved");
          for (List<String> element in listOfElements) {
            print("Id: ${element[0]}, battery: ${element[1]}, Temp: ${element[2]}, Hum: ${element[3]}, Lux : ${element[4]}");
            List<Map<String, dynamic>> nodeToBeInserted = await nodeDao.getNodeById(element[0]);
            if (nodeToBeInserted.isEmpty) {
              // Initialization of node without id
              Node newNode = Node(id: -1, nid: element[0], name: 'new node',receiverid: null, description: null);
              int newNodeId = await nodeDao.insertNode(newNode);
              nodeToBeInserted = [{'id': newNodeId}];
              print("saving new node");
            }
            int nodeId = nodeToBeInserted[0]['id'] as int; //parsing end

            double temp = double.tryParse(element[2]) ?? 0.0;
            double hum = double.tryParse(element[3]) ?? 0.0;
            double lux = double.tryParse(element[4]) ?? 0.0;
            double soil = double.tryParse(element[5]) ?? 0.0;
            int timestamp = int.tryParse(element[6]) ?? DateTime.now().millisecondsSinceEpoch;

            await dataDao.insertData(Data(nodeId: nodeId, dataTypeId: 1, value: temp, timestamp: timestamp, ));
            await dataDao.insertData(Data(nodeId: nodeId, dataTypeId: 2, value: hum, timestamp: timestamp, ));
            await dataDao.insertData(Data(nodeId: nodeId, dataTypeId: 3, value: lux, timestamp: timestamp, ));
            await dataDao.insertData(Data(nodeId: nodeId, dataTypeId: 4, value: soil, timestamp: timestamp, ));
          }
          await receiverDao.updateLastSync(receiverDevice.id!, DateTime.now().millisecondsSinceEpoch);
        } else {
          print("Sync error");
        }
      }
    } else {
      print("Device is not connected");
    }
  }
}
