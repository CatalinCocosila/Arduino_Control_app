import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter/material.dart';

class BluetoothManager extends ChangeNotifier {
  static final BluetoothManager _instance = BluetoothManager._internal();
  factory BluetoothManager() => _instance;

  BluetoothManager._internal();

  BluetoothDevice? device;
  BluetoothCharacteristic? characteristic;
  bool isConnected = false;

  final String serviceUuid = "12345678-1234-5678-1234-56789abcdef0";
  final String characteristicUuid = "12345678-1234-5678-1234-56789abcdef1";

  Future<void> scanAndConnect() async {
    FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));

    FlutterBluePlus.scanResults.listen((results) async {
      for (ScanResult r in results) {
        if (r.device.platformName == "Robot_Arduino") {
          device = r.device;
          await connectToDevice();
          FlutterBluePlus.stopScan();
          break;
        }
      }
    });
  }

  Future<void> connectToDevice() async {
    if (device == null) return;
    await device!.connect();
    List<BluetoothService> services = await device!.discoverServices();

    for (BluetoothService service in services) {
      if (service.uuid.toString().toLowerCase() == serviceUuid) {
        for (BluetoothCharacteristic c in service.characteristics) {
          if (c.uuid.toString().toLowerCase() == characteristicUuid) {
            characteristic = c;
            isConnected = true;
            notifyListeners();
            break;
          }
        }
      }
    }
  }

  void sendCommand(String command) async {
    if (characteristic != null) {
      await characteristic!.write(command.codeUnits);
    }
  }
}
