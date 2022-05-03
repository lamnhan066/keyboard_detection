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

  late KeyboardDetectionController keyboardDetectionController;

  @override
  void initState() {
    keyboardDetectionController = KeyboardDetectionController(
      timerDuration: const Duration(milliseconds: 10),
      onChanged: (value) {
        print('Is Keyboard Opened: $value');
        setState(() {
          isKeyboardOpened = value;
        });
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: KeyboardDetection(
        controller: keyboardDetectionController,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Keyboard Detection'),
          ),
          body: Center(
            child: Column(
              children: [
                Text('Is Keyboard Opened: $isKeyboardOpened'),
                const TextField(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
