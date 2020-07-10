/// ***************************************************
/// Copyright 2019-2020 eBay Inc.
///
/// Use of this source code is governed by a BSD-style
/// license that can be found in the LICENSE file or at
/// https://opensource.org/licenses/BSD-3-Clause
/// ***************************************************
///

import 'dart:ui';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

void main() {
  group('Device Tests', () {
    test('copy with no parameters', () {
      final copied = Device.phone.copyWith();
      expect(copied, isNot(Device.phone));
      expect(copied.devicePixelRatio, equals(Device.phone.devicePixelRatio));
      expect(copied.name, equals(Device.phone.name));
      expect(copied.size, equals(Device.phone.size));
      expect(copied.textScale, equals(Device.phone.textScale));
      expect(copied.brightness, equals(Device.phone.brightness));
      expect(copied.safeArea, equals(Device.phone.safeArea));
    });

    test('copy with parameters', () {
      final copied = Device.phone.copyWith(
        textScale: 3.0,
        devicePixelRatio: 2.0,
        name: 'foo',
        size: const Size(100, 100),
        brightness: Brightness.dark,
        safeArea: const EdgeInsets.symmetric(vertical: 16),
      );
      expect(copied.devicePixelRatio, equals(2.0));
      expect(copied.name, equals('foo'));
      expect(copied.size, equals(const Size(100, 100)));
      expect(copied.textScale, equals(3.0));
      expect(copied.brightness, equals(Brightness.dark));
      expect(copied.safeArea, equals(const EdgeInsets.symmetric(vertical: 16)));
    });

    test('dark() helper', () {
      final dark = Device.iphone11.dark();
      expect(dark.devicePixelRatio, equals(Device.iphone11.devicePixelRatio));
      expect(dark.name, equals('iphone11_dark'));
      expect(dark.size, equals(Device.iphone11.size));
      expect(dark.textScale, equals(Device.iphone11.textScale));
      expect(dark.brightness, equals(Brightness.dark));
      expect(dark.safeArea, equals(Device.iphone11.safeArea));
    });

    test('toString()', () {
      const device = Device(
        name: 'foo',
        size: Size(100, 200),
        devicePixelRatio: 1.5,
        brightness: Brightness.dark,
        safeArea: EdgeInsets.all(1),
        textScale: 1.5,
      );
      expect(device.toString(),
          equals('Device: foo, 100.0x200.0 @ 1.5, text: 1.5, Brightness.dark, safe: EdgeInsets.all(1.0)'));
    });
  });
}
