import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'fun_base_method_channel.dart';

abstract class FunBasePlatform extends PlatformInterface {
  /// Constructs a FunBasePlatform.
  FunBasePlatform() : super(token: _token);

  static final Object _token = Object();

  static FunBasePlatform _instance = MethodChannelFunBase();

  /// The default instance of [FunBasePlatform] to use.
  ///
  /// Defaults to [MethodChannelFunBase].
  static FunBasePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FunBasePlatform] when
  /// they register themselves.
  static set instance(FunBasePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
