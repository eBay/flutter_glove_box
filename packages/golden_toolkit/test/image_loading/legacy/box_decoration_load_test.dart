import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:golden_toolkit/src/configuration.dart';

import '../image_loading_utils.dart';

void main() {
  group(
    'Image Loading Tests - Legacy',
    () {
      testWidgets('should load assets from BoxDecoration images', (tester) async {
        await GoldenToolkit.runWithConfiguration(
          () async {
            await tester.pumpWidgetBuilder(const BoxDecorationWithImage());
            await tester.waitForAssets();
            await tester.pump();
            await expectLater(find.byType(BoxDecorationWithImage).first,
                matchesGoldenFile('goldens/boxdecoration_will_show_legacy.png'));
          },
          config: legacyConfiguration,
        );
      });
    },
  );
}
