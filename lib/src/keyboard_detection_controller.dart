part of 'keyboard_detection.dart';

enum KeyboardState { unknown, visible, hidden }

class KeyboardDetectionController {
  /// Controller of the keyboard visibility.
  ///
  /// `onChanged`: This value will be notified when the keyboard is visible (`true`) or not (`false`).
  ///
  /// `timerDuration`: The time interval between 2 checks. Default is 100 milliseconds.
  KeyboardDetectionController({
    this.onChanged,
    @Deprecated('Do not need to use this value since version 0.3.0')
        this.timerDuration = const Duration(milliseconds: 100),
    this.minDifferentSize = 0,
  }) {
    _asStreamSubscription = asStream.listen((currentStateStream) {
      _currentState = currentStateStream;

      if (onChanged != null) {
        onChanged!(currentStateStream);
      }
    });
  }

  /// Controller for the keyboard visibility stream.
  final StreamController<bool> _streamController = StreamController.broadcast();

  /// Control the asStream listener.
  StreamSubscription<bool>? _asStreamSubscription;

  /// Control the state of the keyboard visibility.
  bool? _currentState;

  /// This value will be notified when the keyboard is visible (`true`) or not (`false`).
  final Function(bool)? onChanged;

  /// The time interval between 2 checks. Default is 100 milliseconds.
  @Deprecated('Do not need to use this value since version 0.3.0')
  final Duration timerDuration;

  /// The minimun difference between the current size and the last size of bottom view inset.
  ///
  /// When the keyboard's showing up, the size of bottom view inset will be changed
  /// and the plugin will use `minDifferentSize` to compare the changing of size
  /// to notify the keyboard visibility.
  final double minDifferentSize;

  /// Get the current keyboard state stream.
  Stream<bool> get asStream => _streamController.stream.asBroadcastStream();

  /// Get current state of the keyboard visibility.
  ///
  /// `null`: Unknown state because the plugin isn't initialized.
  /// `true`: Visible.
  /// `false`: Hidden (not visible).
  bool? get currentState => _currentState;

  /// Get current state of the keyboard visibility is `KeyboardState`.
  ///
  /// `KeyboardState.unknown`: Unknown state because the plugin isn't initialized.
  /// `KeyboardState.visible`: Visible.
  /// `KeyboardState.hidden`: Hidden (not visible).
  KeyboardState get keyboardState => _currentState == null
      ? KeyboardState.unknown
      : _currentState!
          ? KeyboardState.visible
          : KeyboardState.hidden;

  /// Close unused variables after dispose. Internal use only.
  void _close() {
    _asStreamSubscription?.cancel();
    _streamController.close();
  }
}

/// This allows a value of type T or T?
/// to be treated as a value of type T?.
///
/// We use this so that APIs that have become
/// non-nullable can still be used with `!` and `?`
/// to support older versions of the API as well.
T? _ambiguate<T>(T? value) => value;
