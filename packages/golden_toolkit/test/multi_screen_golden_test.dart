/// ***************************************************
/// Copyright 2019-2020 eBay Inc.
///
/// Use of this source code is governed by a BSD-style
/// license that can be found in the LICENSE file or at
/// https://opensource.org/licenses/BSD-3-Clause
/// ***************************************************

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helper_widgets.dart';
import 'sample_weather_widget.dart';

const someDuration = Duration(milliseconds: 100);

Future<void> main() async {
  group('Multi Screen Golden examples', () {
    testGoldens('Example of testing a responsive layout', (tester) async {
      await tester.pumpWidgetBuilder(const WeatherForecast());
      await multiScreenGolden(
        tester,
        'weather_forecast',
        skip: !Platform.isMacOS,
      );
    });
    group('Responsive layout when image changes depending on layout', () {
      testGoldens('default configuration', (tester) async {
        await tester.pumpWidgetBuilder(
            _forecastWithDifferentImagesForLargeAndSmallScreen());
        await multiScreenGolden(
          tester,
          'weather_image_async_load_default',
          skip: !Platform.isMacOS,
        );
      });
      testGoldens('custom pump between test sizes', (tester) async {
        await tester.pumpWidgetBuilder(
            _forecastWithDifferentImagesForLargeAndSmallScreen());
        await multiScreenGolden(
          tester,
          'weather_image_async_load_correct_duration',
          deviceSetupBetweenSizeChanges: (tester) async {
            await tester.pump(someDuration);
            await tester.pump(someDuration);
          },
          skip: !Platform.isMacOS,
        );
      });
    });
  });
}

Widget _forecastWithDifferentImagesForLargeAndSmallScreen() {
  // There are probably other ways to trigger images not showing but this is probably the easiest.
  return InvalidateWidgetTreeWhenSizeChanges(
    child: FutureWidgetTester(
      duration: someDuration,
      child: LayoutBuilder(
        builder: (context, container) {
          if (container.maxWidth > 500) {
            return const WeatherForecast();
          } else {
            return WeatherForecast(
              list: thisWeek.take(3).toList(),
            );
          }
        },
      ),
    ),
  );
}
