import 'package:flutter/material.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

class ImageWidget extends StatelessWidget {
  const ImageWidget({
    Key? key,
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
          image: AssetImage('images/earth_image.jpg',
              package: 'sample_dependency'),
        ),
      ),
    );
  }
}

GoldenToolkitConfiguration get legacyConfiguration =>
    GoldenToolkit.configuration.copyWith(primeAssets: legacyPrimeAssets);

GoldenToolkitConfiguration get defaultConfiguration =>
    GoldenToolkit.configuration.copyWith(primeAssets: defaultPrimeAssets);

@immutable
class ListOfItemsWithOneImage extends StatelessWidget {
  const ListOfItemsWithOneImage({
    required this.itemSize,
    required this.indexThatContainsImage,
    required this.cacheExtent,
  });

  final Size itemSize;
  final int indexThatContainsImage;
  final double cacheExtent;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      child: ListView.builder(
        itemBuilder: (context, index) => Center(
          child: Row(
            children: [
              Container(
                width: itemSize.width,
                height: itemSize.height,
                color: Colors.lightBlue,
                child: (index == indexThatContainsImage)
                    ? const ImageWidget()
                    : null,
              ),
            ],
          ),
        ),
        cacheExtent: cacheExtent,
      ),
    );
  }
}
