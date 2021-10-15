/// ***************************************************
/// Copyright 2019-2020 eBay Inc.
///
/// Use of this source code is governed by a BSD-style
/// license that can be found in the LICENSE file or at
/// https://opensource.org/licenses/BSD-3-Clause
/// ***************************************************
///

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../sample_widgets.dart';

void main() {
  group('Shadows Tests', () {
    setUp(() {
      expect(debugDisableShadows, isTrue,
          reason: 'debugDisableShadows should always be true before test');
    });

    tearDown(() {
      expect(debugDisableShadows, isTrue,
          reason: 'debugDisableShadows should always be true after test');
    });

    testGoldens(
        'screenMatchesGolden method uses enableRealShadows from global configuration (flutter_test_config.dart)',
        (tester) async {
      await tester.pumpWidgetBuilder(const WidgetWithShadows());
      await screenMatchesGolden(tester, 'realShadows_enabled_globally');

      expect(debugDisableShadows, isFalse,
          reason: 'debugDisableShadows should be false during test');
    });

    // wraping needs to happen outside of testGoldens
    GoldenToolkit.runWithConfiguration(
      () => {
        testGoldens(
            'screenMatchesGolden method can disable enableRealShadows temporarily',
            (tester) async {
          await tester.pumpWidgetBuilder(const WidgetWithShadows());
          await screenMatchesGolden(tester, 'realShadows_disabled_locally');

          expect(debugDisableShadows, isTrue,
              reason: 'debugDisableShadows should be false during test');
        })
      },
      config: GoldenToolkit.configuration.copyWith(enableRealShadows: false),
    );
  });
}
