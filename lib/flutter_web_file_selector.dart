import 'package:flutter/widgets.dart';

import 'src/flutter_web_file_selector_platform_view_none.dart'
    if (dart.library.js_interop) 'src/flutter_web_file_selector_platform_view_web.dart';

import 'src/web_file.dart';

export 'src/web_file.dart' show WebFile;

/// Enables selecting files on the web platform.
///
/// Example:
/// ```dart
/// @override
/// Widget build(BuildContext context) {
///   // ...
///
///   Widget button = ElevatedButton(
///     onPressed: () {
///       if (!WebFileSelector.isIOSWeb) {
///         // Not iOS/iPadOS on the web platform
///         // Use file_picker or file_selector package to select files
///       }
///     },
///     child: const Text('Select Files'),
///   );
///
///   if (WebFileSelector.isIOSWeb) {
///     // iOS/iPadOS on the web platform
///
///     // Wrap the original button with WebFileSelector widget
///     button = WebFileSelector(
///       onData: (files) async {
///         // Received files from the web browser
///         for (final file in files) {
///           debugPrint('${file.name} (${file.size} bytes, mime: ${file.type})');
///
///           // You can get bytes from the file with these methods:
///           final bytes = await file.readAsBytes();
///           final stream = await file.openRead();
///           // ...
///         }
///       },
///       // The "accept" argument accepts the same value as the accept attribute in <input type="file">
///       // Reference: https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input/file#accept
///       accept: '.pdf, .png, .jpg, .jpeg, .tif, .tiff',
///       multiple: true,
///       child: button,
///     );
///   }
///
///   // ...
/// }
///
/// ```
class WebFileSelector extends StatefulWidget {
  /// Creates a new instance of the WebFileSelector class
  const WebFileSelector(
      {super.key,
      required this.onData,
      required this.child,
      this.accept,
      this.multiple});

  /// A callback function that is called when user selects files
  final void Function(List<WebFile> files)? onData;

  /// A child widget
  final Widget child;

  /// Accepts the same value as the accept attribute in &lt;input type="file"&gt;.
  ///
  /// Reference:
  /// https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input/file#accept
  final String? accept;

  /// Whether to let users select multiple files or not.
  final bool? multiple;

  /// Tells whether the code is running on a web browser on iOS/iPadOS.
  static final bool isIOSWeb = WebFileSelectorPlatformView.isIOSWeb();

  @override
  State<WebFileSelector> createState() => _WebFileSelectorState();
}

class _WebFileSelectorState extends State<WebFileSelector> {
  late final WebFileSelectorPlatformView _platformView;

  @override
  void initState() {
    super.initState();

    _platformView = WebFileSelectorPlatformView.newInstance();
  }

  @override
  Widget build(BuildContext context) {
    return _platformView.build(
      context,
      onData: widget.onData,
      child: widget.child,
      accept: widget.accept,
      multiple: widget.multiple,
    );
  }
}
