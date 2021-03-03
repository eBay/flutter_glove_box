import 'package:flutter_test/flutter_test.dart';
import 'package:given_when_then/given_when_then.dart';

Future<void> Function() harness(UnitTestHarnessCallback<_ExampleUnitTestHarness> callback) {
  return () => givenWhenThenUnitTest(_ExampleUnitTestHarness(), callback);
}

class _ExampleUnitTestHarness {
  _ExampleUnitTestHarness() : super();

  int counter = 0;
}

extension ExampleGiven on UnitTestGiven<_ExampleUnitTestHarness> {
  void preCondition() {
    this.harness.counter = 1;
  }
}

extension ExampleWhen on UnitTestWhen<_ExampleUnitTestHarness> {
  Future<void> userPerformsSomeAction() async {
    this.harness.counter++;
  }
}

extension ExampleThen on UnitTestThen<_ExampleUnitTestHarness> {
  void makeSomeAssertion() {
    expect(this.harness.counter, equals(2));
  }
}
