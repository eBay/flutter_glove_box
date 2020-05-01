//coverage:ignore
import 'package:flutter/material.dart';

import 'package:apptentive_flutter/apptentive_flutter.dart';

void main() => runApp(MyApp());

///
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Apptentive Debugging')),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: const Text('Trigger apptentive test event'),
                onTap: () => ApptentiveFlutter().event('test_app'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
