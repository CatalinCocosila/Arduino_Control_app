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
  final String remoteUrl =
      "https://catalincocosila.github.io/blockly-web/index.html"; // GitHub Pages

  @override
  void initState() {
    super.initState();
    initWebView();
  }

  /// Inițializare WebView și configurare controller
  void initWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'BlocBlocklyChannel', // Actualizat pentru a se potrivi cu HTML
        onMessageReceived: (message) {
          String command = message.message.trim();
          debugPrint("✅ [FLUTTER] Comandă primită din Blockly: $command");
          final bluetooth =
              Provider.of<BluetoothManager>(context, listen: false);

          if (bluetooth.isConnected) {
            bluetooth.sendCommand(command);
            debugPrint("✅ [FLUTTER] Comandă trimisă la Arduino: $command");
          } else {
            debugPrint(
                "⚠️ [FLUTTER] Bluetooth nu este conectat! Încerc reconectarea...");
            bluetooth.scanAndConnect();
          }
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            debugPrint("✅ WebView încărcat: $url");
            injectConsoleInterceptor();
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint(
                "❌ Eroare WebView: ${error.errorType} - ${error.description}");
            Future.delayed(const Duration(seconds: 2), () => loadBlockly());
          },
        ),
      );

    loadBlockly();
  }

  /// Injectează un script JavaScript pentru a intercepta `console.log` și a trimite mesajele la Flutter
  void injectConsoleInterceptor() {
    _controller.runJavaScript('''
      (function() {
        var oldLog = console.log;
        console.log = function(message) {
          oldLog(message);
          if (window.BlocBlocklyChannel) {
            window.BlocBlocklyChannel.postMessage(message);
          }
        };
      })();
    ''');
  }

  /// Încarcă pagina Blockly din GitHub Pages
  void loadBlockly() {
    debugPrint("🔍 Încerc să încarc WebView de la: $remoteUrl");
    try {
      _controller.loadRequest(Uri.parse(remoteUrl));
    } catch (e) {
      debugPrint("⚠️ Eroare la încărcarea WebView: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final bluetooth = Provider.of<BluetoothManager>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Blockly Robot Controller")),
      body: Column(
        children: [
          bluetooth.isConnected
              ? const Text("✅ Conectat la Arduino",
                  style: TextStyle(color: Colors.green))
              : const Text("🔍 Căutare dispozitiv BLE...",
                  style: TextStyle(color: Colors.red)),
          Expanded(child: WebViewWidget(controller: _controller)),
        ],
      ),
    );
  }
}
