import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'web_file.dart';

class WebFileNone implements WebFile {
  WebFileNone(Object file);

  @override
  String get name {
    throw UnsupportedError('Not supported on this platform');
  }

  @override
  int get size {
    throw UnsupportedError('Not supported on this platform');
  }

  @override
  String get type {
    throw UnsupportedError('Not supported on this platform');
  }

  @override
  DateTime get lastModifiedDate {
    throw UnsupportedError('Not supported on this platform');
  }

  @override
  Future<Uint8List> readAsBytes() {
    throw UnsupportedError('Not supported on this platform');
  }

  @override
  Future<Stream<List<int>>> openRead() {
    return readAsBytes().then((bytes) => Stream.value(List<int>.from(bytes)));
  }
}

class WebFileSelectorPlatformView {
  static bool isIOSWeb() {
    return false;
  }

  static WebFileSelectorPlatformView newInstance() {
    return WebFileSelectorPlatformView();
  }

  Widget build(
    BuildContext context, {
    required void Function(List<WebFile> files)? onData,
    required Widget child,
    String? accept,
    bool? multiple,
  }) {
    return child;
  }
}
