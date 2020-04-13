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
      testGoldens(
          'Some images missing in multiScreenGoldens that require additional setup',
          (tester) async {
        await tester.pumpWidgetBuilder(
            _forecastWithDifferentImagesForLargeAndSmallScreen());
        await multiScreenGolden(
          tester,
          'example_of_images_not_properly_loading',
          skip: !Platform.isMacOS,
        );
      });
      testGoldens(
          'Should render images in multiScreenGoldens that require additional setup',
          (tester) async {
        await tester.pumpWidgetBuilder(
            _forecastWithDifferentImagesForLargeAndSmallScreen());
        await multiScreenGolden(
          tester,
          'weather_image_async_load_correct_duration',
          deviceSetup: (device, tester) async {
            await tester.pump(someDuration);
            await tester.pump(someDuration);
          },
          skip: !Platform.isMacOS,
        );
      });

      testGoldens('Safe Area test', (tester) async {
        await tester.pumpWidgetBuilder(
          Container(
              color: Colors.white,
              child: SafeArea(child: Container(color: Colors.blue))),
        );
        await multiScreenGolden(
          tester,
          'safe_area',
          devices: [
            const Device(
              name: 'no_safe_area',
              size: Size(200, 200),
            ),
            const Device(
              name: 'safe_area',
              size: Size(200, 200),
              safeArea: EdgeInsets.fromLTRB(5, 10, 15, 20),
            )
          ],
          skip: !Platform.isMacOS,
        );
      });

      testGoldens('Platform Brightness Test', (tester) async {
        await tester.pumpWidgetBuilder(
          Builder(
            builder: (context) => Container(
              color:
                  MediaQuery.of(context).platformBrightness == Brightness.dark
                      ? Colors.grey
                      : Colors.white,
              child: Text(MediaQuery.of(context).platformBrightness.toString()),
            ),
          ),
        );
        await multiScreenGolden(
          tester,
          'brightness',
          devices: [
            const Device(
              name: 'light',
              size: Size(200, 200),
              brightness: Brightness.light,
            ),
            const Device(
              name: 'dark',
              size: Size(200, 200),
              brightness: Brightness.dark,
            )
          ],
          skip: !Platform.isMacOS,
        );
      });

      testGoldens('Should restore window binding settings', (tester) async {
        final size = tester.binding.createViewConfiguration().size;
        final initialSize = tester.binding.window.physicalSize;
        final initialBrightness = tester.binding.window.platformBrightness;
        final initialDevicePixelRatio = tester.binding.window.devicePixelRatio;
        final initialTextScaleFactor = tester.binding.window.textScaleFactor;
        final initialViewInsets = tester.binding.window.padding;

        await tester.pumpWidgetBuilder(Container());
        await multiScreenGolden(
          tester,
          'empty',
          devices: [
            const Device(
              name: 'anything',
              size: Size(50, 75),
              brightness: Brightness.light,
              safeArea: EdgeInsets.all(4),
              devicePixelRatio: 2.0,
              textScale: 1.5,
            )
          ],
          skip: !Platform.isMacOS,
        );

        expect(tester.binding.createViewConfiguration().size, equals(size));
        expect(tester.binding.window.physicalSize, equals(initialSize));
        expect(tester.binding.window.platformBrightness,
            equals(initialBrightness));
        expect(tester.binding.window.devicePixelRatio,
            equals(initialDevicePixelRatio));
        expect(tester.binding.window.textScaleFactor,
            equals(initialTextScaleFactor));
        expect(tester.binding.window.padding, equals(initialViewInsets));
      });
    });
  });
}

Widget _forecastWithDifferentImagesForLargeAndSmallScreen() {
  // There are probably other ways to trigger images not showing but this is probably the easiest.
  // This fakes a common case where the root of the tree has totally different screens based on some size configuration
  // Then it requests some data over a network call, then the leaf widgets of the tree make some other sizing configuration
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
