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
              FutureBuilder(
                future: keyboardDetectionController.ensureKeyboardSizeLoaded,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                        'Keyboard size is loaded with size: ${keyboardDetectionController.keyboardSize}');
                  }

                  return const Text('Keyboard size is still loading');
                },
              ),
              const TextField(),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MyApp(),
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
                        builder: (_) => const MyApp(),
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
