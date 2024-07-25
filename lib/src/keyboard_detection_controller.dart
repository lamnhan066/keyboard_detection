part of 'keyboard_detection.dart';

/// State of the keyboard.
enum KeyboardState {
  /// Unknow state.
  unknown,

  /// Completely visible.
  visible,

  /// Visibling.
  visibling,

  /// Completely hidden.
  hidden,

  /// Hiding.
  hiding;
}

/// Type of the callback.
typedef KeyboardDetectionCallback = FutureOr<bool> Function(
    KeyboardState state);

class KeyboardDetectionController {
  /// Controller of the keyboard visibility.
  ///
  /// `onChanged`: This value will be notified when the keyboard is visible (`true`) or not (`false`).
  KeyboardDetectionController({
    this.onChanged,
  });

  /// This value will be notified when the keyboard is starting visible (`true`) or not (`false`).
  final void Function(KeyboardState state)? onChanged;

  /// List of all callbacks.
  final List<KeyboardDetectionCallback> _keyboardDetectionCallbacks = [];

  /// Controller for the keyboard visibility stream.
  final StreamController<KeyboardState> _streamOnChangedController =
      StreamController.broadcast();

  /// Get the current keyboard state stream.
  ///
  /// You can use [addCallback] to add a function as a callback to avoid forgeting
  /// to close the subscription.
  Stream<KeyboardState> get stream =>
      _streamOnChangedController.stream.asBroadcastStream();

  /// The [KeyboardState] value as bool.
  bool? _stateAsBool;

  /// Get current state of the keyboard visibility.
  ///
  /// Returns:
  ///   `null`: Unknown state because the plugin isn't initialized.
  ///   [includeTransitionalState] == `false`:
  ///     - `true`: [KeyboardState.visible]
  ///     - `false`: [KeyboardState.hidden]
  ///   [includeTransitionalState] == `true`:
  ///     - `true`: [KeyboardState.visibling] or [KeyboardState.visible]
  ///     - `false`: [KeyboardState.hiding] or [KeyboardState.hidden]
  bool? stateAsBool([bool includeTransitionalState = false]) {
    if (_state == KeyboardState.unknown) {
      _stateAsBool = null;
    }

    if (includeTransitionalState) {
      if (_state == KeyboardState.visibling && _stateAsBool != true) {
        _stateAsBool = true;
      }

      if (_state == KeyboardState.hiding && _stateAsBool != false) {
        _stateAsBool = false;
      }
    }

    if (_state == KeyboardState.visible && _stateAsBool != true) {
      _stateAsBool = true;
    }

    if (_state == KeyboardState.hidden && _stateAsBool != false) {
      _stateAsBool = false;
    }

    return _stateAsBool;
  }

  /// Control the state of the keyboard.
  KeyboardState _state = KeyboardState.unknown;

  /// State of the Keyboard.
  ///
  /// [KeyboardState.unknown] : Unknown state
  /// [KeyboardState.visibling] : Visibling
  /// [KeyboardState.visible] : Visible
  /// [KeyboardState.hiding] : Hiding
  /// [KeyboardState.hidden] : Hidden
  KeyboardState get state => _state;

  /// Control the size of keyboard.
  static double? _keyboardSize;

  /// Get the keyboard size. The keyboard must be visible at least 1 time to make this works.
  /// If not, this value will return 0. You can check to ensure the keyboard size is available
  /// via `isKeyboardSizeLoaded`.
  ///
  /// [NOTICE]: This value may be loaded after the keyboard visibility a little bit
  /// because the keyboard needs more time to be showed up completely. So that this value
  /// may still 0 when the `KeyboardState` is `visible`.
  double get size => _keyboardSize ?? 0;

  /// To ensure that the keyboard size is available.
  ///
  /// Use [ensureSizeLoaded] to ensure that the keyboard is loaded as asynchronous.
  bool get isSizeLoaded => _ensureKeyboardSizeLoaded.isCompleted;

  /// Control the keyboard size state.
  static final Completer<bool> _ensureKeyboardSizeLoaded = Completer<bool>();

  /// Ensure that the keyboard size is loaded.
  Future<void> get ensureSizeLoaded => _ensureKeyboardSizeLoaded.future;

  /// Add callback to be executed when the keyboard state changes.
  ///
  /// This callback will be notified when the keyboard state is changed
  /// until it returns `false`.
  void addCallback(KeyboardDetectionCallback callback) {
    _keyboardDetectionCallbacks.add(callback);
  }

  /// Execute all callbacks
  void _executeCallbacks(KeyboardState state) {
    for (final callback in _keyboardDetectionCallbacks) {
      final Completer<bool> completer = Completer();
      completer.future.then((isLooped) {
        if (!isLooped) _keyboardDetectionCallbacks.remove(callback);
      });
      completer.complete(callback(state));
    }
  }

  void _setKeyboardState(KeyboardState state) {
    _state = state;
    _streamOnChangedController.sink.add(state);
    if (onChanged != null) {
      onChanged!(state);
    }
    _executeCallbacks(state);
  }

  void _updateKeyboardSize(double size) {
    if (_keyboardSize != size) {
      _keyboardSize = size;
    }
  }

  /// Close unused variables after dispose. Internal use only.
  Future<void> _close() async {
    await _streamOnChangedController.close();
  }
}
