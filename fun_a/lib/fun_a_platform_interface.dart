import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'fun_a_method_channel.dart';

abstract class Fun_aPlatform extends PlatformInterface {
  /// Constructs a Fun_aPlatform.
  Fun_aPlatform() : super(token: _token);

  static final Object _token = Object();

  static Fun_aPlatform _instance = MethodChannelFun_a();

  /// The default instance of [Fun_aPlatform] to use.
  ///
  /// Defaults to [MethodChannelFun_a].
  static Fun_aPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [Fun_aPlatform] when
  /// they register themselves.
  static set instance(Fun_aPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
