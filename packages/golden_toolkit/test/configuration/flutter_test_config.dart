/// ***************************************************
/// Copyright 2019-2020 eBay Inc.
///
/// Use of this source code is governed by a BSD-style
/// license that can be found in the LICENSE file or at
/// https://opensource.org/licenses/BSD-3-Clause
/// ***************************************************
///

import 'dart:async';
import 'package:golden_toolkit/golden_toolkit.dart';

Future<void> main(FutureOr<void> Function() testMain) async {
  // this intentionally shadows the more global setting so that we can validate how things work
  // without using GoldenToolkit.runWithConfiguration()
  await loadAppFonts();
  await testMain();
}
