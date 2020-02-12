import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/src/test_asset_bundle.dart';

void main() {
  group('TestAssetBundle', () {
    /* chasing code coverage... we're at 99% coverage, and this slightly forked code is the last 1% */
    test('Should throw if asset not found', () {
      final bundle = TestAssetBundle();
      expectLater(() => bundle.loadString('nothing'),
          throwsA(isInstanceOf<FlutterError>()));
    });
  });
}
