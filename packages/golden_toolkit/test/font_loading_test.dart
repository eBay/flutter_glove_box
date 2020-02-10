import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

Future<void> main() async {
  group('Font loading', () {
    testGoldens('Roboto fonts should work', (tester) async {
      final golden = GoldenBuilder.column()
        ..addScenario('Material Fonts should work',
            const Text('This is material text in "Roboto"'))
        ..addScenario(
            'Material Icons should work', const Icon(Icons.phone_in_talk))
        ..addScenario('Fonts from packages should work',
            const Text('This is a custom font'))
        ..addScenario('Unknown fonts render in Ahem',
            const Text('unknown font', style: TextStyle(fontFamily: 'foo')));
      await tester.pumpWidgetBuilder(golden.build());
      await screenMatchesGolden(tester, 'material_fonts');
    });

    testGoldens(
        'Loading fonts from directories should work', (tester) async {});

    test('Font loading should throw if invalid path', () {});
  });
}
