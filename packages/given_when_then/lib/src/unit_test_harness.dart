typedef UnitTestHarnessCallback<T extends UnitTestHarness> = Future<void> Function(
    UnitTestGiven<T>, UnitTestWhen<T>, UnitTestThen<T>);

Future<void> givenWhenThenUnitTest<T extends UnitTestHarness>(T harness, UnitTestHarnessCallback<T> callback) =>
    callback(UnitTestGiven(harness), UnitTestWhen(harness), UnitTestThen(harness));

class UnitTestHarness {
  const UnitTestHarness();
}

class UnitTestGiven<T extends UnitTestHarness> {
  UnitTestGiven(this.harness);
  final T harness;
}

class UnitTestWhen<T extends UnitTestHarness> {
  UnitTestWhen(this.harness);
  final T harness;
}

class UnitTestThen<T extends UnitTestHarness> {
  UnitTestThen(this.harness);
  final T harness;
}
