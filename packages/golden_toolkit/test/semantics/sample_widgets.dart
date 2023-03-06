import 'package:flutter/widgets.dart';

class SampleListWidget extends StatelessWidget {
  const SampleListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const itemCount = 20;

    return ListView.builder(
      itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.all(16), child: Text('Item $index')),
      itemCount: itemCount,
    );
  }
}
