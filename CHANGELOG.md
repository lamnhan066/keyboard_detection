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
