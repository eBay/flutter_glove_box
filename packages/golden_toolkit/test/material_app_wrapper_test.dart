import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

void main() {
  group('materialAppWrapper', () {
    testWidgets('navigatorObserver should be passed into material app',
        (tester) async {
      final observer = _SampleNavigatorObserver();
      await tester.pumpWidgetBuilder(
        Builder(
          builder: (context) => MaterialButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute<void>(builder: (_) => Container()));
            },
          ),
        ),
        wrapper: materialAppWrapper(navigatorObserver: observer),
      );
      expect(observer.wasPushed, isTrue);
    });

    group('allow specification of TargetPlatform', () {
      testGoldens('Android asset should display correctly', (tester) async {
        await tester.pumpWidgetBuilder(
          Row(children: const [BackButtonIcon(), Text('Android')]),
          wrapper: materialAppWrapper(
            platform: TargetPlatform.android,
            theme: ThemeData.light(),
          ),
          surfaceSize: const Size(80, 40),
        );
        await screenMatchesGolden(tester, 'back_button_android');
      });

      testGoldens('iOS should display correctly', (tester) async {
        await tester.pumpWidgetBuilder(
          Row(children: const [BackButtonIcon(), Text('iOS')]),
          surfaceSize: const Size(80, 40),
          wrapper: materialAppWrapper(
            platform: TargetPlatform.iOS,
            theme: ThemeData.light(),
          ),
        );
        await screenMatchesGolden(tester, 'back_button_ios');
      });
    });
  });
}

class _SampleNavigatorObserver extends NavigatorObserver {
  bool wasPushed = false;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    wasPushed = true;
  }
}
