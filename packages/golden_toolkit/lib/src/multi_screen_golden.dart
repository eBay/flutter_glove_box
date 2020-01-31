import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'testing_tools.dart';

Future<void> _onlyPumpAndSettle(WidgetTester tester) async =>
    tester.pumpAndSettle();

/// This [multiScreenGolden] will run [tests] for given [devices] list
///
/// Will output a single  golden file for each device in [devices] and will append device name to png file
///
/// [goldenFileName] is a file name output, must NOT include extension like .png
///
/// [finder] optional finder, defaults to [WidgetsApp]
///
/// [overrideGoldenHeight] might be required to override output file height in case if it should be bigger than device height
///
/// [customPump] optional pump function, see [CustomPump] documentation
///
/// [devices] list of devices to run the tests
///
/// [skip] by setting to true will skip the golden file assertion. This may be necessary if your development platform is not the same as your CI platform
///
Future<void> multiScreenGolden(
  WidgetTester tester,
  String goldenFileName, {
  Finder finder,
  double overrideGoldenHeight,
  CustomPump customPump = _onlyPumpAndSettle,
  List<Device> devices = const [
    Device.phone,
    Device.tabletLandscape,
  ],
  bool skip = false,
}) async {
  for (final device in devices) {
    final size =
        Size(device.size.width, overrideGoldenHeight ?? device.size.height);
    await tester.binding.setSurfaceSize(size);
    tester.binding.window.physicalSizeTestValue = device.size;
    tester.binding.window.devicePixelRatioTestValue = device.devicePixelRatio;
    tester.binding.window.textScaleFactorTestValue = device.textScale;

    await tester.pump();
    await tester.pump();
    await screenMatchesGolden(
      tester,
      '$goldenFileName.${device.name}',
      customPump: customPump,
      skip: skip,
    );
  }
}

/// This [Device] is a configuration for golden test. Can be provided for [multiScreenGolden]

class Device {
  /// This [Device] is a configuration for golden test. Can be provided for [multiScreenGolden]
  const Device({
    this.size,
    this.devicePixelRatio = 1.0,
    this.name,
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
