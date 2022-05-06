# Keyboard Detection

This plugin gives you an easy way to detect if the keyboard is visible or not. It uses the resizing of the bottom view inset to check the the keyboard visibility, so it's native to flutter.

## Simple Usage

You just need to wrap the `Scaffold` with `KeyboardDetection` like below and listen to `onChanged` value.

``` dart
@override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: KeyboardDetection(
        controller: KeyboardDetectionController(
          timerDuration: const Duration(milliseconds: 10),
          onChanged: (value) {
            print('Keyboard visibility onChanged: $value');
            setState(() {
              isKeyboardVisible = value;
            });
          },
        ),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Keyboard Detection'),
          ),
          body: Center(
            child: Column(
              children: [
                Text('Is keyboard visible: $isKeyboardVisible'),
                Text(
                  'Get current state: ${keyboardDetectionController.currentState}',
                ),
                Text(
                  'Get current KeyboardState: ${keyboardDetectionController.keyboardState}',
                ),
                const TextField(),
              ],
            ),
          ),
        ),
      ),
    );
  }
```

`onChanged` will be `true` if the keyboard is visible and `false` otherwise.

`timerDuration` is the time interval between 2 checks. Default is 100 milliseconds.

## Another Way

You can declare the `controller` outside the `build` method like below:

```dart
  late KeyboardDetectionController keyboardDetectionController;

  @override
  void initState() {
    keyboardDetectionController = KeyboardDetectionController(
      timerDuration: const Duration(milliseconds: 10),
      onChanged: (value) {
        print('Keyboard visibility onChanged: $value');
        setState(() {
          isKeyboardVisible = value;
        });
      },
    );

    keyboardDetectionController.asStream.listen((isVisible) {
      print('Listen from stream: $isVisible');
    });

    super.initState();
  }
```

and add it to `controller` inside `build` method:

``` dart
 @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: KeyboardDetection(
        controller: keyboardDetectionController,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Keyboard Detection'),
          ),
          body: Center(
            child: Column(
              children: [
                Text('Is keyboard visible: $isKeyboardVisible'),
                Text(
                  'Get current state: ${keyboardDetectionController.currentState}',
                ),
                Text(
                  'Get current KeyboardState: ${keyboardDetectionController.keyboardState}',
                ),
                const TextField(),
              ],
            ),
          ),
        ),
      ),
    );
  }
```

You can get the current state of the keyboard visibility by using:

* `keyboardDetectionController.currentState`: the current state of the keyboard visibility return in `bool?` (`null`: unknown, `true`: visible, `false`: hidden).
* `keyboardDetectionController.keyboardState`: the current state of the keyboard visibility return in enum `KeyboardState` (`unknown`: unknown, `visible`: visible, `hidden`: hidden).
* `keyboardDetectionController.asStream` to listen for keyboard visibility changing events in `bool`.
