/// ***************************************************
/// Copyright 2019-2020 eBay Inc.
///
/// Use of this source code is governed by a BSD-style
/// license that can be found in the LICENSE file or at
/// https://opensource.org/licenses/BSD-3-Clause
/// ***************************************************

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

Future<void> main() async {
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
  });

  group('pumpMaterialWidget - platform test ', () {
    testGoldens('BackButtonIcon should look rigth on Android', (tester) async {
      await tester.pumpWidgetBuilder(
        Row(children: const [BackButtonIcon(), Text('Android')]),
        wrapper: materialAppWrapper(
          platform: TargetPlatform.android,
          theme: ThemeData.light(),
        ),
        surfaceSize: const Size(80, 40),
      );
      await screenMatchesGolden(tester, 'back_button_android');
    });

    testGoldens('BackButtonIcon should look rigth on iOS', (tester) async {
      await tester.pumpWidgetBuilder(
        Row(children: const [BackButtonIcon(), Text('iOS')]),
        surfaceSize: const Size(80, 40),
        wrapper: materialAppWrapper(
          platform: TargetPlatform.iOS,
          theme: ThemeData.light(),
        ),
      );
      await screenMatchesGolden(tester, 'back_button_ios');
    });
  });
}
