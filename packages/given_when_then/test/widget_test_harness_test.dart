import 'package:flutter_test/flutter_test.dart';

import 'example_widget_test_support.dart';

void main() {
  testWidgets('Example usage of the widget test harness', harness((given, when, then) async {
    await given.preCondition();
    await when.userPerformsSomeAction();
    await then.makeSomeAssertion();
  }));
}
