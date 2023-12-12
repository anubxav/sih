import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:pin_code_fields/pin_code_fields.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BluetoothChatApp(),
    );
  }
}

class BluetoothChatApp extends StatefulWidget {
  @override
  _BluetoothChatAppState createState() => _BluetoothChatAppState();
}

class _BluetoothChatAppState extends State<BluetoothChatApp> {
  final FlutterBlue flutterBlue = FlutterBlue.instance;
  IO.Socket? socket;
  TextEditingController messageController = TextEditingController();
  TextEditingController passcodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initSocket();
  }

  void initSocket() {
    // Replace 'YOUR_SOCKET_SERVER_URL' with your actual socket server URL
    socket = IO.io('YOUR_SOCKET_SERVER_URL', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    socket!.on('connect', (_) {
      print('Socket connected');
    });

    socket!.on('disconnect', (_) {
      print('Socket disconnected');
    });
  }

  void startBluetoothScan() {
    flutterBlue.startScan(timeout: Duration(seconds: 4));

    flutterBlue.scanResults.listen((results) {
      for (ScanResult r in results) {
        print('Found Bluetooth device: ${r.device.name}');
        // Handle Bluetooth devices here
      }
    });
  }

  void connectToDevice(BluetoothDevice device) async {
    await device.connect();

    // Implement Bluetooth device connection logic
  }

  void sendMessage(String message) {
    // Implement sending message over Bluetooth and socket
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bluetooth Chat App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: passcodeController,
              decoration: InputDecoration(labelText: 'Enter Passcode'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            PinCodeTextField(
              length: 4,
              controller: messageController,
              onChanged: (value) {
                // Handle passcode changes
              },
              appContext: context,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Implement passcode validation and connection logic
                startBluetoothScan();
              },
              child: Text('Connect Bluetooth'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Implement message sending logic
                sendMessage(messageController.text);
              },
              child: Text('Send Message'),
            ),
          ],
        ),
      ),
    );
  }
}
