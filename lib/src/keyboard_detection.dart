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

class _KeyboardDetectionState extends State<KeyboardDetection>
    with WidgetsBindingObserver {
  // Initial value to ensure onChanged will recieve the first state.
  double _lastBottomInset = 1;
  double _lastFinishedBottomInset = 1;

  @override
  void initState() {
    _ambiguate(WidgetsBinding.instance)!.addObserver(this);
    _lastBottomInset = widget.controller.minDifferentSize;
    _lastFinishedBottomInset = widget.controller.minDifferentSize;
    _bottomInsetCheck();
    super.initState();
  }

  @override
  void dispose() {
    _ambiguate(WidgetsBinding.instance)!.removeObserver(this);
    widget.controller._close();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    _bottomInsetCheck();
  }

  void _bottomInsetCheck() {
    _ambiguate(WidgetsBinding.instance)!.addPostFrameCallback((timeStamp) {
      if (!mounted) return;

      final bottomInset = MediaQuery.of(context).viewInsets.bottom;

      if (bottomInset == _lastBottomInset) {
        // Save max and min value of bottom insets for later comparing.
        _lastFinishedBottomInset = _lastBottomInset;

        // Get keyboard size from max bottom view insets size.
        if (_lastFinishedBottomInset >= widget.controller.minDifferentSize &&
            _lastFinishedBottomInset > widget.controller.keyboardSize) {
          widget.controller._keyboardSize = _lastFinishedBottomInset;
          widget.controller._isKeyboardSizeLoaded = true;
        }
      } else {
        if ((bottomInset - _lastFinishedBottomInset).abs() >=
            widget.controller.minDifferentSize) {
          if (bottomInset < _lastFinishedBottomInset &&
              widget.controller._currentState != false) {
            widget.controller._streamController.sink.add(false);
          }
          if (bottomInset > _lastFinishedBottomInset &&
              widget.controller._currentState != true) {
            widget.controller._streamController.sink.add(true);
          }
        }
      }
      _lastBottomInset = bottomInset;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
