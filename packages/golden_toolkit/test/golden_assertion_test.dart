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
  group('testGoldens validation', () {
    testGoldens('screenMatchesGolden should require testGoldens',
        (tester) async {
      await tester.pumpWidgetBuilder(Container(height: 100, width: 100));

      await expectLater(() => screenMatchesGolden(tester, 'anything'),
          throwsA(isInstanceOf<TestFailure>()));
    });

    testGoldens('screenMatchesGolden filename should not include extension',
        (tester) async {
      await tester.pumpWidget(Container(height: 100, width: 100));

      await expectLater(() => screenMatchesGolden(tester, 'anything.png'),
          throwsAssertionError);
    });

    testGoldens(
        'Goldens for multiple sized devices should respect specified finder',
        (tester) async {
      // This is an example of how a larger widget tree can be pumped, but goldens can be created capturing just a certain child widget
      await tester.pumpWidgetBuilder(
        Container(
          height: 200,
          width: 200,
          color: Colors.black,
          child: Center(
            child: RepaintBoundary(
              child: Container(
                height: 100,
                width: 100,
                color: Colors.pink,
                key: const ValueKey('widget'),
              ),
            ),
          ),
        ),
      );

      await multiScreenGolden(
        tester,
        'by_finder_should_be_all_pink',
        finder: find.byKey(const ValueKey('widget')),
      );
    });
  });
}
