import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class BluetoothPage extends StatefulWidget {
  const BluetoothPage({super.key});

  @override
  BluetoothPageState createState() => BluetoothPageState();
}

class BluetoothPageState extends State<BluetoothPage> {
  BluetoothDevice? device;
  BluetoothCharacteristic? characteristic;
  bool isConnected = false;

  final String serviceUuid = "12345678-1234-5678-1234-56789abcdef0";
  final String characteristicUuid = "12345678-1234-5678-1234-56789abcdef1";

  @override
  void initState() {
    super.initState();
    requestPermissions(); // ✅ Cere permisiunile înainte de scanare
  }

  void requestPermissions() async {
    var status =
        await [
          Permission.bluetooth,
          Permission.bluetoothScan,
          Permission.bluetoothConnect,
          Permission.location,
        ].request();

    if (status[Permission.bluetooth]!.isGranted &&
        status[Permission.bluetoothScan]!.isGranted &&
        status[Permission.bluetoothConnect]!.isGranted &&
        status[Permission.location]!.isGranted) {
      debugPrint("✅ Toate permisiunile sunt acordate!");
      scanForDevices(); // ✅ Începe scanarea BLE doar după ce permisiunile sunt acordate
    } else {
      debugPrint("⚠️ Permisiuni refuzate!");
    }
  }

  void scanForDevices() async {
    FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));

    FlutterBluePlus.scanResults.listen((results) async {
      for (ScanResult r in results) {
        debugPrint("🔍 Dispozitiv găsit: ${r.device.platformName}");
        if (r.device.platformName == "LED_Matrix") {
          device = r.device;
          await connectToDevice();
          FlutterBluePlus.stopScan();
          break;
        }
      }
    });
  }

  Future<void> connectToDevice() async {
    if (device == null) {
      debugPrint("❌ Niciun dispozitiv găsit!");
      return;
    }

    debugPrint("🔗 Conectare la ${device!.platformName}...");
    try {
      await device!.connect();
      debugPrint("✅ Conectat cu succes!");

      List<BluetoothService> services = await device!.discoverServices();
      for (BluetoothService service in services) {
        debugPrint("🔹 Serviciu găsit: ${service.uuid}");
        if (service.uuid.toString().toLowerCase() == serviceUuid) {
          for (BluetoothCharacteristic c in service.characteristics) {
            debugPrint("🔸 Caracteristică găsită: ${c.uuid}");
            if (c.uuid.toString().toLowerCase() == characteristicUuid) {
              characteristic = c;
              break;
            }
          }
        }
      }

      if (characteristic != null) {
        setState(() {
          isConnected = true;
        });
        debugPrint("✅ Dispozitiv BLE conectat și pregătit!");
      } else {
        debugPrint("⚠️ Caracteristica BLE nu a fost găsită!");
      }
    } catch (e) {
      debugPrint("❌ Eroare la conectare: $e");
    }
  }

  void sendCommand(String command) async {
    if (characteristic == null) {
      debugPrint("❌ Nu există caracteristică BLE!");
      return;
    }
    await characteristic!.write(command.codeUnits);
    debugPrint("📤 Trimite comandă: $command");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("BLE LED Matrix Control")),
      body: Column(
        children: [
          isConnected
              ? const Text(
                "✅ Conectat la Arduino",
                style: TextStyle(color: Colors.green),
              )
              : const Text(
                "🔍 Căutare dispozitiv BLE...",
                style: TextStyle(color: Colors.red),
              ),
          ElevatedButton(
            onPressed: () => sendCommand("ON"),
            child: const Text("Aprinde LED-uri"),
          ),
          ElevatedButton(
            onPressed: () => sendCommand("OFF"),
            child: const Text("Stinge LED-uri"),
          ),
        ],
      ),
    );
  }
}
