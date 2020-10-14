import 'package:example/src/flutter_demo_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

void main() {
  testGoldens('multiDeviceGolden', (tester) async {
    await multiDeviceGolden(
      tester,
      'flutter_demo_multi_device_golden',
      widget: FlutterDemoPage(),
      afterPump: (scenarioWidgetKey) async {
        final finder = find.descendant(
          of: find.byKey(scenarioWidgetKey),
          matching: find.byIcon(Icons.add),
        );
        expect(finder, findsOneWidget);
        await tester.tap(finder);
      },
    );
  });

  testGoldens('DeviceBuilder - one scenario - default devices', (tester) async {
    final builder = DeviceBuilder()
      ..addDeviceScenario(
        widget: FlutterDemoPage(),
        name: 'default page',
      );

    await tester.pumpDeviceBuilder(builder);

    await screenMatchesGolden(tester, 'flutter_demo_page_single_scenario');
  });

  testGoldens('DeviceBuilder - one scenario - override devices',
      (tester) async {
    final builder = DeviceBuilder()
      ..overrideDevicesForAllScenarios(devices: [
        Device.phone,
        Device.iphone11,
        Device.tabletPortrait,
        Device.tabletLandscape,
      ])
      ..addDeviceScenario(
        widget: FlutterDemoPage(),
        name: 'default page',
      );

    await tester.pumpDeviceBuilder(builder);

    await screenMatchesGolden(
        tester, 'flutter_demo_page_single_scenario_more_devices');
  });

  testGoldens('DeviceBuilder - multiple scenarios - with afterPump',
      (tester) async {
    final builder = DeviceBuilder()
      ..overrideDevicesForAllScenarios(devices: [
        Device.phone,
        Device.iphone11,
        Device.tabletPortrait,
        Device.tabletLandscape,
      ])
      ..addDeviceScenario(
        widget: FlutterDemoPage(),
        name: 'default page',
      )
      ..addDeviceScenario(
        widget: FlutterDemoPage(),
        name: 'tap once',
        afterPump: (scenarioWidgetKey) async {
          final finder = find.descendant(
            of: find.byKey(scenarioWidgetKey),
            matching: find.byIcon(Icons.add),
          );
          expect(finder, findsOneWidget);
          await tester.tap(finder);
        },
      )
      ..addDeviceScenario(
        widget: FlutterDemoPage(),
        name: 'tap five times',
        afterPump: (scenarioWidgetKey) async {
          final finder = find.descendant(
            of: find.byKey(scenarioWidgetKey),
            matching: find.byIcon(Icons.add),
          );
          expect(finder, findsOneWidget);

          await tester.tap(finder);
          await tester.tap(finder);
          await tester.tap(finder);
          await tester.tap(finder);
          await tester.tap(finder);
        },
      );

    await tester.pumpDeviceBuilder(builder);

    await screenMatchesGolden(tester, 'flutter_demo_page_multiple_scenarios');
  });
}
