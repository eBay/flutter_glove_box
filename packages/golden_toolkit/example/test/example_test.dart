import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

// ignore: avoid_relative_lib_imports
import '../lib/src/weather_widgets.dart';

void main() {
  group('Basic Goldens', () {
    /// This test uses .pumpWidgetBuilder to automatically set up
    /// the appropriate Material dependencies in order to minimize boilerplate.
    ///
    /// It simply pumps a custom widget and captures the golden
    testGoldens('Single weather card should look correct', (tester) async {
      await tester.pumpWidgetBuilder(
        const Center(child: WeatherCard(temp: 66, weather: Weather.sunny)),
        surfaceSize: const Size(200, 200),
      );
      await screenMatchesGolden(tester, 'single_weather_card');
    });
  });

  /// GoldenBuilder allows you to scaffold out a single widget containing multiple test scenarios
  /// for a given widget under test.
  group('GoldenBuilder', () {
    /// lays out the results in a grid
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
      await screenMatchesGolden(tester, 'weather_types_grid');
    });

    /// lays out the results in a column
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
      await screenMatchesGolden(tester, 'weather_types_column');
    });

    /// Demonstrates how golden builder can be combined with multiScreenGolden to
    /// test with multiple dimensions of parameters
    testGoldens('Card should look right on different devices / screen sizes',
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
      );
    });

    group('GoldenBuilder examples of accessibility testing', () {
      // With those test we want to make sure our widgets look right when user changes system font size
      testGoldens('Card should look right when user bumps system font size',
          (tester) async {
        const widget = WeatherCard(temp: 56, weather: Weather.cloudy);

        final gb =
            GoldenBuilder.column(bgColor: Colors.white, wrap: _simpleFrame)
              ..addScenario('Regular font size', widget)
              ..addTextScaleScenario('Large font size', widget,
                  textScaleFactor: 2.0)
              ..addTextScaleScenario('Largest font size', widget,
                  textScaleFactor: 3.2);

        await tester.pumpWidgetBuilder(
          gb.build(),
          surfaceSize: const Size(200, 1000),
        );
        await screenMatchesGolden(tester, 'weather_accessibility');
      });
    });
  });

  group('Multi-Screen Golden', () {
    testGoldens('Example of testing a responsive layout', (tester) async {
      await tester.pumpWidgetBuilder(const WeatherForecast());
      await multiScreenGolden(tester, 'weather_forecast');
    });
  });

  group('Edge Cases / Troubleshooting Examples', () {
    ///there are some quirky situations with multi-screen golden. In between goldens, it reconfigures the device
    ///configuration, , which then triggers rebuilds in your widget tree, and then issues commands to force all requested images to finish loading.
    ///If your widget tree then requires further downstream rebuilds in order to add the image widgets to the tree,
    ///then you may run into issues with some images not displaying properly.
    ///
    ///This is an example of the the "issue"
    testGoldens(
        'Some images missing in multiScreenGoldens that require additional setup',
        (tester) async {
      await tester.pumpWidgetBuilder(
          _forecastWithDifferentImagesForLargeAndSmallScreen());
      await multiScreenGolden(
        tester,
        'example_of_images_not_properly_loading',
      );
    });

    ///here is an example of how to workaround it.
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

class FutureWidgetTester extends StatefulWidget {
  const FutureWidgetTester(
      {Key key, this.child, this.duration = const Duration(milliseconds: 100)})
      : super(key: key);
  final Widget child;
  final Duration duration;
  @override
  _FutureWidgetTesterState createState() => _FutureWidgetTesterState();
}

class _FutureWidgetTesterState extends State<FutureWidgetTester> {
  Future<bool> _myFuture;
  @override
  void initState() {
    super.initState();
    _myFuture = Future.delayed(widget.duration, () => true);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: _myFuture,
        builder: (context, value) {
          if (value.hasData) {
            return widget.child;
          }
          return const Placeholder();
        });
  }
}

class InvalidateWidgetTreeWhenSizeChanges extends StatelessWidget {
  const InvalidateWidgetTreeWhenSizeChanges({Key key, this.child})
      : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      return Container(
        key: ValueKey(constraint.toString()),
        child: child,
      );
    });
  }
}

const someDuration = Duration(milliseconds: 100);
