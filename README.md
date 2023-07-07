# Keyboard Detection

This plugin gives you an easy way to detect if the keyboard is visible or not. It uses the resizing of the bottom view inset to check the the keyboard visibility, so it's native to flutter.

## Introduction

![Alt Text](https://raw.githubusercontent.com/vnniz/keyboard_detection/main/assets/KeyboardDetectionIntro.webp)

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
              keyboardState = value;
              stateAsBool = keyboardDetectionController.stateAsBool;
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
                Text('State: $keyboardState'),
                const TextField(),
              ],
            ),
          ),
        ),
      ),
    );
  }
```

`onChanged` will be returned in enum `KeyboardState` (`unknown`: unknown, `visibling`: visibling, `visible`: visible, `hiding`: hiding, `hidden`: hidden).

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
        keyboardState = value;
        stateAsBool = keyboardDetectionController.stateAsBool;
      });
    },
  );

  keyboardDetectionController.stream.listen((state) {
    print('Listen to onChanged: $state');
  });

  super.initState();
}
```

and add it to `controller` inside `build` method:

``` dart
@override
Widget build(BuildContext context) {
  return KeyboardDetection(
    controller: keyboardDetectionController,
    child: Scaffold(
      appBar: AppBar(
        title: const Text('Keyboard Detection'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('State: $keyboardState'),
              Text('State as bool: $stateAsBool'),
              FutureBuilder(
                future: keyboardDetectionController.ensureKeyboardSizeLoaded,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                        'Keyboard size is loaded with size: ${keyboardDetectionController.keyboardSize}');
                  }

                  return const Text('Keyboard size is still loading');
                },
              ),
              const TextField(),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MyApp(),
                    ),
                  );
                },
                child: const Text('Navigate to another page'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const MyApp(),
                      ),
                      (_) => false);
                },
                child: const Text('Move to another page'),
              )
            ],
          ),
        ),
      ),
    ),
  );
}
```

You can get the current state of the keyboard visibility by using:

* `keyboardDetectionController.state`: the current state of the keyboard visibility return in enum `KeyboardState` (`unknown`: unknown, `visibling`: visibling, `visible`: visible, `hiding`: hiding, `hidden`: hidden).

* `keyboardDetectionController.stateAsBool`: the current state of the keyboard visibility return in `bool?` (`null`: unknown, `true`: completely visible, `false`: completely hidden).
  
* `keyboardDetectionController.stream` to listen for keyboard visibility changing events in `KeyboardState`.
  
* `keyboardDetectionController.size` to get the keyboard size. Please notice that this value may returns 0 even when the keyboard state is visible because the keyboard needs time to show up completely. So that, you should call `keyboardDetectionController.isSizeLoaded` to checks that the keyboard size is loaded or not. From version `0.5.0`, you can wait for this value by using `await keyboardDetectionController.ensureSizeLoaded`.
