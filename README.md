# Keyboard Detection

This plugin gives you an easy way to detect if the keyboard is visible or not. It uses the resizing of the bottom view inset to check the the keyboard visibility, so it's native to flutter.

## Introduction

![Alt Text](https://raw.githubusercontent.com/vnniz/keyboard_detection/main/assets/Intro.webp)

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
              stateAsBool = keyboardDetectionController.stateAsBool();
              stateAsBoolWithParamTrue =
                  keyboardDetectionController.stateAsBool(true);
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
                Text(
                    'State as bool (isIncludeStartChanging = false): $stateAsBool'),
                Text(
                    'State as bool (isIncludeStartChanging = true): $stateAsBoolWithParamTrue'),
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
        stateAsBool = keyboardDetectionController.stateAsBool();
        stateAsBoolWithParamTrue =
                  keyboardDetectionController.stateAsBool(true);
      });
    },
  );

  // Listen to the stream
  _sub = keyboardDetectionController.stream.listen((state) {
    print('Listen to onChanged with Stream: $state');
  });

  // One time callback
  keyboardDetectionController.addCallback((state) {
    print('Listen to onChanged with one time Callback: $state');

    // End this callback by returning false
    return false;
  });

  // Looped callback
  keyboardDetectionController.addCallback((state) {
    print('Listen to onChanged with looped Callback: $state');

    // This callback will be looped
    return true;
  });

  // Looped with future callback
  keyboardDetectionController.addCallback((state) async {
    await Future.delayed(const Duration(milliseconds: 100));
    print('Listen to onChanged with looped future Callback: $state');

    // This callback will be looped
    return true;
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
              Text('State as bool (isIncludeStartChanging = false): $stateAsBool'),
              Text('State as bool (isIncludeStartChanging = true): $stateAsBoolWithParamTrue'),
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

* `keyboardDetectionController.stateAsBool([bool isIncludeStartChanging = false])`: the current state of the keyboard visibility return in `bool?` (`null`: unknown, `true`: visible, `false`: hidden). If the `isIncludeStartChanging` is `true` than it will return `true` even when the `state` is `visibling` and `false` when it's `hiding`.

* `keyboardDetectionController.addCallback(callback)` to add a callback to be called when the keyboard state is changed. If the callback returns `true` then it will be called eachtime the keyboard is changed, if `false` then it will be ignored. This `callback` also supports the `Future` method.
  
* `keyboardDetectionController.stream` to listen for keyboard visibility changing events in `KeyboardState`.
  
* `keyboardDetectionController.size` to get the keyboard size. Please notice that this value may returns 0 even when the keyboard state is visible because the keyboard needs time to show up completely. So that, you should call `keyboardDetectionController.isSizeLoaded` to checks that the keyboard size is loaded or not. From version `0.5.0`, you can wait for this value by using `await keyboardDetectionController.ensureSizeLoaded`.
