class KeyboardDetectionController {
  /// Controller of the keyboard visibility.
  ///
  /// `onChanged`: This value will be notified when the keyboard is visible (`true`) or not (`false`).
  ///
  /// `timerDuration`: The time interval between 2 checks. Default is 100 milliseconds.
  const KeyboardDetectionController({
    required this.onChanged,
    this.timerDuration = const Duration(milliseconds: 100),
  });

  /// This value will be notified when the keyboard is visible (`true`) or not (`false`).
  final Function(bool) onChanged;

  /// The time interval between 2 checks. Default is 100 milliseconds.
  final Duration timerDuration;
}
