import 'dart:async';

import 'package:flutter/services.dart';

/// API for triggering apptentive events
class ApptentiveFlutter {
  static const MethodChannel _channel = MethodChannel('apptentive_flutter');

  ///Basic event that calls an engage event
  static Future<void> engage(String event) async {
    await _channel.invokeMethod<void>('engageEvent', event);
  }
}
