/// ***************************************************
/// Copyright 2019-2020 eBay Inc.
///
/// Use of this source code is governed by a BSD-style
/// license that can be found in the LICENSE file or at
/// https://opensource.org/licenses/BSD-3-Clause
/// ***************************************************
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'device.dart';
import 'testing_tools.dart';

Future<void> _onlyPumpAndSettle(WidgetTester tester) async =>
    tester.pumpAndSettle();

Future<void> _twoPumps(Device device, WidgetTester tester) async {
  await tester.pump();
  await tester.pump();
}

typedef DeviceSetup = Future<void> Function(Device device, WidgetTester tester);

/// This [multiScreenGolden] will run [scenarios] for given [devices] list
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
/// [deviceSetup] allows custom setup after the window changes size.
/// Takes two pumps to modify the device size. It could take more if the widget tree uses widgets that schedule builds for the next run loop
/// e.g. StreamBuilder, FutureBuilder
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
  DeviceSetup deviceSetup = _twoPumps,
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
    tester.binding.window.paddingTestValue = _FakeWindowPadding(
      bottom: device.safeArea.bottom,
      left: device.safeArea.left,
      right: device.safeArea.right,
      top: device.safeArea.top,
    );
    await deviceSetup(device, tester);
    await screenMatchesGolden(
      tester,
      '$goldenFileName.${device.name}',
      customPump: customPump,
      skip: skip,
      finder: finder,
    );
  }
}

class _FakeWindowPadding implements WindowPadding {
  const _FakeWindowPadding({
    this.bottom = 0,
    this.left = 0,
    this.right = 0,
    this.top = 0,
  });

  @override
  final double bottom;

  @override
  final double left;

  @override
  final double right;

  @override
  final double top;
}
