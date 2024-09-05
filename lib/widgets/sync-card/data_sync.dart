import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:apoc_gardens/dao/data_dao.dart';
import 'package:apoc_gardens/dao/node_dao.dart';
import 'package:apoc_gardens/dao/receiver_dao.dart';
import 'package:apoc_gardens/models/node.dart';
import 'package:apoc_gardens/models/receiver.dart';
import 'package:apoc_gardens/models/data.dart';

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
    final latestDateUuid = Guid("d5641f9f-1d6f-4f8e-94db-49fbfe9192ab");

    List<BluetoothService> services = await bluetoothDevice.discoverServices();
    BluetoothCharacteristic? syncCharacteristic;
    BluetoothCharacteristic? latestDateCharacteristic;

    // Find the required characteristics
    for (BluetoothService service in services) {
      if (service.uuid == serviceUuid) {
        for (BluetoothCharacteristic characteristic in service.characteristics) {
          if (characteristic.uuid == syncUuid) {
            syncCharacteristic = characteristic;
          } else if (characteristic.uuid == latestDateUuid) {
            latestDateCharacteristic = characteristic;
          }
        }
      }
    }

    if (syncCharacteristic == null || latestDateCharacteristic == null) {
      print("Required characteristics not found");
      return;
    }

    // Get the latest date from the device
    int latestDeviceTimestamp = int.parse(asciiValues(await latestDateCharacteristic.read()));
    print("Latest date:$latestDeviceTimestamp");
    DateTime latestDeviceDate = DateTime.fromMillisecondsSinceEpoch(latestDeviceTimestamp * 1000).toUtc();

    // Get the latest date from the app's database
    int? latestAppTimestamp = await dataDao.latestDataTimeStampOverall();
    DateTime latestAppDate = latestAppTimestamp != null
        ? DateTime.fromMillisecondsSinceEpoch(latestAppTimestamp, isUtc: true)
        : DateTime.now().subtract(const Duration(days: 20)); // Use 20 days before the latest date
    print("Latest date from DB:$latestAppDate");
    onSyncStart();

    // Sync data day by day
    DateTime currentDate = latestAppDate;
    while (currentDate.isBefore(latestDeviceDate) || currentDate.isAtSameMomentAs(latestDeviceDate)) {

      // Create a new DateTime object for the beginning of the day
      DateTime beginningOfDay = DateTime.utc(
          currentDate.year,
          currentDate.month,
          currentDate.day,
          0, 0, 0, 0, 0
      );

      int currentTimestamp = beginningOfDay.millisecondsSinceEpoch ~/ 1000;

      print("Writing file name: "+currentTimestamp.toString().codeUnits.toString());

      // Write the date to sync
      await syncCharacteristic.write(currentTimestamp.toString().codeUnits);

      // Read and process data for this day
      String asciiString = asciiValues(await syncCharacteristic.read());
      while (asciiString != "end") {
        if (asciiString != "ok") {
          List<String> elements = asciiString.split(",");
          await processAndSaveData(elements, nodeDao, dataDao);
        }
        asciiString = asciiValues(await syncCharacteristic.read());
      }

      // Move to the next day
      currentDate = currentDate.add(const Duration(days: 1));
    }

    onSyncEnd();
    await receiverDao.updateLastSync(receiverDevice.id!, DateTime.now().millisecondsSinceEpoch);
  }

  static String asciiValues(List<int> value) {
    String hexString = value.map((e) => e.toRadixString(16).padLeft(2, '0')).join(' ');
    List<int> asciiList = hexString.split(' ').map((e) => int.parse(e, radix: 16)).toList();
    return asciiList.map((e) => String.fromCharCode(e)).join('');
  }

  static Future<void> processAndSaveData(List<String> element, NodeDao nodeDao, DataDao dataDao) async {
    // Validate if element[0] is a positive integer
    int? nodeNid = int.tryParse(element[0]);
    if (nodeNid == null || nodeNid <= 0) {
      print('Invalid node ID: ${element[0]}. Must be a positive integer.');
    }else{
      List<Map<String, dynamic>> nodeToBeInserted = await nodeDao.getNodeById(
          element[0]);
      if (nodeToBeInserted.isEmpty) {
        Node newNode = Node(id: -1,
            nid: element[0],
            name: 'new node',
            receiverid: null,
            description: null);
        int newNodeId = await nodeDao.insertNode(newNode);
        nodeToBeInserted = [{'id': newNodeId}];
      }
      int nodeId = nodeToBeInserted[0]['id'] as int;

      double temp = double.tryParse(element[2]) ?? 0.0;
      double hum = double.tryParse(element[3]) ?? 0.0;
      double lux = double.tryParse(element[4]) ?? 0.0;
      double soil = double.tryParse(element[5]) ?? 0.0;
      int timestamp = int.tryParse(element[6]) ?? DateTime.now().millisecondsSinceEpoch;

      await dataDao.insertData(Data(nodeId: nodeId, dataTypeId: 1, value: temp, timestamp: timestamp));
      await dataDao.insertData(Data(nodeId: nodeId, dataTypeId: 2, value: hum, timestamp: timestamp));
      await dataDao.insertData(Data(nodeId: nodeId, dataTypeId: 3, value: lux, timestamp: timestamp));
      await dataDao.insertData(Data(nodeId: nodeId, dataTypeId: 4, value: soil, timestamp: timestamp));
    }
  }
}
