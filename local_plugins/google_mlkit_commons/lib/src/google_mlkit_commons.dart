import 'dart:async';

import 'package:flutter/services.dart';

class GoogleMlKitCommons {
  static const MethodChannel _channel = MethodChannel('google_mlkit_commons');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
