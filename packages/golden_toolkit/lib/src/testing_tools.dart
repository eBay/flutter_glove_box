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

import 'configuration.dart';
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
    final _wrapper = wrapper ?? materialAppWrapper();

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

/// A function that wraps [matchesGoldenFile] with some extra functionality. The function finds the first widget
/// in the tree if [finder] is not specified. Furthermore a [fileNameFactory] can be used in combination with a [name]
/// to specify a custom path and name for the golden file. In addition to that the function makes sure all images are
/// available before
///
/// [name] is the name of the golden test and must NOT include extension like .png. Use [fileNameFactory] to construct
/// an actual file path from that name. If not [fileNameFactory] is specified the [GoldenToolkitConfiguration]'s one is
/// used, which defaults to `goldens/$name.png`.
///
///
/// [finder] is an optional finder, which can be used to target a specific widget to use for the test. If not specified
/// the first widget in the tree is used
///
/// [autoHeight] tries to find the optimal height for the output surface. If there is a vertical scrollable this
/// ensures the whole scrollable is shown. If the targeted render box is smaller then the current height, this will
/// shrink down the output height to match the render boxes height.
///
/// [customPump] optional pump function, see [CustomPump] documentation
///
/// [skip] by setting to true will skip the golden file assertion. This may be necessary if your development platform is not the same as your CI platform
Future<void> screenMatchesGolden(
  WidgetTester tester,
  String name, {
  bool autoHeight,
  FileNameFactory fileNameFactory,
  Finder finder,
  CustomPump customPump,
  bool skip,
}) async {
  assert(
    !name.endsWith('.png'),
    'Golden tests should not include file type',
  );
  if (!_inGoldenTest) {
    fail(
        'Golden tests MUST be run within a testGoldens method, not just a testWidgets method. This is so we can be confident that running "flutter test --name=GOLDEN" will run all golden tests.');
  }

  final shouldSkipGoldenGeneration = skip ?? GoldenToolkit.configuration.skipGoldenAssertion();
  final effectiveFileNameFactory = fileNameFactory ?? GoldenToolkit.configuration.fileNameFactory;

  final pumpAfterPrime = customPump ?? _onlyPumpAndSettle;
  /* if no finder is specified, use the first widget. Note, there is no guarantee this evaluates top-down, but in theory if all widgets are in the same 
  RepaintBoundary, it should not matter */
  final actualFinder = finder ?? find.byWidgetPredicate((w) => true).first;
  final fileName = effectiveFileNameFactory(name);
  await _primeImages(fileName, actualFinder);

  // This is a minor optimization and works around an issue with the current hacky implementation of invoking the golden assertion method.
  if (!shouldSkipGoldenGeneration) {
    await _primeImages(fileName, actualFinder);
  }
  await pumpAfterPrime(tester);

  final originalWindowSize = tester.binding.window.physicalSize;

  if (autoHeight == true) {
    // Find the first scrollable element which can be scrolled vertical.
    // ListView, SingleChildScrollView, CustomScrollView? are implemented using a Scrollable widget.
    final scrollable = find.byType(Scrollable).evaluate().map<ScrollableState>((Element element) {
      if (element is StatefulElement && element.state is ScrollableState) {
        return element.state;
      }
      return null;
    }).firstWhere((ScrollableState state) {
      final position = state.position;
      return position.axisDirection == AxisDirection.down;
    }, orElse: () => null);

    final renderObject = tester.renderObject(actualFinder);

    var finalHeight = originalWindowSize.height;
    if (scrollable != null && scrollable.position.extentAfter.isFinite) {
      finalHeight = originalWindowSize.height + scrollable.position.extentAfter;
    } else if (renderObject is RenderBox) {
      finalHeight = renderObject.size.height;
    }

    final adjustedSize = Size(originalWindowSize.width, finalHeight);
    await tester.binding.setSurfaceSize(adjustedSize);
    tester.binding.window.physicalSizeTestValue = adjustedSize;

    await tester.pump();
  }

  await expectLater(
    actualFinder,
    matchesGoldenFile(fileName),
    skip: shouldSkipGoldenGeneration,
  );

  if (autoHeight == true) {
    // Here we reset the window size to its original value to be clean
    await tester.binding.setSurfaceSize(originalWindowSize);
    tester.binding.window.physicalSizeTestValue = originalWindowSize;
  }
}

// Matches Golden file is the easiest way for the images to be requested.
Future<void> _primeImages(String fileName, Finder finder) => matchesGoldenFile(fileName).matchAsync(finder);

Future<void> _onlyPumpAndSettle(WidgetTester tester) async => tester.pumpAndSettle();
