# Keyboard Detection

This plugin gives you an easy way to detect if the keyboard is visible or not. It uses the resizing of the bottom view inset to check the the keyboard visibility, so it's native to flutter.

## Usage

You just need to wrap the Scaffold with KeyboardDetection like below and listen to `onChanged` value.

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
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Keyboard Detection'),
          ),
          body: Center(
            child: Text('Is Keyboard Opened: $isKeyboardOpened'),
          ),
        ),
      ),
    );
  }
```

`onChanged` will be `true` if the keyboard is visible and `false` otherwise.

`timerDuration` is the time interval between 2 checks. Default is 100 milliseconds.
