import 'package:golden_toolkit/golden_toolkit.dart';

// ignore: avoid_relative_lib_imports
import '../lib/src/shadow_widget.dart';

void main() {
  testGoldens('Shadows are disabled by default', (tester) async {
    await tester.pumpWidgetBuilder(ShadowWidget());

    await screenMatchesGolden(tester, 'shadow_widget_disabled_shadows');
  });

  GoldenToolkit.runWithConfiguration(
    () => {
      testGoldens(
          'Shadows can be enabled locally by wrapping in GoldenToolkit.runWithConfiguration',
          (tester) async {
        await tester.pumpWidgetBuilder(ShadowWidget());

        await screenMatchesGolden(
            tester, 'shadow_widget_locally_enabled_shadows');
      })
    },
    config: GoldenToolkit.configuration.copyWith(enableRealShadows: true),
  );
}
