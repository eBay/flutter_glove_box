import 'package:flutter_test/flutter_test.dart';

import 'unit_test_harness.dart';

typedef WidgetTestHarnessCallback<T extends WidgetTestHarness> = Future<void> Function(
    WidgetTestGiven<T>, WidgetTestWhen<T>, WidgetTestThen<T>);

Future<void> givenWhenThenWidgetTest<T extends WidgetTestHarness>(T harness, WidgetTestHarnessCallback<T> callback) =>
    callback(WidgetTestGiven(harness), WidgetTestWhen(harness), WidgetTestThen(harness));

class WidgetTestHarness extends UnitTestHarness {
  const WidgetTestHarness(this.tester);
  final WidgetTester tester;
}

class WidgetTestGiven<T extends WidgetTestHarness> extends UnitTestGiven<T> {
  WidgetTestGiven(T harness) : super(harness);
  WidgetTester get tester => harness.tester;
}

class WidgetTestWhen<T extends WidgetTestHarness> extends UnitTestWhen<T> {
  WidgetTestWhen(T harness) : super(harness);
  WidgetTester get tester => harness.tester;
}

class WidgetTestThen<T extends WidgetTestHarness> extends UnitTestThen<T> {
  WidgetTestThen(T harness) : super(harness);
  WidgetTester get tester => harness.tester;
}
