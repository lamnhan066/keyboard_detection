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
          onChanged: (value) {
            print('Keyboard visibility onChanged: $value');
            setState(() {
              isKeyboardVisible = value;
            });
          },
          minDifferentSize: 100,
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
                Text(
                  'Is keyboard size loaded: ${keyboardDetectionController.isKeyboardSizeLoaded}',
                ),
                Text(
                  'Get keyboard size: ${keyboardDetectionController.keyboardSize}',
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

`minDifferentSize` is the minimum different size of bottom view insets between two checks. Default value is 0.

## Usage With Controller

You can declare the `controller` outside the `build` method like below:

```dart
  late KeyboardDetectionController keyboardDetectionController;

  @override
  void initState() {
    keyboardDetectionController = KeyboardDetectionController(
      onChanged: (value) {
        print('Keyboard visibility onChanged: $value');
        setState(() {
          isKeyboardVisible = value;
        });
      },
      minDifferentSize: 100,
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
                Text(
                  'Is keyboard size loaded: ${keyboardDetectionController.isKeyboardSizeLoaded}',
                ),
                Text(
                  'Get keyboard size: ${keyboardDetectionController.keyboardSize}',
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
* `keyboardDetectionController.keyboardSize` to get the keyboard size. Please notice that this value may returns 0 even when the keyboard state is visible because the keyboard needs time to show up completely. So that, you should call `keyboardDetectionController.isKeyboardSizeLoaded` to checks that the keyboard size is loaded or not.
