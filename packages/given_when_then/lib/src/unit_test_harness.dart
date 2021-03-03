/// This function is intended to wrap your Unit tests so that you can access the
/// [UnitTestGiven], [UnitTestWhen], and [UnitTestWhen] to compose the test
/// case. You will want to create some of your own test support code that is
/// specific to your code under test. It should look something like this
typedef UnitTestHarnessCallback<T> = Future<void> Function(
    UnitTestGiven<T>, UnitTestWhen<T>, UnitTestThen<T>);

/// This function is intended to wrap your Unit tests so that you can access the
/// [UnitTestGiven], [UnitTestWhen], and [UnitTestWhen] to compose the test
/// case. You will want to create some of your own test support code that is
/// specific to your code under test. It should look something like this:
/// ```dart
/// Future<void> Function() harness(UnitTestHarnessCallback<_ExampleUnitTestHarness> callback) {
///   return () => givenWhenThenUnitTest(_ExampleUnitTestHarness(), callback);
/// }
/// ```
/// See [example_unit_test_support.dart] for a complete example
Future<void> givenWhenThenUnitTest<T>(
        T harness, UnitTestHarnessCallback<T> callback) =>
    callback(
        UnitTestGiven(harness), UnitTestWhen(harness), UnitTestThen(harness));

/// You can use this class directly and then author your own extensions to it
/// for your specific behaviors or you can extend this class and provide any
/// dependencies you require. See [example_unit_test_support.dart] for a
/// complete example
class UnitTestGiven<T> {
  /// Creates the [UnitTestGiven], which makes the [T] available for use in
  /// test pre conditions.
  UnitTestGiven(this.harness);

  /// An instance of the [T] that is used for setting up preconditions in a
  /// test.
  final T harness;
}

/// You can use this class directly and then author your own extensions to it
/// for your specific behaviors or you can extend this class and provide any
/// dependencies you require. See [example_unit_test_support.dart] for a
/// complete example
class UnitTestWhen<T> {
  /// Creates the [UnitTestWhen], which makes the [T] available to act on in
  /// tests.
  UnitTestWhen(this.harness);

  /// An instance of the [T] that is used for acting on the code under test.
  final T harness;
}

/// You can use this class directly and then author your own extensions to it
/// for your specific behaviors or you can extend this class and provide any
/// dependencies you require. See [example_unit_test_support.dart] for a
/// complete example
class UnitTestThen<T> {
  /// Creates the [UnitTestThen], which makes the [T] available to make
  /// assertions against in tests.
  UnitTestThen(this.harness);

  /// An instance of the [T] that is used for making assertions about the code
  /// under test.
  final T harness;
}
