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
      testWidgets('Android asset should display correctly', (tester) async {
        await tester.pumpWidgetBuilder(
          Builder(
            builder: (context) => Text(
              Theme.of(context).platform == TargetPlatform.iOS
                  ? 'iOS'
                  : 'Android',
            ),
          ),
          wrapper: materialAppWrapper(
            platform: TargetPlatform.android,
            theme: ThemeData.light(),
          ),
          surfaceSize: const Size(80, 40),
        );
        expect(find.text('Android'), findsOneWidget);
      });

      testWidgets('iOS should display correctly', (tester) async {
        await tester.pumpWidgetBuilder(
          Builder(
            builder: (context) => Text(
              Theme.of(context).platform == TargetPlatform.iOS
                  ? 'iOS'
                  : 'Android',
            ),
          ),
          surfaceSize: const Size(80, 40),
          wrapper: materialAppWrapper(
            platform: TargetPlatform.iOS,
            theme: ThemeData.light(),
          ),
        );
        expect(find.text('iOS'), findsOneWidget);
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
