import 'dart:async';

import 'package:flutter/material.dart';

part 'keyboard_detection_controller.dart';

class KeyboardDetection extends StatefulWidget {
  /// This function uses the resizing of the bottom view inset to check the the keyboard visibility.
  const KeyboardDetection({
    super.key,
    required this.controller,
    required this.child,
  });

  /// The controller of the Keyboard Detection.
  final KeyboardDetectionController controller;

  /// This is child widget.
  final Widget child;

  @override
  State<KeyboardDetection> createState() => _KeyboardDetectionState();
}

class _KeyboardDetectionState extends State<KeyboardDetection>
    with WidgetsBindingObserver {
  static const int maxSameInsetsCounter = 5;
  static const int delayBettweenTwoCheck = 10; // milliseconds

  double lastBottomInset = 0;
  double lastFinishedBottomInset = 0;

  bool isSizeChecking = false;
  int sameInsetsCounter = 0;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      bottomInsetsCheck();
    });

    super.initState();
  }

  @override
  void dispose() {
    widget.controller._close();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    bottomInsetsCheck();
  }

  /// Listen to the changing metrics until the keyboard is completely
  /// visible or hidden
  void bottomInsetsCheck() {
    if (isSizeChecking) return;
    isSizeChecking = true;

    Timer.periodic(
      const Duration(milliseconds: delayBettweenTwoCheck),
      (timer) {
        _bottomInsetsCheck();

        if (widget.controller.state == KeyboardState.hidden ||
            widget.controller.state == KeyboardState.visible) {
          timer.cancel();
          isSizeChecking = false;
        }
      },
    );
  }

  void _bottomInsetsCheck() {
    if (!mounted) {
      return;
    }

    MediaQueryData? mediaQuery = MediaQuery.maybeOf(context);
    mediaQuery ??= MediaQueryData.fromView(View.of(context));

    final bottomInset = mediaQuery.viewInsets.bottom;
    final controller = widget.controller;

    if (bottomInset == lastBottomInset) {
      // Save max and min value of bottom insets for later comparing.
      lastFinishedBottomInset = lastBottomInset;

      // Increase the counter
      sameInsetsCounter++;

      // Get keyboard size from max bottom view insets size.
      if (lastFinishedBottomInset > controller.size) {
        KeyboardDetectionController._keyboardSize = lastFinishedBottomInset;
      }

      if (sameInsetsCounter >= maxSameInsetsCounter) {
        // Mark that the keyboard size is loaded.
        if (!KeyboardDetectionController
                ._ensureKeyboardSizeLoaded.isCompleted &&
            controller.size > 0) {
          KeyboardDetectionController._isKeyboardSizeLoaded = true;
          KeyboardDetectionController._ensureKeyboardSizeLoaded.complete(true);
        }

        // If the bottom insets size is 0 => No keyboard visible.
        if (bottomInset == 0 && controller._state != KeyboardState.hidden) {
          _setKeyboardState(KeyboardState.hidden);
        }

        // If the bottom insets size >.
        if (controller.isSizeLoaded &&
            bottomInset > 0 &&
            controller._state != KeyboardState.visible) {
          _setKeyboardState(KeyboardState.visible);
        }

        // Reset the counter when it's done.
        sameInsetsCounter = 0;
      }
    } else {
      // Reset the counter when there is different bettween 2 checks.
      sameInsetsCounter = 0;

      if ((bottomInset - lastFinishedBottomInset).abs() > 0) {
        if (bottomInset < lastFinishedBottomInset &&
            controller._state != KeyboardState.hiding &&
            controller._state != KeyboardState.hidden) {
          _setKeyboardState(KeyboardState.hiding);
        }
        if (bottomInset > lastFinishedBottomInset &&
            controller._state != KeyboardState.visibling &&
            controller._state != KeyboardState.visible) {
          _setKeyboardState(KeyboardState.visibling);
        }
      }
    }
    lastBottomInset = bottomInset;
  }

  void _setKeyboardState(KeyboardState state) {
    widget.controller._state = state;
    widget.controller._streamOnChangedController.sink.add(state);
    if (widget.controller.onChanged != null) {
      widget.controller.onChanged!(state);
    }
    widget.controller._executeCallbacks(state);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
