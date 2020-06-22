/// ***************************************************
/// Copyright 2019-2020 eBay Inc.
///
/// Use of this source code is governed by a BSD-style
/// license that can be found in the LICENSE file or at
/// https://opensource.org/licenses/BSD-3-Clause
/// ***************************************************

import 'package:meta/meta.dart';
import 'package:flutter_test/flutter_test.dart';

import 'device.dart';

/// Manages global state & behavior for the Golden Toolkit
/// This is a singleton so that it can be easily configured in one place
/// and shared across tests
class GoldenToolkit {
  GoldenToolkit._();

  static GoldenToolkitConfiguration _configuration = const GoldenToolkitConfiguration();

  /// the current global configuration for the GoldenToolkit
  static GoldenToolkitConfiguration get configuration => _configuration;

  /// Invoke this to replace the current Golden Toolkit configuration
  static void configure(GoldenToolkitConfiguration configuration) {
    _configuration = configuration;
  }
}

typedef SkipGoldenAssertion = bool Function();

/// A factory to determine an actual file name/path from a given name.
///
/// See also:
/// * [screenMatchesGolden], which uses such a factory to determine the file name passed to [matchesGoldenFile].
/// * [GoldenToolkitConfiguration] to configure a global file name factory.
typedef FileNameFactory = String Function(String name);

/// A factory to determine a file name/path from a name and a device.
///
/// See also:
/// * [multiScreenGolden], which uses such a factory to determine the file name passed to [matchesGoldenFile].
/// * [GoldenToolkitConfiguration] to configure a global device file name factory.
typedef DeviceFileNameFactory = String Function(String name, Device device);

/// Represents configuration options for the GoldenToolkit. These are akin to environmental flags.
@immutable
class GoldenToolkitConfiguration {
  /// GoldenToolkitConfiguration constructor
  ///
  /// [skipGoldenAssertion] a func that returns a bool as to whether the golden assertion should be skipped.
  /// A typical example may be to skip when the assertion is invoked on certain platforms. For example: () => !Platform.isMacOS
  const GoldenToolkitConfiguration({
    this.skipGoldenAssertion = _doNotSkip,
    this.fileNameFactory = defaultFileNameFactory,
    this.deviceFileNameFactory = defaultDeviceFileNameFactory,
  });

  /// a function indicating whether a golden assertion should be skipped
  final SkipGoldenAssertion skipGoldenAssertion;

  /// A function to determine the file name/path [screenMatchesGolden] uses to call [matchesGoldenFile].
  final FileNameFactory fileNameFactory;

  /// A function to determine the file name/path [multiScreenGolden] uses to call [matchesGoldenFile].
  final DeviceFileNameFactory deviceFileNameFactory;

  /// Copies the configuration with the given values overridden.
  GoldenToolkitConfiguration copyWith({
    SkipGoldenAssertion skipGoldenAssertion,
    FileNameFactory fileNameFactory,
    DeviceFileNameFactory deviceFileNameFactory,
  }) {
    return GoldenToolkitConfiguration(
      skipGoldenAssertion: skipGoldenAssertion ?? this.skipGoldenAssertion,
      fileNameFactory: fileNameFactory ?? this.fileNameFactory,
      deviceFileNameFactory: deviceFileNameFactory ?? this.deviceFileNameFactory,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is GoldenToolkitConfiguration &&
            runtimeType == other.runtimeType &&
            skipGoldenAssertion == other.skipGoldenAssertion &&
            fileNameFactory == other.fileNameFactory &&
            deviceFileNameFactory == other.deviceFileNameFactory;
  }

  @override
  int get hashCode => skipGoldenAssertion.hashCode ^ fileNameFactory.hashCode ^ deviceFileNameFactory.hashCode;
}

bool _doNotSkip() => false;

/// This is the default file name factory which is used by [screenMatchesGolden] to determine the
/// actual file name for a golden test. The given [name] is the name passed into [screenMatchesGolden].
String defaultFileNameFactory(String name) {
  return 'goldens/$name.png';
}

/// This is the default file name factory which is used by [multiScreenGolden] to determine the
/// actual file name for a golden test. The given [name] is the name passed into [multiScreenGolden].
String defaultDeviceFileNameFactory(String name, Device device) {
  return 'goldens/$name.${device.name}.png';
}
