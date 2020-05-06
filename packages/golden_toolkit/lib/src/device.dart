/// ***************************************************
/// Copyright 2019-2020 eBay Inc.
///
/// Use of this source code is governed by a BSD-style
/// license that can be found in the LICENSE file or at
/// https://opensource.org/licenses/BSD-3-Clause
/// ***************************************************

import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

/// This [Device] is a configuration for golden test. Can be provided for [multiScreenGolden]
class Device {
  /// This [Device] is a configuration for golden test. Can be provided for [multiScreenGolden]
  const Device({
    @required this.size,
    this.devicePixelRatio = 1.0,
    @required this.name,
    this.textScale = 1.0,
    this.brightness = Brightness.light,
    this.safeArea = const EdgeInsets.all(0),
  });

  /// [phone] one of the smallest phone screens
  static const Device phone = Device(name: 'phone', size: Size(375, 667));

  /// [iphone11] matches specs of iphone11, but with lower DPI for performance
  static const Device iphone11 = Device(
    name: 'iphone11',
    size: Size(414, 896),
    devicePixelRatio: 1.0,
    safeArea: EdgeInsets.only(top: 44, bottom: 34),
  );

  /// [tabletLandscape] example of tablet that in landscape mode
  static const Device tabletLandscape = Device(name: 'tablet_landscape', size: Size(1366, 1024));

  /// [tabletPortrait] example of tablet that in portrait mode
  static const Device tabletPortrait = Device(name: 'tablet_portrait', size: Size(1024, 1366));

  /// [name] specify device name. Ex: Phone, Tablet, Watch

  final String name;

  /// [size] specify device screen size. Ex: Size(1366, 1024))
  final Size size;

  /// [devicePixelRatio] specify device Pixel Ratio
  final double devicePixelRatio;

  /// [textScale] specify custom text scale
  final double textScale;

  /// [brightness] specify platform brightness
  final Brightness brightness;

  /// [safeArea] specify insets to define a safe area
  final EdgeInsets safeArea;

  /// [copyWith] convenience function for [Device] modification
  Device copyWith({
    Size size,
    double devicePixelRatio,
    String name,
    double textScale,
    Brightness brightness,
    EdgeInsets safeArea,
  }) {
    return Device(
      size: size ?? this.size,
      devicePixelRatio: devicePixelRatio ?? this.devicePixelRatio,
      name: name ?? this.name,
      textScale: textScale ?? this.textScale,
      brightness: brightness ?? this.brightness,
      safeArea: safeArea ?? this.safeArea,
    );
  }

  /// [dark] convenience method to copy the current device and apply dark theme
  Device dark() {
    return Device(
      size: size,
      devicePixelRatio: devicePixelRatio,
      textScale: textScale,
      brightness: Brightness.dark,
      safeArea: safeArea,
      name: '$name\_dark',
    );
  }
}
