import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'bluetooth_manager.dart';

class BluetoothPage extends StatelessWidget {
  const BluetoothPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bluetooth = Provider.of<BluetoothManager>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Bluetooth Control")),
      body: Column(
        children: [
          bluetooth.isConnected
              ? const Text("✅ Conectat la Arduino", style: TextStyle(color: Colors.green))
              : const Text("🔍 Căutare dispozitiv BLE...", style: TextStyle(color: Colors.red)),
          ElevatedButton(
            onPressed: () => bluetooth.sendCommand("UP"),
            child: const Text("UP"),
          ),
          ElevatedButton(
            onPressed: () => bluetooth.sendCommand("DOWN"),
            child: const Text("DOWN"),
          ),
          ElevatedButton(
            onPressed: () => bluetooth.sendCommand("LEFT"),
            child: const Text("LEFT"),
          ),
          ElevatedButton(
            onPressed: () => bluetooth.sendCommand("RIGHT"),
            child: const Text("RIGHT"),
          ),
        ],
      ),
    );
  }
}
