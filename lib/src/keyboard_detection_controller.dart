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
    this.timerDuration = const Duration(milliseconds: 100),
  }) {
    asStream.listen((currentStateStream) {
      _currentState = currentStateStream;

      if (onChanged != null) {
        onChanged!(currentStateStream);
      }
    });
  }

  /// Controller for the keyboard visibility stream.
  final StreamController<bool> _streamController = StreamController.broadcast();

  /// Control the state of the keyboard visibility.
  bool? _currentState;

  /// This value will be notified when the keyboard is visible (`true`) or not (`false`).
  final Function(bool)? onChanged;

  /// The time interval between 2 checks. Default is 100 milliseconds.
  final Duration timerDuration;

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
}
