import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_web_file_selector/flutter_web_file_selector.dart';

void main() {
  testWidgets(
    'WebFilesSelector widget test',
    (WidgetTester tester) async {
      debugPrint('kIsWeb: $kIsWeb');
      debugPrint('defaultTargetPlatform: $defaultTargetPlatform');

      if (kIsWeb) {
        expect(WebFileSelector.isIOSWeb, anything);
      } else {
        expect(WebFileSelector.isIOSWeb, false);
      }

      await tester.pumpWidget(Directionality(
        textDirection: TextDirection.ltr,
        child: WebFileSelector(
          onData: (files) {
            debugPrint('Received ${files.length} files');
          },
          accept: '.pdf, .png, .jpg, .jpeg, .jfif, .tif, .tiff',
          multiple: true,
          child: ElevatedButton(
            onPressed: () {},
            child: const Text('Test'),
          ),
        ),
      ));

      final buttonFinder = find.widgetWithText(ElevatedButton, 'Test');
      expect(buttonFinder, findsOneWidget);
      // await tester.tap(buttonFinder);

      await tester.pump();
    },
  );
}
