import 'package:flutter/material.dart';

class InvalidateWidgetTreeWhenSizeChanges extends StatelessWidget {
  const InvalidateWidgetTreeWhenSizeChanges({Key key, this.child}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      return Container(
        key: ValueKey(constraint.toString()),
        child: child,
      );
    });
  }
}

class FutureWidgetTester extends StatefulWidget {
  const FutureWidgetTester({Key key, this.child, this.duration = const Duration(milliseconds: 100)}) : super(key: key);
  final Widget child;
  final Duration duration;
  @override
  _FutureWidgetTesterState createState() => _FutureWidgetTesterState();
}

class _FutureWidgetTesterState extends State<FutureWidgetTester> {
  Future<bool> _myFuture;
  @override
  void initState() {
    super.initState();
    _myFuture = Future.delayed(widget.duration, () => true);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: _myFuture,
        builder: (context, value) {
          if (value.hasData) {
            return widget.child;
          }
          return const Placeholder();
        });
  }
}
