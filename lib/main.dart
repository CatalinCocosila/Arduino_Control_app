import 'package:flutter/material.dart';
import 'bluetooth_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); // ✅ Folosește super parameters

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BLE LED Control',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const BluetoothPage(),
    );
  }
}
