part of 'keyboard_detection.dart';

enum KeyboardState { unknown, visible, hidden }

class KeyboardDetectionController {
  /// Controller of the keyboard visibility.
  ///
  /// `onChanged`: This value will be notified when the keyboard is visible (`true`) or not (`false`).
  ///
  /// `minDifferentSize`: The minimun changed of the bottom view insets to notify. Default value is 0.
  KeyboardDetectionController({
    this.onChanged,
    this.minDifferentSize = 0,
  }) {
    _asStreamSubscription = asStream.listen((currentStateStream) {
      _currentState = currentStateStream;

      if (onChanged != null) {
        onChanged!(currentStateStream);
      }
    });
  }

  /// This value will be notified when the keyboard is visible (`true`) or not (`false`).
  final void Function(bool)? onChanged;

  /// The minimun difference between the current size and the last size of bottom view inset.
  ///
  /// When the keyboard's showing up, the size of bottom view inset will be changed
  /// and the plugin will use `minDifferentSize` to compare the changing of size
  /// to notify the keyboard visibility.
  final double minDifferentSize;

  /// Controller for the keyboard visibility stream.
  final StreamController<bool> _streamController = StreamController.broadcast();

  /// Control the asStream listener.
  StreamSubscription<bool>? _asStreamSubscription;

  /// Get the current keyboard state stream.
  Stream<bool> get asStream => _streamController.stream.asBroadcastStream();

  /// Control the state of the keyboard visibility.
  bool? _currentState;

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

  // Control the size of keyboard.
  static double? _keyboardSize;

  /// Get the keyboard size. The keyboard must be visible at least 1 time to make this works.
  /// If not, this value will return 0. You can check to ensure the keyboard size is available
  /// via `isKeyboardSizeLoaded`.
  ///
  /// [NOTICE]: This value may be loaded after the keyboard visibility a little bit
  /// because the keyboard needs more time to be showed up completely. So that this value
  /// may still 0 when the `KeyboardState` is `visible`.
  double get keyboardSize => _keyboardSize ?? 0;

  // Control the keyboard size state.
  static bool? _isKeyboardSizeLoaded;

  /// To ensure that the keyboard size is available.
  ///
  /// Use [ensureKeyboardSizeLoaded] to ensure that the keyboard is loaded as asynchronous.
  bool get isKeyboardSizeLoaded => _isKeyboardSizeLoaded ?? false;

  // Control the keyboard size state.
  static final Completer<bool> _ensureKeyboardSizeLoaded = Completer<bool>();

  /// Ensure that the keyboard size is loaded
  Future<bool> get ensureKeyboardSizeLoaded => _ensureKeyboardSizeLoaded.future;

  /// Close unused variables after dispose. Internal use only.
  void _close() {
    _asStreamSubscription?.cancel();
    _streamController.close();
  }
}
