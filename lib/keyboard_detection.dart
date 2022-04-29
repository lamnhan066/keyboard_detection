import 'dart:async';

import 'package:flutter/material.dart';

/// This function using bottom view inset to check the the keyboard is
/// opened or closed.
class KeyboardDetection extends StatefulWidget {
  const KeyboardDetection({
    Key? key,
    required this.onChanged,
    required this.child,
    this.timerDuration = const Duration(milliseconds: 100),
  }) : super(key: key);

  /// This value will notify when the keyboard is opened or closed.
  final Function(bool isKeyboardOpened) onChanged;

  /// This is child widget.
  final Widget child;

  /// The time interval between 2 checks. Default is 100 milliseconds.
  final Duration timerDuration;

  @override
  State<KeyboardDetection> createState() => _KeyboardDetectionState();
}

class _KeyboardDetectionState extends State<KeyboardDetection> {
  Timer? _timer;
  double _lastBottomInset = 0;

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _timer = Timer.periodic(widget.timerDuration, (_) {
        final bottomInset = MediaQuery.of(context).viewInsets.bottom;
        if (bottomInset != _lastBottomInset) {
          if (bottomInset < _lastBottomInset) {
            _lastBottomInset = bottomInset;
            widget.onChanged(false);
          }
          if (bottomInset > _lastBottomInset) {
            _lastBottomInset = bottomInset;
            widget.onChanged(true);
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
