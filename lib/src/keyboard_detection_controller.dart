part of 'keyboard_detection.dart';

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

typedef KeyboardDetectionCallback = FutureOr<bool> Function(
    KeyboardState state);

class KeyboardDetectionController {
  /// Controller of the keyboard visibility.
  ///
  /// `onChanged`: This value will be notified when the keyboard is visible (`true`) or not (`false`).
  KeyboardDetectionController({
    this.onChanged,
    this.minDifferentSize = 0,
  });

  /// This value will be notified when the keyboard is starting visible (`true`) or not (`false`).
  final void Function(KeyboardState state)? onChanged;

  /// The minimun difference between the current size and the last size of bottom view inset.
  ///
  /// When the keyboard's showing up, the size of bottom view inset will be changed
  /// and the plugin will use `minDifferentSize` to compare the changing of size
  /// to notify the keyboard visibility.
  @Deprecated('This parameter is not used anymore.')
  final double minDifferentSize;

  final List<KeyboardDetectionCallback> _keyboardDetectionCallbacks = [];

  /// Controller for the keyboard visibility stream.
  final StreamController<KeyboardState> _streamOnChangedController =
      StreamController.broadcast();

  /// Get the current keyboard state stream.
  @Deprecated('Use [stream] insteads.')
  Stream<bool> get asStream => _streamOnChangedController.stream.map((event) {
        if (event == KeyboardState.visible ||
            event == KeyboardState.visibling) {
          return true;
        }

        return false;
      });

  /// Get the current keyboard state stream.
  ///
  /// You can use [addCallback] to add a function as a callback to avoid forgeting
  /// to close the subscription.
  Stream<KeyboardState> get stream =>
      _streamOnChangedController.stream.asBroadcastStream();

  /// Get current state of the keyboard visibility.
  ///
  /// `null`: Unknown state because the plugin isn't initialized.
  /// `true`: Visibling or Visible.
  /// `false`: Hidding or Hidden (not visible).
  @Deprecated('Use [stateAsBool] insteads')
  bool? get currentState => stateAsBool(true);

  /// Control the state as bool
  bool? _stateAsBool;

  /// Get current state of the keyboard visibility.
  ///
  /// Returns:
  ///   `null`: Unknown state because the plugin isn't initialized.
  ///   [isIncludeStartChanging] == `false`:
  ///     - `true`: [KeyboardState.visible]
  ///     - `false`: [KeyboardState.hidden]
  ///   [isIncludeStartChanging] == `true`:
  ///     - `true`: [KeyboardState.visibling] or [KeyboardState.visible]
  ///     - `false`: [KeyboardState.hiding] or [KeyboardState.hidden]
  bool? stateAsBool([bool isIncludeStartChanging = false]) {
    if (_state == KeyboardState.unknown) {
      _stateAsBool = null;
    }

    if (isIncludeStartChanging) {
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

  /// Control the state of keyboard.
  // ignore: prefer_final_fields
  KeyboardState _state = KeyboardState.unknown;

  /// State of the Keyboard
  ///
  /// `unknown`
  /// `visibling`
  /// `visible`
  /// `hidding`
  /// `hidden`
  @Deprecated('Use [state] insteads.')
  KeyboardState get keyboardState => _state;

  /// State of the Keyboard
  ///
  /// `unknown`
  /// `visibling`
  /// `visible`
  /// `hidding`
  /// `hidden`
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
  @Deprecated('Use [size] insteads')
  double get keyboardSize => _keyboardSize ?? 0;

  /// Get the keyboard size. The keyboard must be visible at least 1 time to make this works.
  /// If not, this value will return 0. You can check to ensure the keyboard size is available
  /// via `isKeyboardSizeLoaded`.
  ///
  /// [NOTICE]: This value may be loaded after the keyboard visibility a little bit
  /// because the keyboard needs more time to be showed up completely. So that this value
  /// may still 0 when the `KeyboardState` is `visible`.
  double get size => _keyboardSize ?? 0;

  // Control the keyboard size state.
  static bool? _isKeyboardSizeLoaded;

  /// To ensure that the keyboard size is available.
  ///
  /// Use [ensureKeyboardSizeLoaded] to ensure that the keyboard is loaded as asynchronous.
  @Deprecated('Use [isSizeLoaded] insteads')
  bool get isKeyboardSizeLoaded => _isKeyboardSizeLoaded ?? false;

  /// To ensure that the keyboard size is available.
  ///
  /// Use [ensureSizeLoaded] to ensure that the keyboard is loaded as asynchronous.
  bool get isSizeLoaded => _isKeyboardSizeLoaded ?? false;

  /// Control the keyboard size state.
  static final Completer<bool> _ensureKeyboardSizeLoaded = Completer<bool>();

  /// Ensure that the keyboard size is loaded.
  @Deprecated('Use [ensureSizeLoaded] insteads')
  Future<bool> get ensureKeyboardSizeLoaded => _ensureKeyboardSizeLoaded.future;

  /// Ensure that the keyboard size is loaded.
  Future<void> get ensureSizeLoaded => _ensureKeyboardSizeLoaded.future;

  /// Add callback to be executed when the keyboard state changes.
  ///
  /// This callback will be notified when the keyboard state is changed
  /// until it returns `false`.
  void addCallback(KeyboardDetectionCallback callback) {
    _keyboardDetectionCallbacks.add(callback);
  }

  void _excuteCallbacks(KeyboardState state) {
    for (final callback in _keyboardDetectionCallbacks) {
      final Completer<bool> completer = Completer();
      completer.future.then((isLooped) {
        if (!isLooped) _keyboardDetectionCallbacks.remove(callback);
      });
      completer.complete(callback(state));
    }
  }

  /// Close unused variables after dispose. Internal use only.
  Future<void> _close() async {
    await _streamOnChangedController.close();
  }
}
