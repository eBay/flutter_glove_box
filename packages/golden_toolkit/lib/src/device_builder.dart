/// ***************************************************
/// Copyright 2019-2020 eBay Inc.
///
/// Use of this source code is governed by a BSD-style
/// license that can be found in the LICENSE file or at
/// https://opensource.org/licenses/BSD-3-Clause
/// ***************************************************

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../golden_toolkit.dart';
import 'testing_tools.dart';

/// Class containing whats required to create a Scenario
class _DeviceScenario {
  /// constructs a DeviceScenario
  _DeviceScenario({
    required this.key,
    this.onCreate,
    required this.widget,
  });

  /// key that references created scenario and specific device
  final Key key;

  /// function that is executed after initial pump of widget
  final OnScenarioCreate? onCreate;

  /// widget that represents this device/scenario
  final _DeviceScenarioWidget widget;
}

/// DeviceBuilder builds [Device] size driven layout for its children
class DeviceBuilder {
  /// Create scenarios rendered on multiple device sizes in a widget
  /// to take a golden snapshot of. Renders devices horizontally and scenarios
  /// vertically.
  ///
  /// [wrap] (optional) will wrap the scenario's widget in the tree.
  ///
  /// [bgColor] will change the background color of output .png file
  DeviceBuilder({
    this.wrap,
    this.bgColor,
  });

  /// Can be used to wrap all scenario widgets. Useful if you wish to
  /// provide consistent UI treatment to all of them or need to inject dependencies.
  final WidgetWrapper? wrap;

  ///  background [bgColor] color of output .png file
  final Color? bgColor;

  /// list of created DeviceScenarios for each device type
  final List<_DeviceScenario> scenarios = [];

  List<Device> _devicesForScenarios =
      GoldenToolkit.configuration.defaultDevices;
  int get _numberOfDevicesPerScenario => _devicesForScenarios.length;

  /// Overrides the list of devices that are rendered for each scenario
  /// Otherwise will default to using `GoldenToolkit.configuration.defaultDevices`
  void overrideDevicesForAllScenarios({required List<Device> devices}) {
    assert(devices.isNotEmpty);
    _devicesForScenarios = devices;
  }

  /// [addScenario] will add a [_DeviceScenario] for each device listed
  /// under [_devicesForScenarios]
  ///
  /// [widget] widget you'd like rendered ad Device sizes
  ///
  /// [name] name of scenario 'e.g 'error_state'
  void addScenario({
    required Widget widget,
    String? name,
    OnScenarioCreate? onCreate,
  }) {
    for (final dev in _devicesForScenarios) {
      final scenarioName = '${name ?? ''} - ${dev.name}';

      final key = Key(scenarioName);

      scenarios.add(
        _DeviceScenario(
          key: key,
          onCreate: onCreate,
          widget: _DeviceScenarioWidget(
            key: key,
            device: dev,
            widget: widget,
            wrap: wrap,
            name: scenarioName,
          ),
        ),
      );
    }
  }

  /// outputs calculated required size to render all Scenarios and their corresponding Devices
  Size get requiredWidgetSize {
    var width = scenarios
        .map((scenario) => scenario.widget.scenarioSize.width)
        .reduce((pw, cw) => pw + cw);

    var height = scenarios
        .map((scenario) => scenario.widget.scenarioSize.height)
        .reduce(max);

    if (scenarios.length > _numberOfDevicesPerScenario) {
      final scenariosPerDevice = scenarios.length / _numberOfDevicesPerScenario;
      width = width / scenariosPerDevice;
      height = height * scenariosPerDevice;
    }

    return Size(width, height);
  }

  ///  [build] will build a list of [_scenarios]  with a given layout
  Widget build() {
    final requiredSize = requiredWidgetSize;
    final numberOfDevices = _numberOfDevicesPerScenario;

    assert(scenarios.length % numberOfDevices == 0,
        'scenarios should always be divisible by number of devices');

    final numberOfRequiredRows = scenarios.length ~/ numberOfDevices;
    final scenarioRows = <Row>[];
    for (var i = 0; i < numberOfRequiredRows; i++) {
      final startRange = i * numberOfDevices;
      scenarioRows.add(Row(
        children: scenarios
            .getRange(startRange, startRange + numberOfDevices)
            .map((scenario) => scenario.widget)
            .toList(),
      ));
    }

    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        width: requiredSize.width,
        height: requiredSize.height,
        color: bgColor ?? const Color(0xFFEEEEEE),
        child: Column(
          children: [
            ...scenarioRows,
          ],
        ),
      ),
    );
  }
}

class _DeviceScenarioWidget extends StatelessWidget {
  const _DeviceScenarioWidget({
    required Key key,
    required this.device,
    required this.widget,
    this.wrap,
    this.name,
  }) : super(key: key);

  final WidgetWrapper? wrap;
  final Device device;
  final Widget widget;
  final String? name;

  static const double _horizontalScenarioPadding = 8.0;
  static const double _borderWidth = 1.0;

  Size get scenarioSize => Size(
      device.size.width + (_horizontalScenarioPadding * 2) + (_borderWidth * 2),
      device.size.height + 24 + (_borderWidth * 2));

  Widget get _sizedWidget => MediaQuery(
        data: MediaQueryData(size: device.size),
        child: Container(
          width: device.size.width,
          height: device.size.height,
          child: widget,
        ),
      );

  @override
  Widget build(BuildContext context) {
    final scenarioWidget = wrap?.call(_sizedWidget) ?? _sizedWidget;
    return ClipRect(
      child: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: _horizontalScenarioPadding),
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(
            width: 1,
            color: Colors.lightBlue,
          )),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 20,
                width: device.size.width,
                child: Text(
                  name ?? device.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              scenarioWidget,
            ],
          ),
        ),
      ),
    );
  }
}
