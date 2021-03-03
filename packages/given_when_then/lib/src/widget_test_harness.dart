import 'package:flutter_test/flutter_test.dart';

import 'unit_test_harness.dart';

/// This function is intended to wrap your Widget tests so that you can access the [WidgetTestGiven], [WidgetTestWhen],
/// and [WidgetTestWhen] to compose the test case. You will want to create some of your own test support code that is
/// specific to your code under test. It should look something like this:
typedef WidgetTestHarnessCallback<T extends WidgetTestHarness> = Future<void>
    Function(WidgetTestGiven<T>, WidgetTestWhen<T>, WidgetTestThen<T>);

/// This function is intended to wrap your Widget tests so that you can access the [WidgetTestGiven], [WidgetTestWhen],
/// and [WidgetTestWhen] to compose the test case. You will want to create some of your own test support code that is
/// specific to your code under test. It should look something like this:
/// ```dart
/// Future<void> Function(WidgetTester) harness(WidgetTestHarnessCallback<_ExampleWidgetTestHarness> callback) {
///   return (tester) => givenWhenThenWidgetTest(_ExampleWidgetTestHarness(tester), callback);
/// }
/// ```
/// See [example_widget_test_support.dart] for a complete example
Future<void> givenWhenThenWidgetTest<T extends WidgetTestHarness>(
        T harness, WidgetTestHarnessCallback<T> callback) =>
    callback(WidgetTestGiven(harness), WidgetTestWhen(harness),
        WidgetTestThen(harness));

/// You can use this class directly and then author your own extensions to it for your specific behaviors or you can
/// extend this class and provide any dependencies you require. See [example_widget_test_support.dart] for a complete example
class WidgetTestHarness {
  /// Creates the [WidgetTestHarness] that is require by [WidgetTestGiven], [WidgetTestWhen], and [WidgetTestThen]
  const WidgetTestHarness(this.tester);

  /// Class that programmatically interacts with widgets and the test environment.
  final WidgetTester tester;
}

/// You can use this class directly and then author your own extensions to it for your specific behaviors or you can
/// extend this class and provide any dependencies you require. See [example_widget_test_support.dart] for a complete example
class WidgetTestGiven<T extends WidgetTestHarness> extends UnitTestGiven<T> {
  /// Creates the [WidgetTestGiven], which makes both the [WidgetTestHarness] and the [WidgetTester] available for use
  /// in test pre conditions.
  WidgetTestGiven(T harness) : super(harness);

  /// Class that programmatically interacts with widgets and the test environment.
  WidgetTester get tester => harness.tester;
}

/// You can use this class directly and then author your own extensions to it
/// for your specific behaviors or you can extend this class and provide any
/// dependencies you require. See [example_widget_test_support.dart] for a
/// complete example
class WidgetTestWhen<T extends WidgetTestHarness> extends UnitTestWhen<T> {
  /// Creates the [WidgetTestWhen], which makes both the [WidgetTestHarness]
  /// and the [WidgetTester] available for use
  /// in test actions.
  WidgetTestWhen(T harness) : super(harness);

  /// Class that programmatically interacts with widgets and the test
  /// environment.
  WidgetTester get tester => harness.tester;
}

/// You can use this class directly and then author your own extensions to it
/// for your specific behaviors or you can
/// extend this class and provide any dependencies you require.
/// See [example_widget_test_support.dart] for a complete example
class WidgetTestThen<T extends WidgetTestHarness> extends UnitTestThen<T> {
  /// Creates the [WidgetTestThen], which makes both the [WidgetTestHarness]
  /// and the [WidgetTester] available for use in test actions.
  WidgetTestThen(T harness) : super(harness);

  /// Class that programmatically interacts with widgets and the test
  /// environment.
  WidgetTester get tester => harness.tester;
}
