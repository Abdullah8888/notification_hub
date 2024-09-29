import 'dart:io';

import 'package:flutter/foundation.dart';

@immutable
final class CodeEnvironment {
  static bool get isRunningUnitTests {
    final check = Platform.environment.containsKey('FLUTTER_TEST');
    debugPrint('yeah, it is $check');
    return check;
  }
}
