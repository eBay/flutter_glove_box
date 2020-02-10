import 'dart:convert';

/// ***************************************************
/// Copyright 2019-2020 eBay Inc.
///
/// Use of this source code is governed by a BSD-style
/// license that can be found in the LICENSE file or at
/// https://opensource.org/licenses/BSD-3-Clause
/// ***************************************************
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

///By default, flutter test only uses a single "test" font called Ahem.
///
///This font is designed to show black spaces for every character and icon. This obviously makes goldens much less valuable.
///
///To make the goldens more useful, we have a utility to dynamically inject additional fonts into the flutter test engine so that we can get more human viewable output.
/// Path to your folder with fonts [from] in required
Future<void> loadAppFonts({Iterable<String> sourceDirectories}) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  final fontManifest = await rootBundle.loadStructuredData<List<dynamic>>(
    'FontManifest.json',
    (string) async => json.decode(string),
  );

  for (final Map<String, dynamic> font in fontManifest) {
    final fontLoader = FontLoader(font['family']);
    for (final Map<String, dynamic> fontType in font['fonts']) {
      fontLoader.addFont(rootBundle.load(fontType['asset']));
    }
    await fontLoader.load();
  }
}
