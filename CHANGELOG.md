## 0.8.0

* Use `View` instead of `MediaQuery` to retrieve the bottom view inset (Thanks to @nazarrd for the idea).
* Update docs, example and README.

## 0.7.3

* Avoid queuing too much checks (Fixes [#3](https://github.com/lamnhan066/keyboard_detection/issues/3)).

## 0.7.2

* Improve the way to get the bottom inset.
* Update the size when the keyboard type is changed (Fixes [#2](https://github.com/lamnhan066/keyboard_detection/issues/2)).

## 0.7.1

* Improve the way to get the bottom inset.
* Remove the screenshot to decrease the size of the package.
* Update README.

## 0.7.0

* Update sdk version to `>=3.0.0 <4.0.0`.
* Remove all deprecated methods and variables.
* Change the variable name from `isIncludeStartChanging` to `includeTransitionalState`.

## 0.6.3

* Update comments.
* Update homepage URL.

## 0.6.2

* Release to stable.
* Add `visibling` and `hiding` to `KeyboardState`.
* Add `stateAsBool()` to get the current keyboard state as `bool`
* Change the parameter of `onChanged` from `bool` to `KeyboardState`.
* **Deprecated**:
  * Change sdk version to ">=2.18.0 <4.0.0".
  * `asStream` => `stream` or `addCallback`
  * `currentState` => `state` as `KeyboardState`
  * `keyboardSize` => `size`
  * `isKeyboardSizeLoaded` => `isSizeLoaded`
  * `ensureKeyboardSizeLoaded` => `ensureSizeLoaded`
  * `minDifferentSize` no need to use
  * `keyboardState` no need to use

## 0.6.0-rc.5

* Add method `addCallback` to add a callback to receive keyboard state changed events.

## 0.6.0-rc.4

* Change from `stateAsBool` to `stateAsBool([bool isIncludeStartChanging = false])`.
* Update screenshot.
* Update README.

## 0.6.0-rc.3

* Improve screenshot.

## 0.6.0-rc.2

* `ensureSizeLoaded` is now return `Future<void>`.
* Update README.

## 0.6.0-rc.1

* Change sdk version to ">=2.18.0 <4.0.0" and flutter version ">=3.3.0".
* Add visibling and hiding to KeyboardState
* Deprecate `minDifferentSize`, `asStream`, `currentState`, `keyboardState`, `keyboardSize`, `isKeyboardSizeLoaded`, `ensureKeyboardSizeLoaded`
* Add `state`, `stateAsBool`, `size`, `isSizeLoaded`, `ensureSizeLoaded`
* Change the parameter of `onChanged` from `bool` to `KeyboardState`

## 0.5.2

* Update `onChanged` return type to `void`.
* Use static variables to store keyboard size and ensure keyboard is loaded. (Just internal changing so don't affect to the current code).

## 0.5.1

* Fixes the issue related to `Future already completed`.

## 0.5.0

* Add `ensureKeyboardSizeLoaded` to `KeyboardDetectionController` to wait for the keyboard size asynchronous.
* Increase min sdk version to `2.17.0`.
* Remove useless code.

## 0.4.2+3

* Update dependencies.

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
