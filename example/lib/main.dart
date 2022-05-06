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
  bool isKeyboardVisible = false;

  late KeyboardDetectionController keyboardDetectionController;

  @override
  void initState() {
    keyboardDetectionController = KeyboardDetectionController(
      timerDuration: const Duration(milliseconds: 10),
      onChanged: (value) {
        print('Keyboard visibility onChanged: $value');
        setState(() {
          isKeyboardVisible = value;
        });
      },
    );

    keyboardDetectionController.asStream.listen((isVisible) {
      print('Listen from stream: $isVisible');
    });

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
                Text('Is keyboard visible: $isKeyboardVisible'),
                Text(
                  'Get current state: ${keyboardDetectionController.currentState}',
                ),
                Text(
                  'Get current KeyboardState: ${keyboardDetectionController.keyboardState}',
                ),
                const TextField(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
