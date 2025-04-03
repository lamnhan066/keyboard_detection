# Keyboard Detection

Easily detect keyboard visibility in your Flutter app with this plugin. It leverages the resizing of the bottom view inset to determine keyboard visibility, ensuring a native Flutter experience.

## Introduction

<img src="https://raw.githubusercontent.com/lamnhan066/keyboard_detection/main/assets/Intro.webp" alt="Keyboard Detection Plugin" width="300"/>

## Features

- Detect keyboard visibility changes (`unknown`, `visibling`, `visible`, `hiding`, `hidden`).
- Access keyboard visibility state as an enum or boolean.
- Listen to keyboard visibility changes via callbacks or streams.
- Retrieve keyboard size when it is fully loaded.

## Simple Usage

Wrap your `Scaffold` with `KeyboardDetection` and listen to the `onChanged` value:

```dart
@override
Widget build(BuildContext context) {
  return MaterialApp(
    home: KeyboardDetection(
      controller: KeyboardDetectionController(
        onChanged: (value) {
          print('Keyboard visibility changed: $value');
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
              Text('State as bool (includeTransitionalState = false): $stateAsBool'),
              Text('State as bool (includeTransitionalState = true): $stateAsBoolWithParamTrue'),
              const TextField(),
            ],
          ),
        ),
      ),
    ),
  );
}
```

The `onChanged` callback returns a `KeyboardState` enum (`unknown`, `visibling`, `visible`, `hiding`, `hidden`).

## Advanced Usage with Controller

Declare the `KeyboardDetectionController` outside the `build` method for more control:

```dart
late KeyboardDetectionController keyboardDetectionController;

@override
void initState() {
  keyboardDetectionController = KeyboardDetectionController(
    onChanged: (value) {
      print('Keyboard visibility changed: $value');
      keyboardState = value;
    },
  );

  // Listen to the stream
  _sub = keyboardDetectionController.stream.listen((state) {
    print('Stream update: $state');
  });

  // Add one-time callback
  keyboardDetectionController.addCallback((state) {
    print('One-time callback: $state');
    return false;
  });

  // Add looped callback
  keyboardDetectionController.addCallback((state) {
    print('Looped callback: $state');
    return true;
  });

  // Add looped future callback
  keyboardDetectionController.addCallback((state) async {
    await Future.delayed(const Duration(milliseconds: 100));
    print('Looped future callback: $state');
    return true;
  });

  super.initState();
}
```

Use the controller in the `build` method:

```dart
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
              Text('State: ${keyboardDetectionController.state}'),
              FutureBuilder(
                future: keyboardDetectionController.ensureSizeLoaded,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text('Keyboard size loaded: ${keyboardDetectionController.size}');
                  }
                  return const Text('Loading keyboard size...');
                },
              ),
              const TextField(),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MyApp()),
                  );
                },
                child: const Text('Navigate to another page'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const MyApp()),
                      (_) => false,
                  );
                },
                child: const Text('Move to another page'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
```

### Controller Methods

- `keyboardDetectionController.state`: Get the current keyboard visibility state as a `KeyboardState` enum.
- `keyboardDetectionController.stateAsBool([bool includeTransitionalState = false])`: Get the keyboard visibility as a `bool?`. If `includeTransitionalState` is `true`, transitional states (`visibling`, `hiding`) are included.
- `keyboardDetectionController.addCallback(callback)`: Add a callback for state changes. Return `true` for repeated calls, `false` to stop.
- `keyboardDetectionController.stream`: Listen to keyboard visibility changes as a stream.
- `keyboardDetectionController.size`: Get the keyboard size. Use `keyboardDetectionController.ensureSizeLoaded` to ensure the size is loaded.

## Limitations

- This package uses the bottom inset to detect keyboard visibility, so it doesn't work with floating keyboards ([Issue #1](https://github.com/lamnhan066/keyboard_detection/issues/1)).

## Contributions

Contributions and feedback are welcome! Feel free to open issues or submit pull requests.
