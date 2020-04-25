/// ***************************************************
/// Copyright 2019-2020 eBay Inc.
///
/// Use of this source code is governed by a BSD-style
/// license that can be found in the LICENSE file or at
/// https://opensource.org/licenses/BSD-3-Clause
/// ***************************************************
///

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:golden_toolkit/src/font_loader.dart';

Future<void> main() async {
  group('Font loading integration test', () {
    testGoldens('Roboto fonts should work', (tester) async {
      final golden = GoldenBuilder.column()
        ..addScenario('Material Fonts should work',
            const Text('This is material text in "Roboto"'))
        ..addScenario(
            'Material Icons should work', const Icon(Icons.phone_in_talk))
        ..addScenario(
            'Fonts from packages should work',
            const Text('This is a custom font',
                style: TextStyle(
                    fontFamily: 'OpenSans', package: 'sample_dependency')))
        ..addScenario(
            'Different Font weights are not well supported (w900)',
            const Text('This should be weight 900',
                style: TextStyle(
                    fontFamily: 'Roboto', fontWeight: FontWeight.w900)))
        ..addScenario(
            'Different Font weights are not well supported (w100)',
            const Text('This should be weight 100)',
                style: TextStyle(
                    fontFamily: 'Roboto', fontWeight: FontWeight.w100)))
        ..addScenario(
            'Italics are supported',
            const Text('This should be italic',
                style: TextStyle(
                    fontFamily: 'Roboto', fontStyle: FontStyle.italic)))
        ..addScenario('Unknown fonts render in Ahem (Foo.ttf)',
            const Text('unknown font', style: TextStyle(fontFamily: 'foo')));
      await tester.pumpWidgetBuilder(golden.build());
      await screenMatchesGolden(tester, 'material_fonts',
          skip: !Platform.isMacOS);
    });
  });

  group('Font Family Derivation', () {
    test('de-namespace Material/Cupertino font overrides', () {
      expect(
        derivedFontFamily(_font('Roboto', ['packages/foo/fonts/roboto.ttf'])),
        equals('Roboto'),
      );
      expect(
        derivedFontFamily(
            _font('packages/foo/Roboto', ['packages/foo/fonts/roboto.ttf'])),
        equals('Roboto'),
      );
      expect(
        derivedFontFamily(
            _font('.SF UI Display', ['packages/foo/fonts/sf.ttf'])),
        equals('.SF UI Display'),
      );
      expect(
        derivedFontFamily(_font(
            'packages/foo/.SF UI Display', ['packages/foo/fonts/sf.ttf'])),
        equals('.SF UI Display'),
      );
      expect(
        derivedFontFamily(_font('.SF UI Text', ['packages/foo/fonts/sf.ttf'])),
        equals('.SF UI Text'),
      );
      expect(
        derivedFontFamily(
            _font('packages/foo/.SF UI Text', ['packages/foo/fonts/sf.ttf'])),
        equals('.SF UI Text'),
      );
      expect(
        derivedFontFamily(
            _font('packages/foo/.SF Pro Text', ['packages/foo/fonts/sf.ttf'])),
        equals('.SF Pro Text'),
      );
      expect(
        derivedFontFamily(_font(
            'packages/foo/.SF Pro Display', ['packages/foo/fonts/sf.ttf'])),
        equals('.SF Pro Display'),
      );
    });

    test('leave packaged font families unaltered', () {
      expect(
        derivedFontFamily(
            _font('packages/foo/bar', ['packages/foo/fonts/bar.ttf'])),
        equals('packages/foo/bar'),
      );
    });

    test('leave unpackaged fonts unaltered', () {
      expect(
        derivedFontFamily(_font('bar', ['bar.ttf'])),
        equals('bar'),
      );
    });

    /// Imagine you have Package A that depends on Package B.
    /// Package B includes a font family "bar"
    /// In code, package B will need to refer to the font as /packages/B/bar
    ///
    /// in Package A unittest's FontManifest.json , the font family will read as "/packages/A/bar"
    ///
    /// However, in Package B unittest's FontManifest.json, the font family is recorded as simply "bar"
    ///
    /// This will cause the font to fail to be found in Package B's tests.
    ///
    /// Thankfully, the assets are appropriately namespaced, so we can copy that namespace identifier
    /// and modify the fontFamily name before loading into the FontLoader for simulating in our tests
    test('adjust font family to be namespaced if assets are packaged', () {
      expect(
        derivedFontFamily(_font('bar', ['packages/foo/fonts/bar.ttf'])),
        equals('packages/foo/bar'),
      );
    });
  });
}

Map<String, dynamic> _font(String family, Iterable<String> fontAssets) {
  return <String, dynamic>{
    'family': family,
    'fonts': fontAssets.map((asset) => <String, dynamic>{
          'asset': asset,
          'foo': 'bar',
        }),
    'blah': 'bar',
  };
}
