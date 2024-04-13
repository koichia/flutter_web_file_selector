import 'dart:js_interop' as js;
import 'dart:js_interop_unsafe';
import 'dart:ui_web' as ui_web;
import 'package:cross_file/cross_file.dart';
import 'package:flutter/widgets.dart';
import 'package:web/web.dart' as web;

class WebFileSelectorPlatformView {
  WebFileSelectorPlatformView._() : _viewType = _getNewViewType();

  static const _inputElementClassName = 'web-selector-file-upload-input';
  static const _buttonElementClassName = 'web-selector-file-upload-button';
  static int _currID = 0;

  void Function(List<XFile> files)? onData;
  final String _viewType;
  String? _accept;
  bool? _multiple;

  static bool isTouchEnabled() {
    return (web.document.hasProperty('ontouchend'.toJS).toDart);
  }

  static bool isIOSWeb() {
    // Web platform

    // Detect from  user agent string
    final userAgent = web.window.navigator.userAgent;

    if (userAgent.contains(' Chrome/')) {
      //
      // Chrome, Edge, Opera, Chromium, etc.
      //
      // Apple's browser doesn't have this embedded in the user agent string
      // This is true for iOS version of Chrome (CriOS), Edge (EdgiOS) &
      // Opera (OPT).
      //
      return false;
    } else if (userAgent.contains(' Firefox/')) {
      //
      // Firefox
      //
      // Apple's browser doesn't have this embedded in the user agent string
      // This is true for iOS version of Firefox (FxiOS).
      //
      return false;
    }

    if (userAgent.contains('(iPhone; ')) {
      // iPhone
      return true;
    } else if (userAgent.contains('(iPad; ')) {
      // iPadOS < 13
      return true;
    } else if (userAgent.contains('(Macintosh; ')) {
      // iPadOS >= 13, macOS

      // iPad has a touch capability whereas macOS does not (for now)
      if (isTouchEnabled()) {
        return true; // iPadOS >= 13
      } else {
        return false; // macOS
      }
    }

    return false; // Something else
  }

  static String _getNewViewType() {
    ++_currID;
    return 'web-file-selector-$_currID';
  }

  static WebFileSelectorPlatformView newInstance() {
    final platformView = WebFileSelectorPlatformView._();

    platformView._init();

    return platformView;
  }

  String? get accept {
    return _accept;
  }

  set accept(String? val) {
    final oldValue = _accept ?? '';
    final newValue = val ?? '';

    if (_accept != val || oldValue != newValue) {
      _accept = val;

      final elements =
          web.document.querySelectorAll('input.$_inputElementClassName');
      for (var idx = 0; idx < elements.length; ++idx) {
        final element = elements.item(idx) as web.Element;
        if (element is web.HTMLInputElement) {
          element.accept = _accept ?? '';
        }
      }
    }
  }

  bool? get multiple {
    return _multiple;
  }

  set multiple(bool? val) {
    final oldValue = _multiple ?? false;
    final newValue = val ?? false;

    if (_multiple != val || oldValue != newValue) {
      _multiple = val;

      final elements =
          web.document.querySelectorAll('input.$_inputElementClassName');
      for (var idx = 0; idx < elements.length; ++idx) {
        final element = elements.item(idx) as web.Element;
        if (element is web.HTMLInputElement) {
          element.multiple = _multiple ?? false;
        }
      }
    }
  }

  void _init() {
    ui_web.platformViewRegistry.registerViewFactory(
      _viewType,
      (int viewId) {
        final divElement = web.HTMLDivElement();
        divElement.style.width = '100%';
        divElement.style.height = '100%';

        // Add HTML input element
        {
          final inputElement = web.HTMLInputElement();
          inputElement.className = _inputElementClassName;

          inputElement.hidden = true.toJS;
          inputElement.type = 'file';
          inputElement.title = '';
          inputElement.accept = accept ?? '';
          inputElement.multiple = multiple ?? false;

          inputElement.onChange.listen((event) {
            if (onData != null) {
              final List<XFile> webFiles = [];

              final target = event.target;
              if (target != null) {
                if (target is web.HTMLInputElement) {
                  if (target.files != null) {
                    final files = target.files!;
                    for (var idx = 0; idx < files.length; ++idx) {
                      final file = files.item(idx);
                      if (file != null) {
                        webFiles.add(
                          XFile(
                            web.URL.createObjectURL(file),
                            name: file.name,
                            length: file.size,
                            lastModified: DateTime.fromMillisecondsSinceEpoch(
                              file.lastModified,
                            ),
                            mimeType: file.type,
                          ),
                        );
                      }
                    }
                  }

                  target.value = '';
                }
              }

              onData!(webFiles);
            }
          });

          divElement.append(inputElement);
        }

        // Add HTML button element
        {
          final buttonElement = web.HTMLButtonElement();
          buttonElement.className = _buttonElementClassName;

          buttonElement.text = '';
          buttonElement.style.opacity = '0';
          buttonElement.style.width = '100%';
          buttonElement.style.height = '100%';
          buttonElement.style.border = '0';
          buttonElement.style.backgroundColor = 'transparent';

          buttonElement.onClick.listen((event) {
            if (onData != null) {
              final target = event.target as web.HTMLElement;
              if (target.parentElement != null) {
                final parentElement = target.parentElement!;
                final element = parentElement
                    .querySelector('input.$_inputElementClassName');
                if (element != null) {
                  final inputElement = element;
                  if (inputElement is web.HTMLInputElement) {
                    inputElement.click();
                  }
                }
              }
            }
          });

          divElement.append(buttonElement);
        }

        return divElement;
      },
    );
  }

  Widget build(
    BuildContext context, {
    required void Function(List<XFile> files)? onData,
    required Widget child,
    String? accept,
    bool? multiple,
  }) {
    this.onData = onData;
    this.accept = accept;
    this.multiple = multiple;

    return IntrinsicWidth(
      child: IntrinsicHeight(
        child: Stack(
          children: [
            HtmlElementView(
              viewType: _viewType,
            ),
            child,
          ],
        ),
      ),
    );
  }
}
