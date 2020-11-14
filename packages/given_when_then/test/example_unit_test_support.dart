import 'package:flutter_test/flutter_test.dart';
import 'package:given_when_then/given_when_then.dart';

Future<void> Function() harness(UnitTestHarnessCallback<_Harness> callback) {
  return () => givenWhenThenUnitTest(_Harness(), callback);
}

class _Harness extends UnitTestHarness {
  _Harness() : super();

  int counter = 0;
}

extension ExampleGiven on UnitTestGiven<_Harness> {
  void preCondition() {
    this.harness.counter = 1;
  }
}

extension ExampleWhen on UnitTestWhen<_Harness> {
  Future<void> userPerformsSomeAction() async {
    this.harness.counter++;
  }
}

extension ExampleThen on UnitTestThen<_Harness> {
  void makeSomeAssertion() {
    expect(this.harness.counter, equals(2));
  }
}
