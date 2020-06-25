import 'package:flutter/material.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

class ImageWidget extends StatelessWidget {
  const ImageWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset('images/earth_image.jpg', package: 'sample_dependency');
  }
}

@immutable
class BoxDecorationWithImage extends StatelessWidget {
  const BoxDecorationWithImage();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/earth_image.jpg', package: 'sample_dependency'),
        ),
      ),
    );
  }
}

GoldenToolkitConfiguration get legacyConfiguration =>
    GoldenToolkit.configuration.copyWith(primeAssets: legacyPrimeAssets);

GoldenToolkitConfiguration get defaultConfiguration =>
    GoldenToolkit.configuration.copyWith(primeAssets: defaultPrimeAssets);
