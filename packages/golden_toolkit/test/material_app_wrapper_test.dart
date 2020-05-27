import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

void main() {
  group('materialAppWrapper', () {
    testWidgets('navigatorObserver should be passed into material app', (tester) async {
      final observer = _SampleNavigatorObserver();
      await tester.pumpWidgetBuilder(
        Builder(
          builder: (context) => MaterialButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => Container()));
            },
          ),
        ),
        wrapper: materialAppWrapper(navigatorObserver: observer),
      );
      expect(observer.wasPushed, isTrue);
    });
  });
}

class _SampleNavigatorObserver extends NavigatorObserver {
  bool wasPushed = false;

  @override
  void didPush(Route<dynamic> route, Route<dynamic> previousRoute) {
    wasPushed = true;
  }
}
