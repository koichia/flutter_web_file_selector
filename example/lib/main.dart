import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_file_selector/flutter_web_file_selector.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _disabled = false;

  Future<void> _processFiles(List<WebFile> files) async {
    for (final file in files) {
      debugPrint('File: ${file.name} (${file.size} bytes, type: ${file.type})');

      // You can get bytes from the file with these methods:
      // final bytes = await file.readAsBytes();
      // final stream = await file.openRead();
      // ...
    }
  }

  Future<void> _selectFiles() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Not using flutter_web_file_selector'),
          content: const Text(
            'You can use other packages like file_selector or file_picker',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // 1. To use the flutter_web_file_selector package on all web browsers,
    //    you can just use kIsWeb.
    const useWebFileSelector = kIsWeb;
    // 2. To use the package only for web browsers running on iOS/iPadOS,
    //    you can use WebFileSelector.isIOSWeb instead.
    // final useWebFileSelector = WebFileSelector.isIOSWeb;

    // The "accept" argument in WebFileSelector accepts the same value as the
    // accept attribute in <input type="file">
    // https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input/file#accept
    const acceptedFileTypes = '.pdf, .png, .jpg, .jpeg, .tif, .tiff';

    // The "multiple" aregument controls whether to let users select
    // multiple files or not.
    const multipleFiles = true;

    // onPress event handler for buttons
    void Function()? onPressed;
    if (!_disabled) {
      onPressed = () {
        if (!useWebFileSelector) {
          // Not using the WebFileSelector.
          // Use other packages like file_selector or file_picker.
          _selectFiles();
        }
      };
    }

    // onData event handler for WebFileSelector widget
    void Function(List<WebFile> files)? onData;
    if (!_disabled) {
      onData = (files) => _processFiles(files);
    }

    // Create a "Select Files" button
    Widget selectFilesButton = ElevatedButton(
      onPressed: onPressed,
      child: const Text('Select Files'),
    );

    if (useWebFileSelector) {
      // Wrap the "Select Files" button with WebFileSelector widget
      selectFilesButton = WebFileSelector(
        onData: onData,
        accept: acceptedFileTypes,
        multiple: multipleFiles,
        child: selectFilesButton,
      );
    }

    // Create a floating action button
    Widget? floatingActionButton;
    if (!_disabled) {
      floatingActionButton = FloatingActionButton(
        onPressed: onPressed,
        tooltip: 'Select Files',
        child: const Icon(Icons.add),
      );

      if (useWebFileSelector) {
        // Wrap the floating action button with WebFileSelector widget
        floatingActionButton = WebFileSelector(
          onData: onData,
          accept: acceptedFileTypes,
          multiple: multipleFiles,
          child: floatingActionButton,
        );
      }
    }

    // Create a "Enable/Disable Buttons" button
    final toggleButton = ElevatedButton(
      onPressed: () => setState(() {
        // Toggle the Enable/Disable button
        _disabled = !_disabled;
      }),
      child: Text(_disabled ? 'Enable Buttons' : 'Disable Buttons'),
    );

    // Put them together
    return Scaffold(
      appBar: AppBar(
        title: const Text('flutter_web_file_selector Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Press one of the buttons to select files'),
            selectFilesButton, // "Select Files" button
            const SizedBox(height: 20),
            toggleButton, // "Enable/Disable Buttons" button
          ],
        ),
      ),
      floatingActionButton: floatingActionButton, // Floating action button
    );
  }
}
