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

void main() {
  group('GoldenToolkitConfiguration Tests', () {
    testGoldens('screenMatchesGolden method should defer skip to global configuration', (tester) async {
      return GoldenToolkit.runWithConfiguration(
        () async {
          await tester.pumpWidget(Container());
          await screenMatchesGolden(tester, 'this_is_expected_to_skip');
        },
        config: GoldenToolkitConfiguration(skipGoldenAssertion: () => true),
      );
    });

    testGoldens('screenMatchesGolden method level skip should trump global configuration', (tester) async {
      return GoldenToolkit.runWithConfiguration(
        () async {
          await tester.pumpWidgetBuilder(Container());
          //ignore: deprecated_member_use_from_same_package
          await screenMatchesGolden(tester, 'this_is_expected_to_skip', skip: true);
        },
        config: GoldenToolkitConfiguration(skipGoldenAssertion: () => false),
      );
    });

    testGoldens('MultiScreenGolden method should defer skip to global configuration', (tester) async {
      return GoldenToolkit.runWithConfiguration(
        () async {
          await tester.pumpWidgetBuilder(Container());
          await multiScreenGolden(tester, 'this_is_expected_to_skip');
        },
        config: GoldenToolkitConfiguration(skipGoldenAssertion: () => true),
      );
    });

    testGoldens('MultiScreenGolden method level skip should trump global configuration', (tester) async {
      return GoldenToolkit.runWithConfiguration(
        () async {
          await tester.pumpWidgetBuilder(Container());
          //ignore: deprecated_member_use_from_same_package
          await multiScreenGolden(tester, 'this_is_expected_to_skip', skip: true);
        },
        config: GoldenToolkitConfiguration(skipGoldenAssertion: () => false),
      );
    });

    testGoldens('screenMatchesGolden method should defer fileNameFactory to global configuration', (tester) async {
      return GoldenToolkit.runWithConfiguration(
        () async {
          await tester.pumpWidgetBuilder(Container());
          await screenMatchesGolden(tester, 'global_file_name_factory');
        },
        config: GoldenToolkit.configuration.copyWith(fileNameFactory: (name) => 'goldens/custom/custom_$name.png'),
      );
    });

    testGoldens('multiScreenGolden method should defer fileNameFactory to global configuration', (tester) async {
      return GoldenToolkit.runWithConfiguration(
        () async {
          await tester.pumpWidgetBuilder(Container());
          await multiScreenGolden(tester, 'global_device_file_name_factory');
        },
        config: GoldenToolkit.configuration
            .copyWith(deviceFileNameFactory: (name, device) => 'goldens/custom/custom_${name}_${device.name}.png'),
      );
    });

    test('Default Configuration', () {
      const config = GoldenToolkitConfiguration();
      expect(config.skipGoldenAssertion(), isFalse);
      expect(config.fileNameFactory('test_name'), equals('goldens/test_name.png'));
      expect(
        config.deviceFileNameFactory('test_name', const Device(name: 'my_device', size: Size(500, 500))),
        equals('goldens/test_name.my_device.png'),
      );
    });

    group('Equality/Hashcode/CopyWith', () {
      bool skipGoldenAssertion() => false;
      String fileNameFactory(String filename) => '';
      String deviceFileNameFactory(String filename, Device device) => '';

      final config = GoldenToolkitConfiguration(
        skipGoldenAssertion: skipGoldenAssertion,
        deviceFileNameFactory: deviceFileNameFactory,
        fileNameFactory: fileNameFactory,
      );

      test('config with identical params should be equal', () {
        expect(config, equals(config.copyWith()));
        expect(config.hashCode, equals(config.copyWith().hashCode));
      });

      group('should not be equal when params differ', () {
        test('skipGoldenAssertion', () {
          expect(config, isNot(equals(config.copyWith(skipGoldenAssertion: () => false))));
          expect(config.hashCode, isNot(equals(config.copyWith(skipGoldenAssertion: () => false).hashCode)));
        });
        test('fileNameFactory', () {
          expect(config, isNot(equals(config.copyWith(fileNameFactory: (file) => ''))));
          expect(config.hashCode, isNot(equals(config.copyWith(fileNameFactory: (file) => '').hashCode)));
        });
        test('deviceFileNameFactory', () {
          expect(config, isNot(equals(config.copyWith(deviceFileNameFactory: (file, dev) => ''))));
          expect(config.hashCode, isNot(equals(config.copyWith(deviceFileNameFactory: (file, dev) => '').hashCode)));
        });
      });
    });
  });
}
