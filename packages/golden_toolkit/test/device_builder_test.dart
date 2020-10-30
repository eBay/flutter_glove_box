import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

/// ***************************************************
/// Copyright 2019-2020 eBay Inc.
///
/// Use of this source code is governed by a BSD-style
/// license that can be found in the LICENSE file or at
/// https://opensource.org/licenses/BSD-3-Clause
/// ***************************************************

void main() {
  group('DeviceBuilder', () {
    test('overrideDevicesForAllScenarios - empty or null', () {
      // given
      final sut = DeviceBuilder();

      // then
      expect(
        () {
          sut.overrideDevicesForAllScenarios(devices: []);
        },
        throwsA(isA<AssertionError>()),
      );

      expect(
        () {
          sut.overrideDevicesForAllScenarios(devices: null);
        },
        throwsA(isA<AssertionError>()),
      );
    });

    test('addScenario - defaultDevices - default name', () {
      const deviceName = 'deviceName';
      return GoldenToolkit.runWithConfiguration(
        () {
          // given
          final sut = DeviceBuilder();
          final widget = Container();

          // when
          sut.addScenario(widget: widget);

          // then
          //one scenario for the one default device `deviceName`
          expect(sut.scenarios.length, equals(1));
          final scenario = sut.scenarios.first;

          expect(scenario.widget.name, equals(' - $deviceName'));
          expect(scenario.widget.key, equals(const Key(' - $deviceName')));
          expect(scenario.key, equals(const Key(' - $deviceName')));
        },
        config: GoldenToolkitConfiguration(
          defaultDevices: const [
            Device(
              name: deviceName,
              size: Size.square(10),
            )
          ],
        ),
      );
    });

    test('addScenario - overrideDevices - add name', () {
      // given
      const deviceName = 'deviceName';
      final sut = DeviceBuilder();
      final widget = Container();

      sut.overrideDevicesForAllScenarios(
        devices: const [
          Device(
            name: deviceName,
            size: Size.square(10),
          )
        ],
      );

      // when
      sut.addScenario(widget: widget, name: 'scenarioName');

      // then
      //one scenario for the one default device `deviceName`
      expect(sut.scenarios.length, equals(1));
      final scenario = sut.scenarios.first;

      expect(scenario.widget.name, equals('scenarioName - $deviceName'));
      expect(
          scenario.widget.key, equals(const Key('scenarioName - $deviceName')));
      expect(scenario.key, equals(const Key('scenarioName - $deviceName')));
    });

    test('requiredWidgetSize - scenarios <= devicesPerScenarios', () {
      // given
      final sut = DeviceBuilder();

      sut.overrideDevicesForAllScenarios(
        devices: const [
          Device(
            name: 'deviceName',
            size: Size.square(10),
          )
        ],
      );
      sut.addScenario(widget: Container());

      // when
      final requiredSize = sut.requiredWidgetSize;

      // then
      // added height and width per scenario: 18 x 26
      expect(requiredSize, const Size(28, 36));
    });

    test('requiredWidgetSize - scenarios <= devicesPerScenarios', () {
      // given
      final sut = DeviceBuilder();

      sut.overrideDevicesForAllScenarios(
        devices: const [
          Device(
            name: 'deviceName',
            size: Size.square(10),
          )
        ],
      );
      sut.addScenario(widget: Container());

      // when
      final requiredSize = sut.requiredWidgetSize;

      // then
      expect(requiredSize, const Size(28, 36));
    });

    test(
        'requiredWidgetSize - scenarios <= devicesPerScenarios - sized for maxHeight',
        () {
      // given
      final sut = DeviceBuilder();

      sut.overrideDevicesForAllScenarios(
        devices: const [
          Device(
            name: 'deviceName',
            size: Size.square(10),
          ),
          Device(
            name: 'deviceName',
            size: Size.square(30),
          )
        ],
      );
      sut.addScenario(widget: Container());

      // when
      final requiredSize = sut.requiredWidgetSize;

      // then
      expect(requiredSize, const Size(76, 56));
    });

    test(
        'requiredWidgetSize - scenarios >= devicesPerScenarios - sized for maxHeight',
        () {
      // given
      final sut = DeviceBuilder();

      sut.overrideDevicesForAllScenarios(
        devices: const [
          Device(
            name: 'deviceName',
            size: Size.square(10),
          ),
        ],
      );
      sut.addScenario(widget: Container());
      sut.addScenario(widget: Container());

      // when
      final requiredSize = sut.requiredWidgetSize;

      // then
      expect(requiredSize, const Size(28, 72));
    });

    testWidgets('DeviceBuilder built widget', (tester) async {
      // given
      final sut = DeviceBuilder();
      sut.overrideDevicesForAllScenarios(
        devices: const [
          Device(
            name: 'deviceName',
            size: Size.square(200),
          ),
        ],
      );
      sut.addScenario(
          widget: Container(
        color: Colors.blue,
      ));
      sut.addScenario(
          widget: Container(
        color: Colors.blue,
      ));

      // when
      final requiredSize = sut.requiredWidgetSize;
      final widget = Container(
        width: requiredSize.width + 100,
        height: requiredSize.height + 100,
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: sut.build(),
        ),
      );

      await tester.pumpWidgetBuilder(widget,
          surfaceSize: sut.requiredWidgetSize);

      // then
      expect(find.byType(Align), findsOneWidget);
      expect(find.byType(Row), findsNWidgets(2));
      final firstRow = tester.firstWidget(find.byType(Row));
      if (firstRow is Row) {
        expect(firstRow.children.length, equals(1));
      }
    });

    testGoldens('DeviceBuilder golden test', (tester) async {
      // given
      final sut = DeviceBuilder();
      sut.overrideDevicesForAllScenarios(
        devices: const [
          Device(
            name: 'deviceName',
            size: Size.square(200),
          ),
        ],
      );
      sut.addScenario(
        name: 'scenario1asdasdasd',
        widget: Container(
          color: Colors.blue,
        ),
      );
      sut.addScenario(
        name: 'scenario2',
        widget: Container(
          color: Colors.blue,
        ),
      );

      await tester.pumpDeviceBuilder(sut);

      await screenMatchesGolden(tester, 'device_builder_test');
    });
  });
}
