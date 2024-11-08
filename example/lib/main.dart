import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _windowManagerPlugin = WindowManager();

  @override
  void initState() {
    super.initState();
    _windowManagerPlugin.tryToCaptureScreen().listen((event) {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: [
              FilledButton(
                child: const Text('Block'),
                onPressed: () {
                  _windowManagerPlugin.toggleScreenShot();
                },
              ),
              TextField(),
            ],
          ),
        ),
      ),
    );
  }
}
