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

  /// Inițiază scanarea și conectarea la dispozitivul Bluetooth
  Future<void> scanAndConnect() async {
    debugPrint("🔍 Încep scanarea BLE...");
    FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));

    FlutterBluePlus.scanResults.listen((results) async {
      for (ScanResult r in results) {
        if (r.device.platformName == "Robot_Arduino") {
          debugPrint("✅ Dispozitiv găsit: ${r.device.platformName}");
          device = r.device;
          await connectToDevice();
          FlutterBluePlus.stopScan();
          break;
        }
      }
    });
  }

  /// Se conectează la dispozitivul găsit
  Future<void> connectToDevice() async {
    if (device == null) {
      debugPrint("❌ Eroare: Nu există dispozitiv selectat pentru conectare!");
      return;
    }

    try {
      debugPrint("🔗 Încerc conectarea la ${device!.platformName}...");
      await device!.connect();
      List<BluetoothService> services = await device!.discoverServices();

      for (BluetoothService service in services) {
        if (service.uuid.toString().toLowerCase() == serviceUuid) {
          for (BluetoothCharacteristic c in service.characteristics) {
            if (c.uuid.toString().toLowerCase() == characteristicUuid) {
              characteristic = c;
              isConnected = true;
              notifyListeners();
              debugPrint(
                  "✅ Conectat la dispozitiv și caracteristică Bluetooth!");
              return;
            }
          }
        }
      }
    } catch (e) {
      debugPrint("❌ Eroare la conectare: $e");
    }
  }

  /// Trimite o comandă către dispozitivul Bluetooth
  void sendCommand(String command) async {
    if (!isConnected || characteristic == null) {
      debugPrint(
          "⚠️ Bluetooth nu este conectat, comanda '$command' a fost ignorată.");
      return;
    }

    try {
      debugPrint("📡 Trimit comanda către Arduino: $command");
      await characteristic!.write(command.codeUnits);
    } catch (e) {
      debugPrint("❌ Eroare la trimiterea comenzii: $e");
    }
  }

  /// Deconectează dispozitivul Bluetooth
  Future<void> disconnect() async {
    if (device != null && isConnected) {
      await device!.disconnect();
      isConnected = false;
      characteristic = null;
      notifyListeners();
      debugPrint("🔌 Dispozitiv deconectat.");
    }
  }
}
