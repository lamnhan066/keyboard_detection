import 'package:flutter/material.dart';
import 'package:keyboard_detection/keyboard_detection.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isKeyboardOpened = false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: KeyboardDetection(
        timerDuration: const Duration(milliseconds: 10),
        onChanged: (value) {
          print('Is Keyboard Opened: $value');
          setState(() {
            isKeyboardOpened = value;
          });
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Keyboard Detection'),
          ),
          body: Center(
            child: Text('Is Keyboard Opened: $isKeyboardOpened'),
          ),
        ),
      ),
    );
  }
}
