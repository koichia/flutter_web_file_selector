import 'package:cross_file/cross_file.dart';
import 'package:flutter/widgets.dart';

class WebFileSelectorPlatformView {
  static bool isIOSWeb() {
    return false;
  }

  static WebFileSelectorPlatformView newInstance() {
    return WebFileSelectorPlatformView();
  }

  Widget build(
    BuildContext context, {
    required void Function(List<XFile> files)? onData,
    required Widget child,
    String? accept,
    bool? multiple,
  }) {
    return child;
  }
}
