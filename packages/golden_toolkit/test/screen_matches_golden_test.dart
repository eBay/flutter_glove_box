import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/src/testing_tools.dart';

void main() {
  testGoldens('Animation test with CustomPump', (tester) async {
    /// Example of a test that used [CustomPump] in order to test animation of CircularProgressIndicator
    await tester.pumpWidgetBuilder(
      const CircularProgressIndicator(),
      surfaceSize: const Size(60, 60),
    );

    await screenMatchesGolden(
      tester,
      'progress_animation_start',
      customPump: (tester) => tester.pump(const Duration(milliseconds: 100)),
    );

    await screenMatchesGolden(
      tester,
      'progress_animation_middle',
      customPump: (tester) => tester.pump(const Duration(milliseconds: 400)),
    );
  });

  group('Basic golden test for empty container', () {
    final squareContainer = Container(
      width: 100,
      height: 100,
      color: const Color.fromARGB(255, 36, 51, 66),
    );

    testGoldens('Pump widget traditionally', (tester) async {
      tester.binding.window.devicePixelRatioTestValue = 1.0;
      await tester.binding.setSurfaceSize(const Size(200, 200));
      await tester.pumpWidget(squareContainer);
      await screenMatchesGolden(tester, 'square_container');
    });

    testGoldens('Pump widgetBuilder with noWrap', (tester) async {
      /// Note: pumpWidgetBuilder will use [materialAppWrapper] by default.
      /// If you want no wrapper at all, pass **noWrap()**
      await tester.pumpWidgetBuilder(
        squareContainer,
        surfaceSize: const Size(200, 200),
        wrapper: noWrap(),
      );

      await screenMatchesGolden(tester, 'square_container');
    });

    testGoldens('Material widget with text', (tester) async {
      /// Example of a custom wrapper: in order to render fonts and text, we need Material
      /// Note: With [materialAppWrapper] you can also modify theme, platform, locales and etc.

      final widget = Container(
        color: const Color.fromARGB(255, 36, 51, 66),
        child: const Text(
          'SAMPLE',
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
      );

      await tester.pumpWidgetBuilder(
        widget,
        wrapper: materialAppWrapper(
          theme: ThemeData.light(),
          platform: TargetPlatform.android,
        ),
        surfaceSize: const Size(200, 200),
      );

      await screenMatchesGolden(tester, 'text_container');
    });

    testGoldens('Should be able to load images', (tester) async {
      await tester.pumpWidgetBuilder(
        Image.asset('images/image.png', package: 'sample_dependency'),
        wrapper: materialAppWrapper(
          theme: ThemeData.light(),
          platform: TargetPlatform.android,
        ),
        surfaceSize: const Size(200, 200),
      );

      await screenMatchesGolden(tester, 'golden_with_image');
    });
  });
}
