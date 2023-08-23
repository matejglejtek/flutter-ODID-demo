import 'package:flutter/material.dart';
import 'dart:io';

import 'package:flutter_opendroneid/flutter_opendroneid.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter ODID Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter-ODID Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    FlutterOpenDroneId.allMessages.listen((pack) {
      setState(() {
        ++_counter;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Received ODID Messages',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (Platform.isIOS) {
            if (await Permission.bluetooth.request().isGranted) {
              FlutterOpenDroneId.startScan(UsedTechnologies.Bluetooth);
            }
          } else if (Platform.isAndroid) {
            final btStatus = await Permission.bluetooth.request();
            // scan makes sense just on android
            final btScanStatus = await Permission.bluetoothScan.request();
            if (btStatus.isGranted && btScanStatus.isGranted) {
              FlutterOpenDroneId.startScan(UsedTechnologies.Both);
            }
          } else {
            return;
          }
        },
        tooltip: 'start',
        child: const Text('Start'),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
