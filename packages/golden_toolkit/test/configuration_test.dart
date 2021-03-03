/// ***************************************************
/// Copyright 2019-2020 eBay Inc.
///
/// Use of this source code is governed by a BSD-style
/// license that can be found in the LICENSE file or at
/// https://opensource.org/licenses/BSD-3-Clause
/// ***************************************************
///

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import 'sample_widgets.dart';

void main() {
  group('GoldenToolkitConfiguration Tests', () {
    testGoldens(
        'screenMatchesGolden method should defer skip to global configuration',
        (tester) async {
      return GoldenToolkit.runWithConfiguration(
        () async {
          await tester.pumpWidget(Container());
          await screenMatchesGolden(tester, 'this_is_expected_to_skip');
        },
        config: GoldenToolkitConfiguration(skipGoldenAssertion: () => true),
      );
    });

    testGoldens(
        'screenMatchesGolden method level skip should trump global configuration',
        (tester) async {
      return GoldenToolkit.runWithConfiguration(
        () async {
          await tester.pumpWidgetBuilder(Container());
          await screenMatchesGolden(tester, 'this_is_expected_to_skip',
              //ignore: deprecated_member_use_from_same_package
              skip: true);
        },
        config: GoldenToolkitConfiguration(skipGoldenAssertion: () => false),
      );
    });

    testGoldens(
        'MultiScreenGolden method should defer skip to global configuration',
        (tester) async {
      return GoldenToolkit.runWithConfiguration(
        () async {
          await tester.pumpWidgetBuilder(Container());
          await multiScreenGolden(tester, 'this_is_expected_to_skip');
        },
        config: GoldenToolkitConfiguration(skipGoldenAssertion: () => true),
      );
    });

    testGoldens(
        'MultiScreenGolden method level skip should trump global configuration',
        (tester) async {
      return GoldenToolkit.runWithConfiguration(
        () async {
          await tester.pumpWidgetBuilder(Container());
          await multiScreenGolden(tester, 'this_is_expected_to_skip',
              //ignore: deprecated_member_use_from_same_package
              skip: true);
        },
        config: GoldenToolkitConfiguration(skipGoldenAssertion: () => false),
      );
    });

    testGoldens(
        'screenMatchesGolden method should defer fileNameFactory to global configuration',
        (tester) async {
      return GoldenToolkit.runWithConfiguration(
        () async {
          await tester.pumpWidgetBuilder(Container());
          await screenMatchesGolden(tester, 'global_file_name_factory');
        },
        config: GoldenToolkit.configuration.copyWith(
            fileNameFactory: (name) => 'goldens/custom/custom_$name.png'),
      );
    });

    testGoldens(
        'multiScreenGolden method should defer fileNameFactory to global configuration',
        (tester) async {
      return GoldenToolkit.runWithConfiguration(
        () async {
          await tester.pumpWidgetBuilder(Container());
          await multiScreenGolden(tester, 'global_device_file_name_factory');
        },
        config: GoldenToolkit.configuration.copyWith(
            deviceFileNameFactory: (name, device) =>
                'goldens/custom/custom_${name}_${device.name}.png'),
      );
    });

    testGoldens(
        'screenMatchesGolden method uses primeAssets from global configuration',
        (tester) async {
      var globalPrimeCalledCount = 0;
      return GoldenToolkit.runWithConfiguration(
        () async {
          await tester.pumpWidgetBuilder(
              Image.asset('packages/sample_dependency/images/image.png'));
          await screenMatchesGolden(
              tester, 'screen_matches_golden_defers_primeAssets');
          expect(globalPrimeCalledCount, 1);
        },
        config: GoldenToolkitConfiguration(
            primeAssets: (WidgetTester tester) async {
          globalPrimeCalledCount += 1;
          await legacyPrimeAssets(tester);
        }),
      );
    });

    testGoldens(
        'multiScreenGolden method uses primeAssets from global configuration',
        (tester) async {
      var globalPrimeCalledCount = 0;
      return GoldenToolkit.runWithConfiguration(
        () async {
          await tester.pumpWidgetBuilder(
              Image.asset('packages/sample_dependency/images/image.png'));
          await multiScreenGolden(
            tester,
            'multi_screen_golden_defers_primeAssets',
            devices: [const Device(size: Size(200, 200), name: 'custom')],
          );
          expect(globalPrimeCalledCount, 1);
        },
        config: GoldenToolkitConfiguration(
            primeAssets: (WidgetTester tester) async {
          globalPrimeCalledCount += 1;
          await legacyPrimeAssets(tester);
        }),
      );
    });

    testGoldens('defaultDevices should be used', (tester) async {
      final device1 = Device.phone.copyWith(name: 'custom1');
      final device2 = Device.phone.copyWith(name: 'custom2');
      final actualDevices = <Device>[];
      await GoldenToolkit.runWithConfiguration(
        () async {
          await tester.pumpWidgetBuilder(Container());
          await multiScreenGolden(tester, 'multiScreenGolden_defaultdevices');
        },
        config: GoldenToolkitConfiguration(
          deviceFileNameFactory: (filename, device) {
            actualDevices.add(device);
            return '$filename\_${device.name}.png';
          },
          defaultDevices: [device1, device2],
        ),
      );
      expect(actualDevices, equals([device1, device2]));
    });

    test('defaultDevices should not be empty', () async {
      await expectLater(
        () => GoldenToolkit.runWithConfiguration(
          () {},
          config: GoldenToolkitConfiguration(defaultDevices: const []),
        ),
        throwsAssertionError,
      );
    });

    group('Shadows', () {
      GoldenToolkit.runWithConfiguration(
        () {
          testGoldens(
              'screenMatchesGolden method uses enableRealShadows from global configuration when GoldenToolkit.runWithConfiguration is outside testGoldens',
              (tester) async {
            await tester.pumpWidgetBuilder(WidgetWithShadows());
            await screenMatchesGolden(
                tester, 'enableRealShadows_honored_when_testGoldens_wrapped');

            expect(debugDisableShadows, isFalse,
                reason: 'debugDisableShadows should be false during this test');
          });
        },
        config: GoldenToolkit.configuration.copyWith(enableRealShadows: true),
      );

      testGoldens(
          'screenMatchesGolden method does not use enableRealShadows from global configuration when GoldenToolkit.runWithConfiguration is inside testGoldens',
          (tester) async {
        await GoldenToolkit.runWithConfiguration(
          () async {
            await tester.pumpWidgetBuilder(WidgetWithShadows());
            await screenMatchesGolden(tester,
                'enableRealShadows_ignored_when_testGoldens_not_wrapped');

            expect(debugDisableShadows, isTrue,
                reason: 'debugDisableShadows should be true during this test');
          },
          config: GoldenToolkit.configuration.copyWith(enableRealShadows: true),
        );
      });
    });

    test('Default Configuration', () {
      final config = GoldenToolkitConfiguration();
      expect(config.skipGoldenAssertion(), isFalse);
      expect(
          config.fileNameFactory('test_name'), equals('goldens/test_name.png'));
      expect(
        config.deviceFileNameFactory(
            'test_name', const Device(name: 'my_device', size: Size(500, 500))),
        equals('goldens/test_name.my_device.png'),
      );
      expect(config.defaultDevices,
          equals([Device.phone, Device.tabletLandscape]));
      expect(config.enableRealShadows, isFalse);
    });

    group('Equality/Hashcode/CopyWith', () {
      bool skipGoldenAssertion() => false;
      String fileNameFactory(String filename) => '';
      String deviceFileNameFactory(String filename, Device device) => '';
      Future<void> primeAssets(WidgetTester tester) async {}
      final devices = [Device.iphone11, Device.iphone11.dark()];
      const enableRealShadows = true;

      final config = GoldenToolkitConfiguration(
        skipGoldenAssertion: skipGoldenAssertion,
        deviceFileNameFactory: deviceFileNameFactory,
        fileNameFactory: fileNameFactory,
        primeAssets: primeAssets,
        defaultDevices: devices,
        enableRealShadows: enableRealShadows,
      );

      test('config with identical params should be equal', () {
        expect(config, equals(config.copyWith()));
        expect(config.hashCode, equals(config.copyWith().hashCode));
      });

      group('should not be equal when params differ', () {
        test('skipGoldenAssertion', () {
          expect(config,
              isNot(equals(config.copyWith(skipGoldenAssertion: () => false))));
          expect(
              config.hashCode,
              isNot(equals(
                  config.copyWith(skipGoldenAssertion: () => false).hashCode)));
        });
        test('fileNameFactory', () {
          expect(config,
              isNot(equals(config.copyWith(fileNameFactory: (file) => ''))));
          expect(
              config.hashCode,
              isNot(equals(
                  config.copyWith(fileNameFactory: (file) => '').hashCode)));
        });
        test('deviceFileNameFactory', () {
          expect(
              config,
              isNot(equals(
                  config.copyWith(deviceFileNameFactory: (file, dev) => ''))));
          expect(
              config.hashCode,
              isNot(equals(config
                  .copyWith(deviceFileNameFactory: (file, dev) => '')
                  .hashCode)));
        });
        test('primeImages', () {
          expect(config,
              isNot(equals(config.copyWith(primeAssets: (_) async {}))));
          expect(
              config.hashCode,
              isNot(
                  equals(config.copyWith(primeAssets: (_) async {}).hashCode)));
        });

        test('defaultDevices', () {
          expect(
              config,
              isNot(equals(
                  config.copyWith(defaultDevices: [Device.tabletPortrait]))));
          expect(
              config.hashCode,
              isNot(equals(config.copyWith(
                  defaultDevices: [Device.tabletPortrait]).hashCode)));
        });

        test('enableRealShadows', () {
          expect(
              config,
              isNot(equals(
                  config.copyWith(enableRealShadows: !enableRealShadows))));
          expect(
              config.hashCode,
              isNot(equals(config
                  .copyWith(enableRealShadows: !enableRealShadows)
                  .hashCode)));
        });
      });
    });
  });
}
