import 'dart:io';

/// ***************************************************
/// Copyright 2019-2020 eBay Inc.
///
/// Use of this source code is governed by a BSD-style
/// license that can be found in the LICENSE file or at
/// https://opensource.org/licenses/BSD-3-Clause
/// ***************************************************
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

  group('Basic golden test for empty container', () {
    testGoldens('Square container', (tester) async {
      /// Note: pumpWidgetBuilder will use [materialAppWrapper] by default.
      /// If you want no wrapper at all, pass **noWrap()**

      final widget = Container(
        width: 100,
        height: 100,
        color: const Color.fromARGB(255, 36, 51, 66),
      );

      await tester.pumpWidgetBuilder(
        widget,
        surfaceSize: const Size(200, 200),
        wrapper: noWrap(),
      );

      await screenMatchesGolden(
        tester,
        'square_container',
        // https://github.com/eBay/flutter_glove_box/issues/5
        skip: !Platform.isMacOS,
      );
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

      await screenMatchesGolden(
        tester,
        'text_container',
        skip: !Platform.isMacOS,
      );
    });

    testGoldens('Single weather card', (tester) async {
      await tester.pumpWidgetBuilder(
        const WeatherCard(temp: 66, weather: Weather.sunny),
        surfaceSize: const Size(200, 200),
      );
      await screenMatchesGolden(
        tester,
        'single_weather_card',
        skip: !Platform.isMacOS,
      );
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
        skip: !Platform.isMacOS,
      );

      await screenMatchesGolden(
        tester,
        'progress_animation_middle',
        customPump: (tester) => tester.pump(const Duration(milliseconds: 400)),
        skip: !Platform.isMacOS,
      );
    });
  });

  group('GoldenBuilder examples with different layouts', () {
    testGoldens('GRID: Different weather types without frame', (tester) async {
      final gb = GoldenBuilder.grid(
        columns: 2,
        bgColor: Colors.white,
        widthToHeightRatio: 1,
      )
        ..addScenario(
            'Sunny', const WeatherCard(temp: 66, weather: Weather.sunny))
        ..addScenario(
            'Cloudy', const WeatherCard(temp: 56, weather: Weather.cloudy))
        ..addScenario(
            'Raining', const WeatherCard(temp: 37, weather: Weather.rain))
        ..addScenario(
          'Cold',
          const WeatherCard(temp: 25, weather: Weather.cold),
        );

      await tester.pumpWidgetBuilder(
        gb.build(),
        surfaceSize: const Size(500, 500),
      );
      await screenMatchesGolden(tester, 'weather_types_grid',
          skip: !Platform.isMacOS);
    });

    testGoldens('COLUMN: Different weather types with extra frame',
        (tester) async {
      final gb = GoldenBuilder.column(
        bgColor: Colors.white,
        wrap: _simpleFrame,
      )
        ..addScenario(
            'Sunny', const WeatherCard(temp: 66, weather: Weather.sunny))
        ..addScenario(
            'Cloudy', const WeatherCard(temp: 56, weather: Weather.cloudy))
        ..addScenario(
            'Raining', const WeatherCard(temp: 37, weather: Weather.rain))
        ..addScenario(
            'Cold', const WeatherCard(temp: 25, weather: Weather.cold));

      await tester.pumpWidgetBuilder(
        gb.build(),
        surfaceSize: const Size(120, 900),
      );
      await screenMatchesGolden(tester, 'weather_types_column',
          skip: !Platform.isMacOS);
    });
  });

  group('GoldenBuilder examples of different screen size testing', () {
    // With those test we want to make sure our widgets look right on different screen sizes / devices
    testGoldens('Card should look rigth on different devices / screen sizes',
        (tester) async {
      await tester.pumpWidgetBuilder(
        const Center(child: WeatherCard(temp: 66, weather: Weather.sunny)),
      );

      await multiScreenGolden(tester, 'weather_card_sizing',
          devices: [
            Device.phone,
            Device.tabletLandscape,
            Device.tabletPortrait
          ],
          overrideGoldenHeight: 200,
          skip: !Platform.isMacOS);
    });
  });

  group('GoldenBuilder examples of accessibility testing', () {
    // With those test we want to make sure our widgets look right when user changes system font size
    testGoldens('Card should look right when user bumps system font size',
        (tester) async {
      const widget = WeatherCard(temp: 56, weather: Weather.cloudy);

      final gb = GoldenBuilder.column(bgColor: Colors.white, wrap: _simpleFrame)
        ..addScenario('Regular font size', widget)
        ..addTextScaleScenario('Large font size', widget, textScaleFactor: 2.0)
        ..addTextScaleScenario('Largest font size', widget,
            textScaleFactor: 3.2);

      await tester.pumpWidgetBuilder(
        gb.build(),
        surfaceSize: const Size(200, 1000),
      );
      await screenMatchesGolden(
        tester,
        'weather_accessibility',
        skip: !Platform.isMacOS,
      );
    });
  });

  group('GoldenBuilder - combination of different features ', () {
    // Example of a single test verifies that all widget states look right on different devices with different font sizes
    testGoldens('Card should look rigth on different devices / screen sizes',
        (tester) async {
      final gb = GoldenBuilder.column(bgColor: Colors.white)
        ..addScenario(
            'Sunny', const WeatherCard(temp: 66, weather: Weather.sunny))
        ..addScenario(
            'Cloudy', const WeatherCard(temp: 56, weather: Weather.cloudy))
        ..addScenario(
            'Raining', const WeatherCard(temp: 37, weather: Weather.rain))
        ..addScenario(
            'Cold', const WeatherCard(temp: 25, weather: Weather.cold))
        ..addTextScaleScenario(
            'Cold', const WeatherCard(temp: 25, weather: Weather.cold));

      await tester.pumpWidgetBuilder(
        gb.build(),
        surfaceSize: const Size(200, 1200),
      );

      await multiScreenGolden(
        tester,
        'all_sized_all_fonts',
        devices: [Device.phone, Device.tabletLandscape],
        overrideGoldenHeight: 1200,
        skip: !Platform.isMacOS,
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
      await screenMatchesGolden(
        tester,
        'back_button_android',
        skip: !Platform.isMacOS,
      );
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
      await screenMatchesGolden(
        tester,
        'back_button_ios',
        skip: !Platform.isMacOS,
      );
    });
  });
}

Widget _simpleFrame(Widget child) {
  return Container(
    padding: const EdgeInsets.all(4),
    decoration: BoxDecoration(
      color: const Color(0xFFFFFFFF),
      border: Border.all(color: const Color(0xFF9E9E9E)),
    ),
    child: child,
  );
}
