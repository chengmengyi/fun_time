import 'package:fun_base/util/tba_point/base_point.dart';

class SessionPoint extends BasePoint{
  Future<Map<String,dynamic>> getSessionMap()async{
    var map = await getBaseMap();
    map["fiat"]={};
    return map;
  }
}