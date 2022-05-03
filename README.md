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
            print('Is Keyboard Opened: $value');
            setState(() {
              isKeyboardOpened = value;
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
                Text('Is Keyboard Opened: $isKeyboardOpened'),
                const TextField(),
              ],
            ),
          ),
        ),
      ),
    );
  }
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
        print('Is Keyboard Opened: $value');
        setState(() {
          isKeyboardOpened = value;
        });
      },
    );

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
                Text('Is Keyboard Opened: $isKeyboardOpened'),
                const TextField(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```
