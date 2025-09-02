part of 'keyboard_detection.dart';

/// Represents the state of the keyboard.
enum KeyboardState {
  /// Unknown state.
  unknown,

  /// Fully visible.
  visible,

  /// Transitioning to visible.
  visibling,

  /// Fully hidden.
  hidden,

  /// Transitioning to hidden.
  hiding;
}

/// Type definition for a callback function that handles keyboard state changes.
typedef KeyboardDetectionCallback = FutureOr<bool> Function(
    KeyboardState state);

/// Controller for detecting and managing keyboard visibility and state.
class KeyboardDetectionController {
  /// Creates a [KeyboardDetectionController].
  ///
  /// [onChanged]: A callback that is triggered when the keyboard state changes.
  KeyboardDetectionController({
    this.onChanged,
  });

  /// Callback triggered when the keyboard state changes.
  final void Function(KeyboardState state)? onChanged;

  /// List of registered callbacks to be executed on keyboard state changes.
  final List<KeyboardDetectionCallback> _keyboardDetectionCallbacks = [];

  /// Stream controller for broadcasting keyboard state changes.
  final StreamController<KeyboardState> _streamOnChangedController =
      StreamController.broadcast();

  /// Provides a stream of keyboard state changes.
  ///
  /// Use [addCallback] to register a callback instead of directly subscribing
  /// to avoid forgetting to close the subscription.
  Stream<KeyboardState> get stream =>
      _streamOnChangedController.stream.asBroadcastStream();

  /// Cached boolean representation of the keyboard state.
  bool? _stateAsBool;

  /// Returns the current keyboard visibility state as a boolean.
  ///
  /// - `null`: Unknown state (plugin not initialized).
  /// - [includeTransitionalState] == `false`:
  ///   - `true`: [KeyboardState.visible]
  ///   - `false`: [KeyboardState.hidden]
  /// - [includeTransitionalState] == `true`:
  ///   - `true`: [KeyboardState.visibling] or [KeyboardState.visible]
  ///   - `false`: [KeyboardState.hiding] or [KeyboardState.hidden]
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

  /// Current state of the keyboard.
  KeyboardState _state = KeyboardState.unknown;

  /// Returns the current keyboard state.
  ///
  /// Possible values:
  /// - [KeyboardState.unknown]: Unknown state.
  /// - [KeyboardState.visibling]: Transitioning to visible.
  /// - [KeyboardState.visible]: Fully visible.
  /// - [KeyboardState.hiding]: Transitioning to hidden.
  /// - [KeyboardState.hidden]: Fully hidden.
  KeyboardState get state => _state;

  /// Cached size of the keyboard.
  static double? _keyboardSize;

  /// Returns the current keyboard size.
  ///
  /// The keyboard must have been visible at least once for this value to be accurate.
  /// If not, it returns `0`. Use [isSizeLoaded] to check if the size is available.
  ///
  /// Note: The keyboard size may take some time to load completely after becoming visible.
  double get size => _keyboardSize ?? 0;

  /// Indicates whether the keyboard size has been loaded.
  ///
  /// Use [ensureSizeLoaded] to wait asynchronously until the size is available.
  bool get isSizeLoaded => _ensureKeyboardSizeLoaded.isCompleted;

  /// Completer to track the loading state of the keyboard size.
  static final Completer<bool> _ensureKeyboardSizeLoaded = Completer<bool>();

  /// Ensures that the keyboard size is loaded asynchronously.
  Future<void> get ensureSizeLoaded => _ensureKeyboardSizeLoaded.future;

  /// Registers a callback to be executed when the keyboard state changes.
  ///
  /// The callback will continue to be notified until it returns `false`.
  void addCallback(KeyboardDetectionCallback callback) {
    _keyboardDetectionCallbacks.add(callback);
  }

  /// Executes all registered callbacks with the given keyboard state.
  Future<void> _executeCallbacks(KeyboardState state) async {
    final callbacks =
        List<KeyboardDetectionCallback>.from(_keyboardDetectionCallbacks);

    final results = await Future.wait<(KeyboardDetectionCallback, bool)>(
      callbacks.map((callback) async {
        final isLooped = await callback(state);
        return (callback, isLooped);
      }),
    );

    for (final (callback, isLooped) in results) {
      if (!isLooped) {
        _keyboardDetectionCallbacks.remove(callback);
      }
    }
  }

  /// Updates the current keyboard state and notifies listeners.
  void _setKeyboardState(KeyboardState state) {
    _state = state;
    _streamOnChangedController.sink.add(state);
    if (onChanged != null) {
      onChanged!(state);
    }
    _executeCallbacks(state);
  }

  /// Updates the cached keyboard size.
  void _updateKeyboardSize(double size) {
    if (_keyboardSize != size) {
      _keyboardSize = size;
    }
  }

  /// Cleans up resources when the controller is disposed.
  Future<void> _close() async {
    await _streamOnChangedController.close();
  }
}
