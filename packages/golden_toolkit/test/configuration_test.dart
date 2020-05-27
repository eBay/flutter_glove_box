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

void main() {
  group('GoldenToolkitConfiguration Tests', () {
    testGoldens('screenMatchesGolden method should defer skip to global configuration', (tester) async {
      GoldenToolkit.configure(GoldenToolkitConfiguration(skipGoldenAssertion: () => true));
      await tester.pumpWidget(Container());
      await screenMatchesGolden(tester, 'this_is_expected_to_skip');
    });

    testGoldens('screenMatchesGolden method level skip should trump global configuration', (tester) async {
      GoldenToolkit.configure(GoldenToolkitConfiguration(skipGoldenAssertion: () => false));
      await tester.pumpWidgetBuilder(Container());
      await screenMatchesGolden(tester, 'this_is_expected_to_skip', skip: true);
    });

    testGoldens('MultiScreenGolden method should defer skip to global configuration', (tester) async {
      GoldenToolkit.configure(GoldenToolkitConfiguration(skipGoldenAssertion: () => true));
      await tester.pumpWidgetBuilder(Container());
      await multiScreenGolden(tester, 'this_is_expected_to_skip');
    });

    testGoldens('MultiScreenGolden method level skip should trump global configuration', (tester) async {
      GoldenToolkit.configure(GoldenToolkitConfiguration(skipGoldenAssertion: () => false));
      await tester.pumpWidgetBuilder(Container());
      await multiScreenGolden(tester, 'this_is_expected_to_skip', skip: true);
    });

    testGoldens('screenMatchesGolden method defers primeAssets to global configuration', (tester) async {
      var globalPrimeCalledCount = 0;

      GoldenToolkit.configure(
        GoldenToolkitConfiguration(primeAssets: (WidgetTester tester, String name, Finder finder) async {
          globalPrimeCalledCount += 1;
          await defaultPrimeAssets(tester, name, finder);
        }),
      );

      await tester.pumpWidgetBuilder(Image.asset('images/sample_cloudy.png'));

      await screenMatchesGolden(tester, 'screen_matches_golden_defers_primeAssets');

      expect(globalPrimeCalledCount, 1);
    });

    testGoldens('screenMatchesGolden method level primeAssets trumps global configuration', (tester) async {
      var globalPrimeCalledCount = 0;
      var localPrimeCalledCount = 0;

      GoldenToolkit.configure(
        GoldenToolkitConfiguration(primeAssets: (_, __, ___) async => globalPrimeCalledCount += 1),
      );

      await tester.pumpWidgetBuilder(Image.asset('images/sample_cloudy.png'));

      await screenMatchesGolden(tester, 'screen_matches_golden_trumps_primeAssets',
          primeAssets: (WidgetTester tester, String name, Finder finder) async {
        localPrimeCalledCount += 1;
        await defaultPrimeAssets(tester, name, finder);
      });

      expect(globalPrimeCalledCount, 0);
      expect(localPrimeCalledCount, 1);
    });

    testGoldens('multiScreenGolden method defers primeAssets to global configuration', (tester) async {
      var globalPrimeCalledCount = 0;

      GoldenToolkit.configure(
        GoldenToolkitConfiguration(primeAssets: (WidgetTester tester, String name, Finder finder) async {
          globalPrimeCalledCount += 1;
          await defaultPrimeAssets(tester, name, finder);
        }),
      );

      await tester.pumpWidgetBuilder(Image.asset('images/sample_cloudy.png'));

      await multiScreenGolden(tester, 'multi_screen_golden_defers_primeAssets',
          devices: [const Device(size: Size(200, 200), name: 'custom')]);

      expect(globalPrimeCalledCount, 1);
    });

    testGoldens('multiScreenGolden method level primeAssets trumps global configuration', (tester) async {
      var globalPrimeCalledCount = 0;
      var localPrimeCalledCount = 0;

      GoldenToolkit.configure(
        GoldenToolkitConfiguration(primeAssets: (WidgetTester tester, String name, Finder finder) async {
          globalPrimeCalledCount += 1;
        }),
      );

      await tester.pumpWidgetBuilder(Image.asset('images/sample_cloudy.png'));

      await multiScreenGolden(tester, 'multi_screen_golden_trumps_primeAssets',
          primeAssets: (WidgetTester tester, String name, Finder finder) async {
        localPrimeCalledCount += 1;
        await defaultPrimeAssets(tester, name, finder);
      }, devices: [const Device(size: Size(200, 200), name: 'custom')]);

      expect(globalPrimeCalledCount, 0);
      expect(localPrimeCalledCount, 1);
    });

    test('Default Configuration', () {
      const config = GoldenToolkitConfiguration();
      expect(config.skipGoldenAssertion(), isFalse);
    });
  });
}
