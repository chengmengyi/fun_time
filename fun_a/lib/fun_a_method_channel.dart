import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'fun_a_platform_interface.dart';

/// An implementation of [Fun_aPlatform] that uses method channels.
class MethodChannelFun_a extends Fun_aPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('fun_a');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
