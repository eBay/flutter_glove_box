import 'package:flutter/material.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

void main() {
  testGoldens('Device pixel ratio', (tester) async {
    await tester.pumpWidgetBuilder(
      const Center(
        child: Text('Sample text'),
      ),
      devicePixelRatio: 3.0,
      surfaceSize: const Size(100, 100),
    );

    await screenMatchesGolden(tester, 'device_pixel_ratio', autoHeight: true);
  });
}
