import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:golden_toolkit/src/configuration.dart';

void main() {
  group('Platform agnostic golden', () {
    // this test is intended to run on all platforms, with the assumption that it will
    // generate the same pixels regardless of where it is run
    testGoldens('empty container should look right', (tester) async {
      await GoldenToolkit.runWithConfiguration(
        () async {
          await tester.pumpWidget(Container());
          await screenMatchesGolden(tester, 'empty_container');
        },
        config: GoldenToolkit.configuration
            .copyWith(skipGoldenAssertion: () => false),
      );
    });
  });
}
