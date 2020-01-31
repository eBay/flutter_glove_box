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
    testWidgets('screenMatchesGolden should require testGoldens',
        (tester) async {
      await tester.pumpWidget(Container(height: 100, width: 100));

      await expectLater(() => screenMatchesGolden(tester, 'anything'),
          throwsA(isInstanceOf<TestFailure>()));
    });
  });
}
