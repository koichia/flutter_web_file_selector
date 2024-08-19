# flutter_web_file_selector

A Flutter package to let you select files on the Web platform. It is made specifically to workaround the issue where the file selection popup menu on iOS/iPadOS web browsers are placed far away from where you have tapped. If you have experienced and annoyed by this issue, you can use this package to resolve it. Although this package can be used on all web platforms, I recommend using other popular & proven packages such as [file_picker](https://pub.dev/packages/file_picker) and [file_selector](https://pub.dev/packages/file_selector) for non-iOS Web platforms. I consider this flutter_web_file_selector as a temporary solution until these popular packages have a solution for the issue described above.

## Features

You might have come across with a situation where the file selection popup menu on iOS/iPadOS web browsers are positioned far away from where you tapped. With this package, the popup menu should be placed right next to the button you have tapped.

![Before](https://raw.githubusercontent.com/koichia/flutter_web_file_selector/main/images/before-after.png)


## Usage

To use this package, add `flutter_web_file_selector` as a [dependency in your pubspec.yaml file](https://flutter.dev/platform-plugins/).

```dart
import 'package:flutter_web_file_selector/flutter_web_file_selector.dart';
```

Then, wrap a widget (ElevatedButton, FloatingActionButton, etc.) with the WebFileSelector.

```dart
@override
Widget build(BuildContext context) {
  // ...

  Widget button = ElevatedButton(
    onPressed: () {
      if (!WebFileSelector.isIOSWeb) {
        // Not iOS/iPadOS on the web platform
        // Use file_selector or file_picker package to select files
      }
    },
    child: const Text('Select Files'),
  );

  if (WebFileSelector.isIOSWeb) {
    // iOS/iPadOS on the web platform

    // Wrap the original button with WebFileSelector widget
    button = WebFileSelector(
      onData: (files) async {
        // Received files from the web browser
        for (final XFile file in files) {
          debugPrint('${file.name} (MIME type: ${file.mimeType})');

          // You can get bytes from the file with these methods:
          final Uint8List bytes = await file.readAsBytes();
          final Stream<Uint8List> stream = file.openRead();
          // ...
        }
      },
      // The "accept" argument accepts the same value as the
      // accept attribute in <input type="file">.
      // https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input/file#accept
      accept: '.pdf, .png, .jpg, .jpeg, .tif, .tiff',
      multiple: true,
      child: button,
    );
  }

  return Scaffold(body: Center(child: button));
}
```
