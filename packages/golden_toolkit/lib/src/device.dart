import 'dart:ui';

import 'package:meta/meta.dart';

/// ***************************************************
/// Copyright 2019-2020 eBay Inc.
///
/// Use of this source code is governed by a BSD-style
/// license that can be found in the LICENSE file or at
/// https://opensource.org/licenses/BSD-3-Clause
/// ***************************************************

/// This [Device] is a configuration for golden test. Can be provided for [multiScreenGolden]
class Device {
  /// This [Device] is a configuration for golden test. Can be provided for [multiScreenGolden]
  const Device({
    @required this.size,
    this.devicePixelRatio = 1.0,
    @required this.name,
    this.textScale = 1.0,
  });

  /// [phone] one of the smallest phone screens
  static const Device phone = Device(name: 'phone', size: Size(375, 667));

  /// [tabletLandscape] example of tablet that in landscape mode
  static const Device tabletLandscape =
      Device(name: 'tablet_landscape', size: Size(1366, 1024));

  /// [tabletPortrait] example of tablet that in portrait mode
  static const Device tabletPortrait =
      Device(name: 'tablet_portrait', size: Size(1024, 1366));

  /// [name] specify device name. Ex: Phone, Tablet, Watch

  final String name;

  /// [size] specify device screen size. Ex: Size(1366, 1024))
  final Size size;

  /// [devicePixelRatio] specify device Pixel Ratio
  final double devicePixelRatio;

  /// [textScale] specify custom text scale
  final double textScale;

  /// [copyWith] convenience function for [Device] modification
  Device copyWith({
    Size size,
    double devicePixelRatio,
    String name,
    double textScale,
  }) {
    return Device(
      size: size ?? this.size,
      devicePixelRatio: devicePixelRatio ?? this.devicePixelRatio,
      name: name ?? this.name,
      textScale: textScale ?? this.textScale,
    );
  }
}
