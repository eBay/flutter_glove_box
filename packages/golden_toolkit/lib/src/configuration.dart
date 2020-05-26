import 'package:meta/meta.dart';

/// Manages global state & behavior for the Golden Toolkit
/// This is a singleton so that it can be easily configured in one place
/// and shared across tests
class GoldenToolkit {
  GoldenToolkit._();

  static GoldenToolkitConfiguration _configuration =
      const GoldenToolkitConfiguration();

  /// the current global configuration for the GoldenToolkit
  static GoldenToolkitConfiguration get configuration => _configuration;

  /// Invoke this to replace the current Golden Toolkit configuration
  static void configure(GoldenToolkitConfiguration configuration) {
    _configuration = configuration;
  }
}

typedef SkipGoldenAssertion = bool Function();

/// Represents configuration options for the GoldenToolkit. These are akin to environmental flags.
@immutable
class GoldenToolkitConfiguration {
  /// GoldenToolkitConfiguration constructor
  ///
  /// [skipGoldenAssertion] a func that returns a bool as to whether the golden assertion should be skipped.
  /// A typical example may be to skip when the assertion is invoked on certain platforms. For example: () => !Platform.isMacOS
  const GoldenToolkitConfiguration({
    this.skipGoldenAssertion = _doNotSkip,
  });

  /// a function indicating whether a golden assertion should be skipped
  final SkipGoldenAssertion skipGoldenAssertion;
}

bool _doNotSkip() => true;
