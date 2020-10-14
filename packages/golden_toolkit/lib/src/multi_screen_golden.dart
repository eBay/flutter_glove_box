/// ***************************************************
/// Copyright 2019-2020 eBay Inc.
///
/// Use of this source code is governed by a BSD-style
/// license that can be found in the LICENSE file or at
/// https://opensource.org/licenses/BSD-3-Clause
/// ***************************************************

//ignore_for_file: deprecated_member_use_from_same_package

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../golden_toolkit.dart';
import 'device.dart';
import 'testing_tools.dart';
import 'widget_tester_extensions.dart';

Future<void> _twoPumps(Device device, WidgetTester tester) async {
  await tester.pump();
  await tester.pump();
}

typedef DeviceSetup = Future<void> Function(Device device, WidgetTester tester);

/// This [multiScreenGolden] will run [scenarios] for given [devices] list
///
/// Will output a single  golden file for each device in [devices] and will append device name to png file
///
/// [name] is a file name output, must NOT include extension like .png
///
/// [autoHeight] tries to find the optimal height for the output surface. If there is a vertical scrollable this
/// ensures the whole scrollable is shown. If the targeted render box is smaller then the current height, this will
/// shrink down the output height to match the render boxes height.
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
  String name, {
  Finder finder,
  bool autoHeight,
  double overrideGoldenHeight,
  CustomPump customPump,
  DeviceSetup deviceSetup,
  List<Device> devices,
  @Deprecated('This method level parameter will be removed in an upcoming release. This can be configured globally. If you have concerns, please file an issue with your use case.')
      bool skip,
}) async {
  assert(devices == null || devices.isNotEmpty);
  final deviceSetupPump = deviceSetup ?? _twoPumps;
  for (final device in devices ?? GoldenToolkit.configuration.defaultDevices) {
    await tester.binding.runWithDeviceOverrides(
      device,
      body: () async {
        if (overrideGoldenHeight != null) {
          await tester.binding.setSurfaceSize(Size(device.size.width, overrideGoldenHeight));
        }
        await deviceSetupPump(device, tester);
        await compareWithGolden(
          tester,
          name,
          customPump: customPump,
          autoHeight: autoHeight,
          finder: finder,
          //ignore: deprecated_member_use_from_same_package
          skip: skip,
          device: device,
          fileNameFactory: GoldenToolkit.configuration.deviceFileNameFactory,
        );
      },
    );
  }
}

/// This [multiDeviceGolden] will create a [DeviceBuilder] for different [scenarios] for given [devices] list
///
/// Will output a single golden file for all devices
///
/// [name] is a file name output, must NOT include extension like .png
///
/// [customPump] optional pump function, see [CustomPump] documentation
///
/// [devices] list of devices to run the tests - overriding `GoldenToolkit.configuration.defaultDevices`
///
/// [afterPump] is passed into DeviceBuilder scenario to be called after that device specific widget is rendered
///
Future<void> multiDeviceGolden(
  WidgetTester tester,
  String name, {
  Widget widget,
  CustomPump customPump,
  List<Device> devices,
  AfterPump afterPump,
}) async {
  assert(devices == null || devices.isNotEmpty);
  assert(tester.allWidgets.isNotEmpty);

  final devicesToUse = devices ?? GoldenToolkit.configuration.defaultDevices;

  final deviceBuilder = DeviceBuilder()
    ..overrideDevicesForAllScenarios(devices: devicesToUse)
    ..addDeviceScenario(
      widget: widget ?? tester.allWidgets.first,
      afterPump: afterPump,
    );

  await tester.pumpDeviceBuilder(deviceBuilder);

  if (customPump != null) {
    await customPump(tester);
  }

  await screenMatchesGolden(tester, name);
}
