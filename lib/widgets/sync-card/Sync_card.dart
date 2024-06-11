import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:intl/intl.dart';
import 'package:mybluetoothapp/dao/data_dao.dart';
import 'package:mybluetoothapp/dao/node_dao.dart';
import 'package:mybluetoothapp/dao/receiver_dao.dart';
import 'package:mybluetoothapp/models/receiver.dart';

import 'data_sync.dart';

class SyncCard extends StatefulWidget {
  const SyncCard({super.key});

  @override
  State<SyncCard> createState() => _SyncCardState();
}

class _SyncCardState extends State<SyncCard> {
  final ReceiverDao _receiverDao = ReceiverDao();
  final NodeDao _nodeDao = NodeDao();
  final DataDao _dataDao = DataDao();
  late Receiver receiverDevice;
  late BluetoothDevice bluetoothDevice;
  int lastSync = 0;
  bool isConnected = false;
  bool syncInProgress = false;

  @override
  void initState() {
    super.initState();
    getDevices();
  }

  Future<void> getDevices() async {
    List<Receiver> devices = await _receiverDao.getAllDevices();
    receiverDevice = devices[0];
    lastSync = receiverDevice.lastSynced ?? 0;
    print('ID: ${receiverDevice.id}, Name: ${receiverDevice.name}, MAC: ${receiverDevice.mac}, LastSync: ${receiverDevice.lastSynced}');
    connectToDevice(receiverDevice.mac);
  }

  Future<void> connectToDevice(String mac) async {
    bluetoothDevice = BluetoothDevice.fromId(mac);
    await bluetoothDevice.connect(timeout: const Duration(seconds: 15));
    if(bluetoothDevice.isConnected){
      setState(() {
        isConnected = true;
      });
    }else{
      isConnected = false;
    }
  }

  Future<void> syncData(BluetoothDevice bluetoothDevice) async {
    await DataSync.syncData(bluetoothDevice, _dataDao, _nodeDao, receiverDevice, _receiverDao, () {
      setState(() {
        lastSync = DateTime.now().millisecondsSinceEpoch;
        syncInProgress = true;
      });
    }, () {
      setState(() {
        syncInProgress = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0), // Border radius
        side: const BorderSide(
          color: Color(0xFFE4E4E4), // Border color
          width: 1.0, // Border thickness
        ),
      ),
      child: Container(
        color: const Color(0xFFCDE8DD),
        padding: const EdgeInsets.all(16.0), // Padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Receiver',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            if (isConnected)
                              const Padding(
                                padding: EdgeInsets.only(left: 8.0),
                                child: Icon(
                                  Icons.circle,
                                  color: Colors.green,
                                  size: 10,
                                ),
                              )
                            else
                              const Padding(
                                padding: EdgeInsets.only(left: 8.0),
                                child: Icon(
                                  Icons.circle,
                                  color: Colors.red,
                                  size: 10,
                                ),
                              )
                          ],
                        ),
                        Text(
                          syncInProgress
                              ? 'Syncing...'
                              : 'last sync: ${DateFormat('HH:mm').format(DateTime.fromMillisecondsSinceEpoch(lastSync))}',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                OutlinedButton(
                  onPressed: () {
                    if (isConnected) {
                      // if connected
                      syncData(bluetoothDevice);
                    } else {
                      // if not connected
                      connectToDevice(receiverDevice.mac);
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF0AA061),
                    side: const BorderSide(color: Color(0xFF0AA061), width: 1.0), // Outline color and thickness
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0), // Border radius
                    ),
                    padding: const EdgeInsets.all(6.0), // Padding
                  ),
                  child: Text(isConnected ? 'Sync Data' : 'Connect'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    FlutterBluePlus.stopScan();
    //bluetoothDevice.disconnect();
  }
}

