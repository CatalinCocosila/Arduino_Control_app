import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'bluetooth_manager.dart';
import 'bluetooth_page.dart';
import 'blockly_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => BluetoothManager()..scanAndConnect(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Robot Controller',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
      routes: {
        '/bluetooth': (context) => const BluetoothPage(),
        '/blockly': (context) => const BlocklyPage(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Robot Controller")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/bluetooth');
              },
              child: const Text("📡 Control prin Bluetooth"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/blockly');
              },
              child: const Text("🛠 Programare cu Blockly"),
            ),
          ],
        ),
      ),
    );
  }
}
