/// ***************************************************
/// Copyright 2019-2020 eBay Inc.
///
/// Use of this source code is governed by a BSD-style
/// license that can be found in the LICENSE file or at
/// https://opensource.org/licenses/BSD-3-Clause
/// ***************************************************
///

import 'package:flutter_test/flutter_test.dart';
import 'package:meta/meta.dart';

import '../golden_toolkit.dart';

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

/// A function that primes all needed assets for the given [tester].
///
/// The [name] is the name of the golden file to prime assets for and [finder] is the finder used
/// to call [matchesGoldenFile] on.
///
/// For ready to use implementations see:
/// * [defaultPrimeAssets], which is the default [PrimeAssets] used by the global configuration by default.
/// * [waitForAllImages], which just waits for all [Image] widgets in the widget tree to finish decoding.
typedef PrimeAssets = Future<void> Function(WidgetTester tester, String name, Finder finder);

/// Represents configuration options for the GoldenToolkit. These are akin to environmental flags.
@immutable
class GoldenToolkitConfiguration {
  /// GoldenToolkitConfiguration constructor
  ///
  /// [skipGoldenAssertion] a func that returns a bool as to whether the golden assertion should be skipped.
  /// A typical example may be to skip when the assertion is invoked on certain platforms. For example: () => !Platform.isMacOS
  const GoldenToolkitConfiguration({
    this.skipGoldenAssertion = _doNotSkip,
    this.primeAssets = defaultPrimeAssets,
  });

  /// a function indicating whether a golden assertion should be skipped
  final SkipGoldenAssertion skipGoldenAssertion;

  /// A function that primes all needed assets for the given [tester]. Defaults to [defaultPrimeAssets]
  /// which primes all assets using another call to [matchesGoldenFile].
  final PrimeAssets primeAssets;
}

bool _doNotSkip() => false;
