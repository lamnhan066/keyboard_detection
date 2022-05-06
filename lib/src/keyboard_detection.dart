import 'dart:async';

import 'package:flutter/material.dart';

part 'keyboard_detection_controller.dart';

class KeyboardDetection extends StatefulWidget {
  /// This function uses the resizing of the bottom view inset to check the the keyboard visibility
  const KeyboardDetection({
    Key? key,
    required this.controller,
    required this.child,
  }) : super(key: key);

  /// The controller of the Keyboard Detection
  final KeyboardDetectionController controller;

  /// This is child widget.
  final Widget child;

  @override
  State<KeyboardDetection> createState() => _KeyboardDetectionState();
}

class _KeyboardDetectionState extends State<KeyboardDetection> {
  // Control the timer
  Timer? _timer;

  // Initial value to ensure onChanged will recieve the first state.
  double _lastBottomInset = 1;

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _timer = Timer.periodic(widget.controller.timerDuration, (_) {
        final bottomInset = MediaQuery.of(context).viewInsets.bottom;
        if (bottomInset != _lastBottomInset) {
          if (bottomInset < _lastBottomInset &&
              widget.controller._currentState != false) {
            _lastBottomInset = bottomInset;

            widget.controller._streamController.sink.add(false);
          }
          if (bottomInset > _lastBottomInset &&
              widget.controller._currentState != true) {
            _lastBottomInset = bottomInset;

            widget.controller._streamController.sink.add(true);
          }
        }
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.controller._streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
