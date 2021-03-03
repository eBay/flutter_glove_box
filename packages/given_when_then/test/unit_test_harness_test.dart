import 'package:flutter_test/flutter_test.dart';

import 'example_unit_test_support.dart';

void main() {
  test('Example usage of the unit test harness', harness((given, when, then) async {
    given.preCondition();
    await when.userPerformsSomeAction();
    then.makeSomeAssertion();
  }));
}
