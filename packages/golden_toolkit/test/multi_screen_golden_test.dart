/// ***************************************************
/// Copyright 2019-2020 eBay Inc.
///
/// Use of this source code is governed by a BSD-style
/// license that can be found in the LICENSE file or at
/// https://opensource.org/licenses/BSD-3-Clause
/// ***************************************************

import 'dart:io';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:golden_toolkit/src/font_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'sample_weather_widget.dart';

Future<void> main() async {
  /// Note: In order to see fonts and icons on goldens,
  /// you need to preload all the fonts with this function in all test files
  await loadAppFonts(from: 'fonts');

  group('Multi Screen Golden examples', () {
    // With those test we want to make sure our widgets look right on different screen sizes / devices
    testGoldens('Card should look right on different devices / screen sizes',
        (tester) async {
      await tester.pumpWidgetBuilder(
        const Center(child: WeatherCard(temp: 66, weather: Weather.sunny)),
      );

      await multiScreenGolden(tester, 'weather_card_sizing',
          devices: [
            Device.phone,
            Device.tabletLandscape,
            const Device(
              name: 'custom',
              size: Size(350, 650),
              devicePixelRatio: 1.0,
              textScale: 1.4,
            )
          ],
          overrideGoldenHeight: 200,
          skip: !Platform.isMacOS);
    });
  });
}
