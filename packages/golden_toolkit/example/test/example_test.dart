import 'package:flutter/material.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../lib/src/weather_widgets.dart';

void main() {
  testGoldens('Single weather card', (tester) async {
    await tester.pumpWidgetBuilder(
      const Center(child: WeatherCard(temp: 66, weather: Weather.sunny)),
      surfaceSize: const Size(200, 200),
    );
    await screenMatchesGolden(tester, 'single_weather_card');
  });

  testGoldens('GRID: Different weather types without frame', (tester) async {
    final gb = GoldenBuilder.grid(
      columns: 2,
      bgColor: Colors.white,
      widthToHeightRatio: 1,
    )
      ..addScenario('Sunny', const WeatherCard(temp: 66, weather: Weather.sunny))
      ..addScenario('Cloudy', const WeatherCard(temp: 56, weather: Weather.cloudy))
      ..addScenario('Raining', const WeatherCard(temp: 37, weather: Weather.rain))
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

  testGoldens('COLUMN: Different weather types with extra frame', (tester) async {
    final gb = GoldenBuilder.column(
      bgColor: Colors.white,
      wrap: _simpleFrame,
    )
      ..addScenario('Sunny', const WeatherCard(temp: 66, weather: Weather.sunny))
      ..addScenario('Cloudy', const WeatherCard(temp: 56, weather: Weather.cloudy))
      ..addScenario('Raining', const WeatherCard(temp: 37, weather: Weather.rain))
      ..addScenario('Cold', const WeatherCard(temp: 25, weather: Weather.cold));

    await tester.pumpWidgetBuilder(
      gb.build(),
      surfaceSize: const Size(120, 900),
    );
    await screenMatchesGolden(tester, 'weather_types_column');
  });

  testGoldens('Card should look right when user bumps system font size', (tester) async {
    const widget = WeatherCard(temp: 56, weather: Weather.cloudy);

    final gb = GoldenBuilder.column(bgColor: Colors.white, wrap: _simpleFrame)
      ..addScenario('Regular font size', widget)
      ..addTextScaleScenario('Large font size', widget, textScaleFactor: 2.0)
      ..addTextScaleScenario('Largest font size', widget, textScaleFactor: 3.2);

    await tester.pumpWidgetBuilder(
      gb.build(),
      surfaceSize: const Size(200, 1000),
    );
    await screenMatchesGolden(tester, 'weather_accessibility');
  });

  testGoldens('Card should look rigth on different devices / screen sizes', (tester) async {
    final gb = GoldenBuilder.column(bgColor: Colors.white)
      ..addScenario('Sunny', const WeatherCard(temp: 66, weather: Weather.sunny))
      ..addScenario('Cloudy', const WeatherCard(temp: 56, weather: Weather.cloudy))
      ..addScenario('Raining', const WeatherCard(temp: 37, weather: Weather.rain))
      ..addScenario('Cold', const WeatherCard(temp: 25, weather: Weather.cold))
      ..addTextScaleScenario('Cold', const WeatherCard(temp: 25, weather: Weather.cold));

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

  testGoldens('Example of testing a responsive layout', (tester) async {
    await tester.pumpWidgetBuilder(const WeatherForecast());
    await multiScreenGolden(tester, 'weather_forecast');
  });

  testGoldens('Some images missing in multiScreenGoldens that require additional setup', (tester) async {
    await tester.pumpWidgetBuilder(_forecastWithDifferentImagesForLargeAndSmallScreen());
    await multiScreenGolden(
      tester,
      'example_of_images_not_properly_loading',
    );
  });
  testGoldens('Should render images in multiScreenGoldens that require additional setup', (tester) async {
    await tester.pumpWidgetBuilder(_forecastWithDifferentImagesForLargeAndSmallScreen());
    await multiScreenGolden(
      tester,
      'weather_image_async_load_correct_duration',
      deviceSetup: (device, tester) async {
        await tester.pump(someDuration);
        await tester.pump(someDuration);
      },
    );
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
  const FutureWidgetTester({Key key, this.child, this.duration = const Duration(milliseconds: 100)}) : super(key: key);
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
  const InvalidateWidgetTreeWhenSizeChanges({Key key, this.child}) : super(key: key);
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
