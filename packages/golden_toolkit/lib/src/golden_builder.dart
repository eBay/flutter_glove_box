/// ***************************************************
/// Copyright 2019-2020 eBay Inc.
///
/// Use of this source code is governed by a BSD-style
/// license that can be found in the LICENSE file or at
/// https://opensource.org/licenses/BSD-3-Clause
/// ***************************************************
//coverage:ignore
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meta/meta.dart';

import '../golden_toolkit.dart';

/// as of iOS 13.2.3 the max textScaleFactor a user can set is ~3.1176
const double textScaleFactorMaxSupported = 3.2;

/// GoldenBuilder builds column/grid layout for it's children
class GoldenBuilder {
  /// Will output a *.png file with a grid layout in 'tests/goldens' folder.
  ///
  /// You need to specify how many columns [columns] and widthToHeight ratio [widthToHeightRatio]
  ///
  /// [widthToHeightRatio] can range from 0.0 to 1.0
  ///
  /// [wrapWidgetsInFrame] will wrap golden tests in addition frame
  ///
  /// [bgColor] will change the background color of output .png file
  factory GoldenBuilder.grid({
    @required int columns,
    @required double widthToHeightRatio,
    bool wrapWidgetsInFrame = false,
    Color bgColor,
  }) {
    return GoldenBuilder._(
      columns: columns,
      widthToHeightRatio: widthToHeightRatio,
      wrapWidgetInFrame: wrapWidgetsInFrame,
      bgColor: bgColor,
    );
  }

  /// Will output a .png file with a column layout in 'tests/goldens' folder.
  ///
  /// [wrapWidgetsInFrame] will wrap golden tests in addition frame
  ///
  /// [bgColor] will change the background color of output .png file
  ///
  factory GoldenBuilder.column(
      {bool wrapWidgetsInFrame = false, Color bgColor}) {
    return GoldenBuilder._(
        wrapWidgetInFrame: wrapWidgetsInFrame, bgColor: bgColor);
  }

  GoldenBuilder._({
    this.columns = 1,
    this.widthToHeightRatio = 1.0,
    this.wrapWidgetInFrame = false,
    this.bgColor,
  });

  /// number of columns [columns] in a grid
  final int columns;

  ///  background [bgColor] color of output .png file
  final Color bgColor;

  ///  [widthToHeightRatio]  grid layout
  final double widthToHeightRatio;

  ///  [wrapWidgetInFrame] will wrap widget with frame
  final bool wrapWidgetInFrame;

  ///  List of tests [tests]  being run within GoldenBuilder
  final List<Widget> tests = [];
  static const Key _key = ValueKey('golden');

  ///  [addTestWithLargeText]  will add a test to GoldenBuilder where u can provide custom font size
  void addTestWithLargeText(
    String testName,
    Widget widgetToValidate, {
    double maxTextSize = textScaleFactorMaxSupported,
  }) {
    addTest(
        '$testName ${maxTextSize}x',
        _TextScaleFactor(
          textScaleFactor: maxTextSize,
          child: widgetToValidate,
        ));
  }

  ///  [addTest] will add a test GoldenBuilder
  void addTest(String test, Widget widgetToValidate, {bool wrapWithFrame}) {
    tests.add(Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(test, style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 4),
          if (wrapWithFrame ?? wrapWidgetInFrame)
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF),
                border: Border.all(color: const Color(0xFF9E9E9E)),
              ),
              child: widgetToValidate,
            )
          else
            widgetToValidate
        ],
      ),
    ));
  }

  ///  [build] will build a list of [tests]  with a given layout
  Widget build() {
    return RepaintBoundary(
      key: _key,
      child: Align(
        alignment: Alignment.topLeft,
        child: Container(
          padding: const EdgeInsets.all(8),
          color: bgColor ?? const Color(0xFFEEEEEE),
          child: columns == 1 ? _column() : _grid(),
        ),
      ),
    );
  }

  GridView _grid() {
    return GridView.count(
      childAspectRatio: widthToHeightRatio,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      shrinkWrap: true,
      crossAxisCount: columns,
      children: tests,
    );
  }

  Column _column() {
    return Column(mainAxisSize: MainAxisSize.min, children: tests);
  }
}

bool _inGoldenTest = false;

/// This [testGoldens] method exists as a way to enforce the proper naming of tests that contain golden diffs so that we can reliably run all goldens
///
/// [description] is a test description
///
/// [skip] to skip the test
///
/// [test] test body
///
@isTest
Future<void> testGoldens(
    String description, Future<void> Function(WidgetTester) test,
    {bool skip = false}) async {
  testWidgets(description, (tester) async {
    /// need to enforce this so we can target golden tests from the command line
    ///  unfortunately we can't append this string here because that breaks the IDE integration for running tests
    if (!description.endsWith(' *GOLDEN')) {
      fail(
          'testGoldens test descriptions need to end with " *GOLDEN" so they can be easily found and run together via the "flutter test --name=GOLDEN" command');
    }

    _inGoldenTest = true;
    tester.binding.addTime(const Duration(seconds: 10));
    try {
      await test(tester);
    } catch (e) {
      rethrow;
    } finally {
      _inGoldenTest = false;
    }
  }, skip: skip);
}

/// This [screenMatchesGolden] is wrapper on top of [matchesGoldenFile]
///
/// [goldenFileName] is a file name output, must NOT include extension like .png
///
/// [finder] optional finder, defaults to [widgetBuilderKey]
///
/// [customPump] optional pump function, see [CustomPump] documentation
Future<void> screenMatchesGolden(
  WidgetTester tester,
  String goldenFileName, {
  Finder finder,
  CustomPump customPump = _onlyPumpAndSettle,
}) async {
  if (!_inGoldenTest) {
    fail(
        'Golden tests MUST be run within a testGoldens method, not just a testWidgets method. This is so we can be confident that running "flutter test --name=GOLDEN" will run all golden tests.');
  } else if (goldenFileName.endsWith('.png')) {
    fail('Golden tests should not include file type');
  }
  final actualFinder = finder ?? find.byKey(widgetBuilderKey);
  final fileName = 'goldens/$goldenFileName.png';

  await matchesGoldenFile(fileName).matchAsync(actualFinder);
  await customPump(tester);

  return expectLater(
    actualFinder,
    matchesGoldenFile(fileName),
  );
}

Future<void> _onlyPumpAndSettle(WidgetTester tester) async =>
    tester.pumpAndSettle();

/// This [multiScreenGolden] will run [tests] for given [devices] list
///
/// Will output a single  golden file for each device in [devices] and will append device name to png file
///
/// [goldenFileName] is a file name output, must NOT include extension like .png
///
/// [finder] optional finder, defaults to [WidgetsApp]
///
/// [overrideHeight] might be required to override output file height in case if it should be bigger than device height
///
/// [customPump] optional pump function, see [CustomPump] documentation
///
/// [devices] list of devices to run the tests
///
///
Future<void> multiScreenGolden(
  WidgetTester tester,
  String goldenFileName, {
  Finder finder,
  double overrideHeight,
  CustomPump customPump = _onlyPumpAndSettle,
  List<Device> devices = const [
    Device.phone,
    Device.tabletLandscape,
  ],
}) async {
  for (final device in devices) {
    final size = Size(device.size.width, overrideHeight ?? device.size.height);
    await tester.binding.setSurfaceSize(size);
    tester.binding.window.physicalSizeTestValue = device.size;
    tester.binding.window.devicePixelRatioTestValue = device.devicePixelRatio;
    tester.binding.window.textScaleFactorTestValue = device.textScale;

    await tester.pump();
    await tester.pump();
    await screenMatchesGolden(
      tester,
      '$goldenFileName.${device.name}',
      customPump: customPump,
    );
  }
}

/// This [Device] is a configuration for golden test. Can be provided for [multiScreenGolden]

class Device {
  /// This [Device] is a configuration for golden test. Can be provided for [multiScreenGolden]
  const Device({
    this.size,
    this.devicePixelRatio = 1.0,
    this.name,
    this.textScale = 1.0,
  });

  /// [phone] one of the smallest phone screens
  static const Device phone = Device(name: 'phone', size: Size(375, 667));

  /// [tabletLandscape] example of tablet that in landscape mode
  static const Device tabletLandscape =
      Device(name: 'tablet_landscape', size: Size(1366, 1024));

  /// [tabletPortrait] example of tablet that in portrait mode
  static const Device tabletPortrait =
      Device(name: 'tablet_portrait', size: Size(1024, 1366));

  /// [name] specify device name. Ex: Phone, Tablet, Watch

  final String name;

  /// [size] specify device screen size. Ex: Size(1366, 1024))
  final Size size;

  /// [devicePixelRatio] specify device Pixel Ratio
  final double devicePixelRatio;

  /// [textScale] specify custom text scale
  final double textScale;

  /// [copyWith] convenience function for [Device] modification
  Device copyWith({
    Size size,
    double devicePixelRatio,
    String name,
    double textScale,
  }) {
    return Device(
      size: size ?? this.size,
      devicePixelRatio: devicePixelRatio ?? this.devicePixelRatio,
      name: name ?? this.name,
      textScale: textScale ?? this.textScale,
    );
  }
}

class _TextScaleFactor extends StatelessWidget {
  const _TextScaleFactor(
      {@required this.textScaleFactor, @required this.child});
  final Widget child;
  final double textScaleFactor;

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: textScaleFactor),
        child: child);
  }
}
