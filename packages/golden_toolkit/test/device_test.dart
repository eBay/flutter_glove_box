import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

/// ***************************************************
/// Copyright 2019-2020 eBay Inc.
///
/// Use of this source code is governed by a BSD-style
/// license that can be found in the LICENSE file or at
/// https://opensource.org/licenses/BSD-3-Clause
/// ***************************************************
///
void main() {
  group('Device Tests', () {
    test('copy with no parameters', () {
      final copied = Device.phone.copyWith();
      expect(copied, isNot(Device.phone));
      expect(copied.devicePixelRatio, equals(Device.phone.devicePixelRatio));
      expect(copied.name, equals(Device.phone.name));
      expect(copied.size, equals(Device.phone.size));
      expect(copied.textScale, equals(Device.phone.textScale));
    });

    test('copy with parameters', () {
      final copied = Device.phone.copyWith(
        textScale: 3.0,
        devicePixelRatio: 2.0,
        name: 'foo',
        size: const Size(100, 100),
      );
      expect(copied.devicePixelRatio, equals(2.0));
      expect(copied.name, equals('foo'));
      expect(copied.size, equals(const Size(100, 100)));
      expect(copied.textScale, equals(3.0));
    });
  });
}
