import 'package:golden_toolkit/golden_toolkit.dart';

// ignore: avoid_relative_lib_imports
import '../../lib/src/shadow_widget.dart';

void main() {
  testGoldens('Shadows are globally enabled by default', (tester) async {
    await tester.pumpWidgetBuilder(ShadowWidget());

    await screenMatchesGolden(tester, 'shadow_widget_globally_enabled_shadows');
  });

  GoldenToolkit.runWithConfiguration(
    () => {
      testGoldens(
          'Shadows can be disabled locally by wrapping in GoldenToolkit.runWithConfiguration',
          (tester) async {
        await tester.pumpWidgetBuilder(ShadowWidget());

        await screenMatchesGolden(
            tester, 'shadow_widget_locally_disabled_shadows');
      })
    },
    config: GoldenToolkit.configuration.copyWith(enableRealShadows: false),
  );
}
