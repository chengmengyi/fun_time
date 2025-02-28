import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'fun_base_platform_interface.dart';

/// An implementation of [FunBasePlatform] that uses method channels.
class MethodChannelFunBase extends FunBasePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('fun_base');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
