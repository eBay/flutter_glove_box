/// ***************************************************
/// Copyright 2019-2020 eBay Inc.
///
/// Use of this source code is governed by a BSD-style
/// license that can be found in the LICENSE file or at
/// https://opensource.org/licenses/BSD-3-Clause
/// ***************************************************

import 'dart:io';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:flutter_test/flutter_test.dart';

import 'sample_weather_widget.dart';

Future<void> main() async {
  group('Multi Screen Golden examples', () {
    testGoldens('Example of testing a responsive layout', (tester) async {
      await tester.pumpWidgetBuilder(WeatherForecast());
      await multiScreenGolden(
        tester,
        'weather_forecast',
        skip: !Platform.isMacOS,
      );
    });
  });
}
