/// ***************************************************
/// Copyright 2019-2020 eBay Inc.
///
/// Use of this source code is governed by a BSD-style
/// license that can be found in the LICENSE file or at
/// https://opensource.org/licenses/BSD-3-Clause
/// ***************************************************
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

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
  factory GoldenBuilder.column({
    bool wrapWidgetsInFrame = false,
    Color bgColor,
  }) {
    return GoldenBuilder._(
      wrapWidgetInFrame: wrapWidgetsInFrame,
      bgColor: bgColor,
    );
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
    addScenario(
        '$testName ${maxTextSize}x',
        _TextScaleFactor(
          textScaleFactor: maxTextSize,
          child: widgetToValidate,
        ));
  }

  ///  [addScenario] will add a test GoldenBuilder
  void addScenario(String scenario, Widget widget) {
    tests.add(Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(scenario, style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 4),
          if (wrapWidgetInFrame)
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF),
                border: Border.all(color: const Color(0xFF9E9E9E)),
              ),
              child: widget,
            )
          else
            widget
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

  Column _column() => Column(mainAxisSize: MainAxisSize.min, children: tests);
}

class _TextScaleFactor extends StatelessWidget {
  const _TextScaleFactor({
    @required this.textScaleFactor,
    @required this.child,
  });
  final Widget child;
  final double textScaleFactor;

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: textScaleFactor),
      child: child,
    );
  }
}
