## 0.1.0

* Bug fixed: Keyboard visibility only notify one time when changed.

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
