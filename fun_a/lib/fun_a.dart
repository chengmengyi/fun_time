
import 'fun_a_platform_interface.dart';

class Fun_a {
  Future<String?> getPlatformVersion() {
    return Fun_aPlatform.instance.getPlatformVersion();
  }
}
