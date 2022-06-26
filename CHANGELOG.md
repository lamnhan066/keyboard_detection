## 0.4.2+2

* Update README.

## 0.4.2+1

* Change LICENSE to MIT.

## 0.4.2

* Changed `minDifferentSize` default value back to 0 to avoid laggy issue.

## 0.4.1

* Fixed issue when using `pushAndRemoveUntil` to navigate to another page.

## 0.4.0

* [BREAKING CHANGE]: Removed `timerDuration` in `KeyboardDetectionController`.
* The `minDifferentSize` now works correctly and responses right after the bottom view insets satified the condition. Default value now is set to 100.
* Added `keyboardSize` and `isKeyboardSizeLoaded` to `KeyboardDetectionController` to get the keyboard size.

## 0.3.0

* Compatible with Flutter 3.0.
* Changed from using `Timer` to `didChangeMetrics` for listening to the changing of the bottom view insets.
* Added `minDifferentSize` parameter to `KeyboardDetectionController`, now you can set the minimum changed of size between two checks to detect the keyboard visibility. Default value is 0.
* [Deprecated]: Don't need to use `timerDuration` in `KeyboardDetectionController` since this version.

## 0.2.1

* Auto close usused resources after dispose.

## 0.2.0

* Added 3 variables to `KeyboardDetectionController` to get the current state of the keyboard visibility:
  * `currentState`: the current state of the keyboard visibility return in `bool?` (`null`: unknown, `true`: visible, `false`: hidden).
  * `keyboardState`: the current state of the keyboard visibility return in enum `KeyboardState` (`unknown`: unknown, `visible`: visible, `hidden`: hidden).
  * `asStream` to listen for keyboard visibility changing events in `bool`.

## 0.1.0

* Bug fixed: Now keyboard visibility only notify one time when changed.

* [BREAKING CHANGE]

  * Before:

  ``` dart
  @override
  Widget build(BuildContext context) {
  return MaterialApp(
      home: KeyboardDetection(
          timerDuration: const Duration(milliseconds: 10),
          onChanged: (value) {
              print('Is Keyboard Opened: $value');
              setState(() {
              isKeyboardOpened = value;
              });
          },
          child:
  ```

  * Now:

  ``` dart
  @override
  Widget build(BuildContext context) {
  return MaterialApp(
      home: KeyboardDetection(
          controller: KeyboardDetectionController(
              timerDuration: const Duration(milliseconds: 10),
              onChanged: (value) {
                  print('Is Keyboard Opened: $value');
                  setState(() {
                      isKeyboardOpened = value;
                  });
              },
          ),
          child:
  ```

## 0.0.1+1

* Initial release.
