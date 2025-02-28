
import 'fun_base_platform_interface.dart';

class FunBase {
  Future<String?> getPlatformVersion() {
    return FunBasePlatform.instance.getPlatformVersion();
  }
}
