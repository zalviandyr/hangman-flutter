import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;

enum OS { web, android, ios }

class Responsive {
  static OS getPlatform() {
    OS os = OS.web;

    if (!kIsWeb) {
      if (Platform.isAndroid) os = OS.android;
      if (Platform.isIOS) os = OS.ios;
    }

    return os;
  }
}
