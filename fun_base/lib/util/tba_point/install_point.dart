import 'package:flutter_tba_info/flutter_tba_info.dart';
import 'package:fun_base/util/tba_point/base_point.dart';

class InstallPoint extends BasePoint{

  Future<Map<String,dynamic>> getInstallMap()async{
    var map = await getBaseMap();
    var referrerMap = await FlutterTbaInfo.instance.getReferrerMap();
    map["griffith"]={
      "arent":referrerMap["build"],
      "allusive":referrerMap["referrer_url"],
      "corvette":referrerMap["install_version"],
      "venom":referrerMap["user_agent"],
      "poisson":"bead",
      "feverish":referrerMap["referrer_click_timestamp_seconds"],
      "frustum":referrerMap["install_begin_timestamp_seconds"],
      "thulium":referrerMap["referrer_click_timestamp_server_seconds"],
      "berate":referrerMap["install_begin_timestamp_server_seconds"],
      "psi":referrerMap["install_first_seconds"],
      "shiplap":referrerMap["last_update_seconds"],
      "eutectic":referrerMap["google_play_instant"],
    };
    return map;
  }
}