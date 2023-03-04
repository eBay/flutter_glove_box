/// ***************************************************
/// Copyright 2019-2020 eBay Inc.
///
/// Use of this source code is governed by a BSD-style
/// license that can be found in the LICENSE file or at
/// https://opensource.org/licenses/BSD-3-Clause
/// ***************************************************

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

void main() {
  group('GoldenBuilder', () {
    testGoldens('Scenario Builder example', (tester) async {
      final builder = GoldenBuilder.grid(
        columns: 2,
        widthToHeightRatio: 1,
      )
        ..addScenarioBuilder(
            name: "Primary Color",
            builder: (context) {
              var color = Theme.of(context).colorScheme.primary;
              return Container(
                color: color,
              );
            })
        ..addScenarioBuilder(
            name: "Secondary Color",
            builder: (context) {
              var color = Theme.of(context).colorScheme.primary;
              return Container(
                color: color,
              );
            });
      await tester.pumpWidgetBuilder(builder.build());
      await screenMatchesGolden(tester, 'golden_builder_theme');
    });
    

    testGoldens('Column layout example', (tester) async {
      await tester.pumpWidgetBuilder(
        Center(
            child: (GoldenBuilder.column()
                  ..addScenario(
                    name: 'red',
                    widget: Container(height: 50, width: 50, color: Colors.red),
                  )
                  ..addScenario(
                    name: 'green',
                    widget:
                        Container(height: 50, width: 50, color: Colors.green),
                  )
                  ..addScenario(
                    name: 'blue',
                    widget:
                        Container(height: 50, width: 50, color: Colors.blue),
                  ))
                .build()),
        surfaceSize: const Size(100, 300),
      );
      await screenMatchesGolden(tester, 'golden_builder_column',
          autoHeight: true);
    });

    testGoldens('Grid layout example', (tester) async {
      await tester.pumpWidgetBuilder(
        Center(
            child: (GoldenBuilder.grid(columns: 2, widthToHeightRatio: 1)
                  ..addScenario(
                    name: 'red',
                    widget: Container(height: 50, width: 50, color: Colors.red),
                  )
                  ..addScenario(
                    name: 'green',
                    widget:
                        Container(height: 50, width: 50, color: Colors.green),
                  )
                  ..addScenario(
                    name: 'blue',
                    widget:
                        Container(height: 50, width: 50, color: Colors.blue),
                  ))
                .build()),
        surfaceSize: const Size(300, 300),
      );
      await screenMatchesGolden(tester, 'golden_builder_grid',
          autoHeight: true);
    });

    testGoldens('TextScaleScenario', (tester) async {
      await tester.pumpWidgetBuilder(
        Center(
            child: (GoldenBuilder.column()
                  ..addTextScaleScenario(
                      name: 'small',
                      widget: const Text('text'),
                      textScaleFactor: 1.0)
                  ..addTextScaleScenario(
                      name: 'medium',
                      widget: const Text('text'),
                      textScaleFactor: 2.0)
                  ..addTextScaleScenario(
                      name: 'large',
                      widget: const Text('text'),
                      textScaleFactor: 3.2))
                .build()),
        surfaceSize: const Size(100, 300),
      );
      await screenMatchesGolden(tester, 'golden_builder_textscale',
          autoHeight: true);
    });
  });
}
