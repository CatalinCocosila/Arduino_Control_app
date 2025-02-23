import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:provider/provider.dart';
import 'bluetooth_manager.dart';

class BlocklyPage extends StatefulWidget {
  const BlocklyPage({super.key});

  @override
  BlocklyPageState createState() => BlocklyPageState();
}

class BlocklyPageState extends State<BlocklyPage> {
  late WebViewController _controller;
  String blocklyOutput = "";

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'BlocklyChannel',
        onMessageReceived: (message) {
          setState(() {
            blocklyOutput = message.message;
          });
        },
      )
      ..loadFlutterAsset('assets/blockly/index.html');
  }

  void runBlocklyProgram(BluetoothManager bluetooth) async {
    if (blocklyOutput.isEmpty) return;
    
    List<String> commands = blocklyOutput.split(',');
    for (String command in commands) {
      bluetooth.sendCommand(command);
      await Future.delayed(const Duration(seconds: 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    final bluetooth = Provider.of<BluetoothManager>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Blockly Robot Programming")),
      body: Column(
        children: [
          Expanded(child: WebViewWidget(controller: _controller)),
          ElevatedButton(
            onPressed: () => runBlocklyProgram(bluetooth),
            child: const Text("Start Program"),
          ),
        ],
      ),
    );
  }
}
