//coverage:ignore
import 'package:flutter/material.dart';

import 'package:apptentive_flutter/apptentive_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  void buttonPressed() {
    ApptentiveFlutter().event('test_app');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Row(
          children: [
            FlatButton(
              onPressed: buttonPressed,
              child: const Text('display apptentive'),
            ),
          ],
        ),
      ),
    );
  }
}
