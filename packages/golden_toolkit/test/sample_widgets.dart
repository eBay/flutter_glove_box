import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WidgetWithShadows extends StatelessWidget {
  const WidgetWithShadows({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const borderRadius = BorderRadius.all(Radius.circular(10));
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.yellow,
          borderRadius: borderRadius,
          boxShadow: [
            BoxShadow(
              offset: const Offset(10, 10),
              blurRadius: 16,
              color: Colors.black.withOpacity(0.3),
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: borderRadius,
          child: Column(
            children: const [
              Padding(
                padding: EdgeInsets.all(3),
                child: Text('this is the content'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
