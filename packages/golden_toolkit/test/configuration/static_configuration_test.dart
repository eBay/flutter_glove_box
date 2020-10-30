import 'package:flutter/material.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

void main() {
  testGoldens('legacy static global configuration should still work',
      (tester) async {
    //ignore:deprecated_member_use_from_same_package
    GoldenToolkit.configure(
        GoldenToolkitConfiguration(skipGoldenAssertion: () => true));
    await tester.pumpWidget(Container());
    await screenMatchesGolden(tester, 'this_is_expected_to_skip');
  });
}
