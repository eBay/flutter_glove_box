/// ***************************************************
/// Copyright 2019-2020 eBay Inc.
///
/// Use of this source code is governed by a BSD-style
/// license that can be found in the LICENSE file or at
/// https://opensource.org/licenses/BSD-3-Clause
/// ***************************************************
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meta/meta.dart';

import 'test_asset_bundle.dart';

const Size _defaultSize = Size(800, 600);

typedef WidgetWrapper = Widget Function(Widget);

///CustomPump is a function that lets you do custom pumping before golden evaluation.
///Sometimes, you want to do a golden test for different stages of animations, so its crucial to have a precise control over pumps and durations
typedef CustomPump = Future<void> Function(WidgetTester);

/// Extensions for a [WidgetTester]
extension TestingToolsExtension on WidgetTester {
  /// Extension for a [WidgetTester] that pumps the widget and provides an optional [WidgetWrapper]
  ///
  /// [WidgetWrapper] defaults to [materialAppWrapper]
  ///
  /// [surfaceSize] set's the surface size, defaults to [_defaultSize]
  ///
  /// [textScaleSize] set's the text scale size (usually in a range from 1 to 3)
  Future<void> pumpWidgetBuilder(
    Widget widget, {
    WidgetWrapper wrapper,
    Size surfaceSize = _defaultSize,
    double textScaleSize = 1.0,
  }) async {
    final WidgetWrapper _wrapper = wrapper ?? materialAppWrapper();

    await _pumpAppWidget(
      this,
      _wrapper(widget),
      surfaceSize: surfaceSize,
      textScaleSize: textScaleSize,
    );
  }
}

/// This [materialAppWrapper] is a convenience function to wrap your widget in [MaterialApp]
/// Wraps your widget in MaterialApp, inject  custom theme, localizations, override  surfaceSize and platform
///
/// [platform] will override Theme's platform. [theme] is required
///
/// [localizations] is list of [LocalizationsDelegate] that is required for this test
///
/// [navigatorObserver] is an interface for observing the behavior of a [Navigator].
///
/// [localeOverrides] will set supported supportedLocales, defaults to [Locale('en')]
///
/// [theme] Your app theme
WidgetWrapper materialAppWrapper({
  TargetPlatform platform = TargetPlatform.android,
  Iterable<LocalizationsDelegate<dynamic>> localizations,
  NavigatorObserver navigatorObserver,
  Iterable<Locale> localeOverrides,
  ThemeData theme,
}) {
  return (child) => MaterialApp(
        localizationsDelegates: localizations,
        supportedLocales: localeOverrides ?? const [Locale('en')],
        theme: theme?.copyWith(platform: platform),
        debugShowCheckedModeBanner: false,
        home: Material(child: child),
        navigatorObservers: [
          if (navigatorObserver != null) navigatorObserver,
        ],
      );
}

/// This [noWrap] is a convenience function if you don't want to wrap widgets in default [materialAppWrapper]
WidgetWrapper noWrap() => (child) => child;

Future<void> _pumpAppWidget(
  WidgetTester tester,
  Widget app, {
  Size surfaceSize,
  double textScaleSize,
}) async {
  await tester.binding.setSurfaceSize(surfaceSize);
  tester.binding.window.physicalSizeTestValue = surfaceSize;
  tester.binding.window.devicePixelRatioTestValue = 1.0;
  tester.binding.window.textScaleFactorTestValue = textScaleSize;

  await tester.pumpWidget(
    DefaultAssetBundle(bundle: TestAssetBundle(), child: app),
  );
  await tester.pump();
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
@isTestGroup
void testGoldens(
  String description,
  Future<void> Function(WidgetTester) test, {
  bool skip = false,
}) {
  group(description, () {
    testWidgets('Golden', (tester) async {
      _inGoldenTest = true;
      tester.binding.addTime(const Duration(seconds: 10));
      try {
        await test(tester);
      } finally {
        _inGoldenTest = false;
      }
    }, skip: skip);
  });
}

/// This [screenMatchesGolden] is wrapper on top of [matchesGoldenFile]
///
/// [goldenFileName] is a file name output, must NOT include extension like .png
///
/// [finder] optional finder
///
/// [customPump] optional pump function, see [CustomPump] documentation
///
/// [skip] by setting to true will skip the golden file assertion. This may be necessary if your development platform is not the same as your CI platform
Future<void> screenMatchesGolden(
  WidgetTester tester,
  String goldenFileName, {
  Finder finder,
  CustomPump customPump,
  bool skip = false,
}) async {
  assert(
    !goldenFileName.endsWith('.png'),
    'Golden tests should not include file type',
  );
  if (!_inGoldenTest) {
    fail(
        'Golden tests MUST be run within a testGoldens method, not just a testWidgets method. This is so we can be confident that running "flutter test --name=GOLDEN" will run all golden tests.');
  }
  final pumpAfterPrime = customPump ?? _onlyPumpAndSettle;
  /* if no finder is specified, use the first widget. Note, there is no guarantee this evaluates top-down, but in theory if all widgets are in the same 
  RepaintBoundary, it should not matter */
  final actualFinder = finder ?? find.byWidgetPredicate((w) => true).first;
  final fileName = 'goldens/$goldenFileName.png';
  await _primeImages(fileName, actualFinder);
  await pumpAfterPrime(tester);

  return expectLater(
    actualFinder,
    matchesGoldenFile(fileName),
    skip: skip,
  );
}

// Matches Golden file is the easiest way for the images to be requested.
Future<void> _primeImages(String fileName, Finder finder) =>
    matchesGoldenFile(fileName).matchAsync(finder);

Future<void> _onlyPumpAndSettle(WidgetTester tester) async =>
    tester.pumpAndSettle();
