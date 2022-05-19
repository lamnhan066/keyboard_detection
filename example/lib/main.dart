// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:keyboard_detection/keyboard_detection.dart';

void main() {
  runApp(const MaterialApp(home: MyApp()));
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
      onChanged: (value) {
        print('Keyboard visibility onChanged: $value');
        setState(() {
          isKeyboardVisible = value;
        });
      },
      minDifferentSize: 100,
    );

    keyboardDetectionController.asStream.listen((isVisible) {
      print('Listen from stream: $isVisible');
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDetection(
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
              Text(
                'Is keyboard size loaded: ${keyboardDetectionController.isKeyboardSizeLoaded}',
              ),
              Text(
                'Get keyboard size: ${keyboardDetectionController.keyboardSize}',
              ),
              const TextField(),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AnotherPage(),
                    ),
                  );
                },
                child: const Text('Navigate to another page'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AnotherPage(),
                      ),
                      (_) => false);
                },
                child: const Text('Move to another page'),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class AnotherPage extends StatelessWidget {
  const AnotherPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KeyboardDetection(
        controller: KeyboardDetectionController(
          onChanged: (value) {
            print('Keyboard visibility onChanged: $value');
          },
          minDifferentSize: 100,
        ),
        child: Scaffold(
          appBar: AppBar(),
          body: Center(
            child: Column(
              children: const [
                TextField(),
              ],
            ),
          ),
        ));
  }
}
