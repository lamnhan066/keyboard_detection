// ignore_for_file: avoid_print

import 'dart:async';

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
  KeyboardState keyboardState = KeyboardState.unknown;
  bool? stateAsBool;
  bool? stateAsBoolWithParamTrue;

  StreamSubscription<KeyboardState>? _sub;

  late KeyboardDetectionController keyboardDetectionController;

  @override
  void initState() {
    keyboardDetectionController = KeyboardDetectionController(
      onChanged: (value) {
        print('Keyboard visibility changed: $value');
        setState(() {
          keyboardState = value;
          stateAsBool = keyboardDetectionController.stateAsBool();
          stateAsBoolWithParamTrue =
              keyboardDetectionController.stateAsBool(true);
        });
      },
    );

    // Listen to the stream
    _sub = keyboardDetectionController.stream.listen((state) {
      print('Stream update: $state');
    });

    // Add one-time callback
    keyboardDetectionController.addCallback((state) {
      print('One-time callback: $state');
      return false;
    });

    // Add looped callback
    keyboardDetectionController.addCallback((state) {
      print('Looped callback: $state');
      return true;
    });

    // Add looped future callback
    keyboardDetectionController.addCallback((state) async {
      await Future.delayed(const Duration(milliseconds: 100));
      print('Looped future callback: $state');
      return true;
    });

    super.initState();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
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
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('State: $keyboardState'),
                Text(
                    'State as bool (includeTransitionalState = false): $stateAsBool'),
                Text(
                    'State as bool (includeTransitionalState = true): $stateAsBoolWithParamTrue'),
                FutureBuilder(
                  future: keyboardDetectionController.ensureSizeLoaded,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(
                          'Keyboard size loaded: ${keyboardDetectionController.size}');
                    }
                    return const Text('Loading keyboard size...');
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
                      (_) => false,
                    );
                  },
                  child: const Text('Move to another page'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
