import 'dart:async';

import 'package:flutter/material.dart';

part 'keyboard_detection_controller.dart';

class KeyboardDetection extends StatefulWidget {
  /// A widget that detects keyboard visibility by monitoring changes in the bottom view inset.
  ///
  /// This implementation tracks the animation of keyboard appearance and disappearance
  /// to provide accurate state information through the controller.
  const KeyboardDetection({
    super.key,
    required this.controller,
    required this.child,
  });

  /// Controller that exposes keyboard state and size information.
  /// Use this to listen for keyboard visibility changes in child widgets.
  final KeyboardDetectionController controller;

  /// The widget to render within the keyboard detection wrapper.
  final Widget child;

  @override
  State<KeyboardDetection> createState() => _KeyboardDetectionState();
}

class _KeyboardDetectionState extends State<KeyboardDetection>
    with WidgetsBindingObserver {
  /// Maximum number of consecutive checks with the same insets before
  /// considering keyboard animation as completed.
  static const int maxSameInsetsCounter = 5;

  /// Time interval in milliseconds between consecutive bottom inset checks.
  static const checkInterval = Duration(milliseconds: 10);

  /// Most recently measured bottom inset value.
  double lastBottomInset = 0;

  /// The bottom inset value when keyboard animation finished.
  double lastFinishedBottomInset = 0;

  /// Flag indicating if keyboard size checking is in progress.
  bool isSizeChecking = false;

  /// Counter for how many consecutive times the insets remained unchanged.
  int sameInsetsCounter = 0;

  /// Flag to queue another check when current check is in progress.
  bool isQueue = false;

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

  /// Starts continuous monitoring of bottom insets until keyboard is fully
  /// visible or hidden.
  ///
  /// Uses a queuing mechanism to prevent multiple simultaneous checks.
  void bottomInsetsCheck() async {
    if (isSizeChecking) {
      isQueue = true;
      return;
    }
    isSizeChecking = true;

    Timer.periodic(checkInterval, (timer) {
      _bottomInsetsCheck();

      if (widget.controller.state == KeyboardState.hidden ||
          widget.controller.state == KeyboardState.visible) {
        timer.cancel();
        isSizeChecking = false;
        if (isQueue) {
          isQueue = false;
          bottomInsetsCheck();
        }
      }
    });
  }

  /// Core algorithm that processes bottom inset changes to determine keyboard state.
  ///
  /// This method:
  /// - Detects keyboard showing/hiding animations
  /// - Updates keyboard size in the controller
  /// - Determines when animations have completed
  /// - Triggers appropriate state changes in the controller
  void _bottomInsetsCheck() {
    if (!mounted) {
      return;
    }

    final view = View.maybeOf(context);
    if (view == null) {
      return;
    }

    final bottomInset = view.viewInsets.bottom / view.devicePixelRatio;
    final controller = widget.controller;

    if (controller.state == KeyboardState.visible &&
        bottomInset > lastBottomInset) {
      controller._setKeyboardState(KeyboardState.visibling);
    }

    if (bottomInset == lastBottomInset) {
      // Store the stabilized inset value for comparison with future values
      lastFinishedBottomInset = lastBottomInset;

      // Count consecutive stable measurements
      sameInsetsCounter++;

      if (sameInsetsCounter >= maxSameInsetsCounter) {
        // When stable for enough checks, update keyboard measurements
        if (lastFinishedBottomInset > 0) {
          controller._updateKeyboardSize(lastFinishedBottomInset);
        }

        // Mark that keyboard size has been successfully measured
        if (!KeyboardDetectionController
                ._ensureKeyboardSizeLoaded.isCompleted &&
            controller.size > 0) {
          KeyboardDetectionController._ensureKeyboardSizeLoaded.complete(true);
        }

        // Update state to hidden when keyboard is gone
        if (bottomInset == 0 && controller._state != KeyboardState.hidden) {
          controller._setKeyboardState(KeyboardState.hidden);
        }

        // Update state to visible when keyboard is fully shown
        if (controller.isSizeLoaded &&
            bottomInset > 0 &&
            controller._state != KeyboardState.visible) {
          controller._setKeyboardState(KeyboardState.visible);
        }

        // Reset stability counter after state update
        sameInsetsCounter = 0;
      }
    } else {
      // Reset counter when insets are changing
      sameInsetsCounter = 0;

      if ((bottomInset - lastFinishedBottomInset).abs() > 0) {
        // Detect keyboard hiding animation
        if (bottomInset < lastFinishedBottomInset &&
            controller._state != KeyboardState.hiding &&
            controller._state != KeyboardState.hidden) {
          controller._setKeyboardState(KeyboardState.hiding);
        }
        // Detect keyboard showing animation
        if (bottomInset > lastFinishedBottomInset &&
            controller._state != KeyboardState.visibling &&
            controller._state != KeyboardState.visible) {
          controller._setKeyboardState(KeyboardState.visibling);
        }
      }
    }
    lastBottomInset = bottomInset;
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
