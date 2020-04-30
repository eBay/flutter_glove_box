import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ApptentiveFlutter {
  static const MethodChannel _channel = MethodChannel('apptentive_flutter');

  Future<void> event(String event) async {
    await _channel.invokeMethod<void>('engageEvent', event);
  }
}

class ApptentiveDebugTools extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}
