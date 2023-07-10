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
  KeyboardState keyboardState = KeyboardState.unknown;
  bool? stateAsBool;
  bool? stateAsBoolWithParamTrue;

  late KeyboardDetectionController keyboardDetectionController;

  @override
  void initState() {
    keyboardDetectionController = KeyboardDetectionController(
      onChanged: (value) {
        print('Keyboard visibility onChanged: $value');
        setState(() {
          keyboardState = value;
          stateAsBool = keyboardDetectionController.stateAsBool();
          stateAsBoolWithParamTrue =
              keyboardDetectionController.stateAsBool(true);
        });
      },
    );

    keyboardDetectionController.stream.listen((state) {
      print('Listen to onChanged: $state');
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
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('State: $keyboardState'),
                Text(
                    'State as bool (isIncludeStartChanging = false): $stateAsBool'),
                Text(
                    'State as bool (isIncludeStartChanging = true): $stateAsBoolWithParamTrue'),
                FutureBuilder(
                  future: keyboardDetectionController.ensureSizeLoaded,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(
                          'Keyboard size is loaded with size: ${keyboardDetectionController.size}');
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
      ),
    );
  }
}
