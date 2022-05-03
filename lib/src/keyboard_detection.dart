import 'dart:async';

import 'package:flutter/material.dart';
import 'package:keyboard_detection/src/keyboard_detection_controller.dart';

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
  late KeyboardDetectionController _controller;

  // Control the timer
  Timer? _timer;

  // Initial value to ensure onChanged will recieve the first state.
  double _lastBottomInset = 1;

  // Last keyboard state.
  bool? _lastState;

  @override
  void initState() {
    _controller = widget.controller;
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _timer = Timer.periodic(_controller.timerDuration, (_) {
        final bottomInset = MediaQuery.of(context).viewInsets.bottom;
        if (bottomInset != _lastBottomInset) {
          if (bottomInset < _lastBottomInset && _lastState != false) {
            _lastBottomInset = bottomInset;
            _lastState = false;
            _controller.onChanged(false);
          }
          if (bottomInset > _lastBottomInset && _lastState != true) {
            _lastBottomInset = bottomInset;
            _lastState = true;
            _controller.onChanged(true);
          }
        }
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
