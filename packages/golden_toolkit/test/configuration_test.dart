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

    test('Default Configuration', () {
      const config = GoldenToolkitConfiguration();
      expect(config.skipGoldenAssertion(), isFalse);
    });
  });
}
