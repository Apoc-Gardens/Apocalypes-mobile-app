import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothUtils {
  static void scanForDevice(String MAC, Function(BluetoothDevice) onDeviceFound) {
    FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult result in results) {
        if (result.device.remoteId.toString() == MAC) {
          FlutterBluePlus.stopScan();
          onDeviceFound(result.device);
        }
      }
    });
    FlutterBluePlus.startScan(
      withServices: [Guid('8292fed4-e037-4dd7-b0c8-c8d7c80feaae')],
      timeout: const Duration(seconds: 10),
    );
  }
}
