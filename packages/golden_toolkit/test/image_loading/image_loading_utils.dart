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

@immutable
class ListOfImages extends StatelessWidget {
  const ListOfImages({@required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      child: ListView.builder(
        primary: true,
        addAutomaticKeepAlives: false,
        addRepaintBoundaries: true,
        itemCount: 20,
        itemBuilder: (context, index) => Center(
          child: Row(
            children: [
              Text(index.toString()),
              const SizedBox(width: 8),
              Container(
                width: height,
                height: height,
                color: Colors.lightBlue,
                child: (index < 10) ? null : const ImageWidget(),
              ),
            ],
          ),
        ),
        cacheExtent: 2000,
      ),
    );
  }
}
