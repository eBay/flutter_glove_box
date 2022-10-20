/// ***************************************************
/// Copyright 2019-2020 eBay Inc.
///
/// Use of this source code is governed by a BSD-style
/// license that can be found in the LICENSE file or at
/// https://opensource.org/licenses/BSD-3-Clause
/// ***************************************************
import 'package:flutter/widgets.dart';

import 'testing_tools.dart';

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
  /// [wrap] (optional) will wrap the scenario's widget in the tree.
  ///
  /// [bgColor] will change the background color of output .png file
  factory GoldenBuilder.grid({
    required int columns,
    required double widthToHeightRatio,
    WidgetWrapper? wrap,
    Color? bgColor,
  }) {
    return GoldenBuilder._(
      columns: columns,
      widthToHeightRatio: widthToHeightRatio,
      wrap: wrap,
      bgColor: bgColor,
    );
  }

  /// Will output a .png file with a column layout in 'tests/goldens' folder.
  ///
  /// [wrap] (optional) will wrap the scenario's widget in the tree.
  ///
  /// [bgColor] will change the background color of output .png file
  ///
  factory GoldenBuilder.column({
    Color? bgColor,
    WidgetWrapper? wrap,
  }) {
    return GoldenBuilder._(
      wrap: wrap,
      bgColor: bgColor,
    );
  }

  GoldenBuilder._({
    this.columns = 1,
    this.widthToHeightRatio = 1.0,
    this.wrap,
    this.bgColor,
  });

  /// Can be used to wrap all scenario widgets. Useful if you wish to
  /// provide consistent UI treatment to all of them or need to inject dependencies.
  final WidgetWrapper? wrap;

  /// number of columns [columns] in a grid
  final int columns;

  ///  background [bgColor] color of output .png file
  final Color? bgColor;

  ///  [widthToHeightRatio]  grid layout
  final double widthToHeightRatio;

  ///  List of tests [scenarios]  being run within GoldenBuilder
  final List<_Scenario> scenarios = [];

  ///  [addTextScaleScenario]  will add a test to GoldenBuilder where u can provide custom font size
  void addTextScaleScenario(
    String name,
    OnScenarioCreate? onCreate,
    Widget widget, {
    double textScaleFactor = textScaleFactorMaxSupported,
  }) {
    addScenario(
      name: '$name ${textScaleFactor}x',
      onCreate: onCreate,
      widget: _TextScaleFactor(
        textScaleFactor: textScaleFactor,
        child: widget,
      ),
    );
  }

  ///  [addScenario] will add a test GoldenBuilder
  void addScenario({
    required String name,
    OnScenarioCreate? onCreate,
    required Widget widget,
  }) {
    final key = Key(name);

    scenarios.add(
      _Scenario(
        key: key,
        onCreate: onCreate,
        widget: _ScenarioWidget(
          key: key,
          name: name,
          widget: widget,
          wrap: wrap,
        ),
      ),
    );
  }

  ///  [addScenarioBuilder] will add a test with BuildContext GoldenBuilder
  /// use as:
  /// ..addScenarioBuilder(
  ///   'Test with context',
  ///   (context) {
  ///     var color = Theme.of(context).colorScheme.primary;
  ///     return Container(color: color);
  ///   },
  /// )
  void addScenarioBuilder(
    String name,
    OnScenarioCreate? onCreate,
    Widget Function(BuildContext context) fn,
  ) {
    addScenario(
      name: name,
      onCreate: onCreate,
      widget: Builder(builder: fn),
    );
  }

  ///  [build] will build a list of [scenarios]  with a given layout
  Widget build() {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        padding: const EdgeInsets.all(8),
        color: bgColor ?? const Color(0xFFEEEEEE),
        child: columns == 1 ? _column() : _grid(),
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
      children: scenarios.map((e) => e.widget).toList(),
    );
  }

  Column _column() => Column(
        mainAxisSize: MainAxisSize.min,
        children: scenarios.map((e) => e.widget).toList(),
      );
}

/// Class containing whats required to create a Scenario
class _Scenario {
  /// constructs a Scenario
  _Scenario({
    required this.key,
    this.onCreate,
    required this.widget,
  });

  /// key that references created scenario and specific device
  final Key key;

  /// function that is executed after initial pump of widget
  final OnScenarioCreate? onCreate;

  /// widget that represents this scenario
  final _ScenarioWidget widget;
}

class _ScenarioWidget extends StatelessWidget {
  const _ScenarioWidget({
    Key? key,
    required this.name,
    required this.widget,
    this.wrap,
  }) : super(key: key);

  final WidgetWrapper? wrap;
  final String name;
  final Widget widget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(name, style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 4),
          wrap?.call(widget) ?? widget,
        ],
      ),
    );
  }
}

class _TextScaleFactor extends StatelessWidget {
  const _TextScaleFactor({
    required this.textScaleFactor,
    required this.child,
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
