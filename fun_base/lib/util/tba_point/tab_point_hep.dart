import 'package:dio/dio.dart';
import 'package:flutter_ad_ios_plugins/data/storage_data.dart';
import 'package:flutter_ad_ios_plugins/hep/hep.dart';
import 'package:flutter_tba_info/flutter_tba_info.dart';
import 'package:fun_base/util/base_local_data.dart';
import 'package:fun_base/util/sql/base_sql_hep.dart';
import 'package:fun_base/util/tba_point/ad_point.dart';
import 'package:fun_base/util/tba_point/custom_point.dart';
import 'package:fun_base/util/tba_point/install_point.dart';
import 'package:fun_base/util/tba_point/session_point.dart';
import 'package:flutter_ad_ios_plugins/data/ad_info_data.dart';
import 'package:applovin_max/applovin_max.dart';


StorageData<bool> installEventStorage=StorageData<bool>(key: "installEvent", defaultValue: false);

class TbaPointHep{
  factory TbaPointHep() => _getInstance();
  static TbaPointHep get instance => _getInstance();
  static TbaPointHep? _instance;
  static TbaPointHep _getInstance() {
    _instance ??= TbaPointHep._internal();
    return _instance!;
  }

  Dio? _dio;

  TbaPointHep._internal(){
    if (_dio == null) {
      BaseOptions options = BaseOptions(
        responseType: ResponseType.json,
        receiveDataWhenStatusError: false,
        connectTimeout: const Duration(milliseconds: 30000),
        receiveTimeout: const Duration(milliseconds: 30000),
      );
      _dio = Dio(options);
    }
  }

  installEvent({int tryNum=5})async{
    if(installEventStorage.getData()){
      return;
    }
    var map = await InstallPoint().getInstallMap();
    "tba---->install--->map-->$map".log();
    var result = await _requestPost(dataMap: map);
    "tba---->install--->result-->$result--->map-->$map".log();
    if(result){
      installEventStorage.saveData(true);
    }else{
      if(tryNum>0){
        Future.delayed(const Duration(milliseconds: 2000),(){
          installEvent(tryNum: tryNum-1);
        });
      }else{
        BaseSqlHep.instance.insertTbaPointJson(map);
      }
    }
  }

  sessionEvent({int tryNum=5})async{
    var map = await SessionPoint().getSessionMap();
    "tba---->session--->map-->$map".log();
    var result = await _requestPost(dataMap: map);
    "tba---->session--->result-->$result--->map-->$map".log();
    if(!result){
      if(tryNum>0){
        Future.delayed(const Duration(milliseconds: 2000),(){
          sessionEvent(tryNum: tryNum-1);
        });
      }else{
        BaseSqlHep.instance.insertTbaPointJson(map);
      }
    }
  }

  adEvent(MaxAd? maxAd, AdInfoData? adInfoData, AdPosId adPosId,{int tryNum=5})async{
    var map = await AdPoint().getAdMap(maxAd, adInfoData, adPosId);
    "tba---->ad--->map-->$map".log();
    var result = await _requestPost(dataMap: map);
    "tba---->ad--->result-->$result--->map-->$map".log();
    if(!result){
      if(tryNum>0){
        Future.delayed(const Duration(milliseconds: 2000),(){
          adEvent(maxAd, adInfoData, adPosId,tryNum: tryNum-1);
        });
      }else{
        BaseSqlHep.instance.insertTbaPointJson(map);
      }
    }
  }

  pointEvent(CustomId customId,{Map<String, dynamic>? params,int tryNum=5})async{
    var map = await CustomPoint().getCustomMap(customId, params);
    "tba---->point--->map-->$map".log();
    var result = await _requestPost(dataMap: map);
    "tba---->point--->result-->$result--->map-->$map".log();
    if(!result){
      if(tryNum>0){
        Future.delayed(const Duration(milliseconds: 2000),(){
          pointEvent(customId,params: params,tryNum: tryNum-1);
        });
      }else{
        BaseSqlHep.instance.insertTbaPointJson(map);
      }
    }
  }

  sqlEvent()async{
    var list = await BaseSqlHep.instance.queryTbaPoint();
    if(list.isEmpty){
      return;
    }
    "tba---->sql--->map-->$list".log();
    var result = await _requestListPost(list: list);
    "tba---->sql--->result-->$result--->map-->$list".log();
    if(result){
      BaseSqlHep.instance.deleteTbaData();
    }
  }

  Future<bool> _requestListPost({
    required List<Map<String, dynamic>> list,
  })async{
    var url = await _url();
    var header = await _headerMap();
    header["Content-Encoding"]="gzip";
    _dio?.options.headers = header;
    _dio?.options.contentType="application/json";
    try{
      var response = await _dio?.request<String>(
          url,
          data: list,
          options: Options(method: "post")
      );
      if(response?.statusCode==200){
        return true;
      }else{
        return false;
      }
    }catch(e){
      return false;
    }
  }


  Future<bool> _requestPost({
    required Map<String, dynamic> dataMap,
  })async{
    var url = await _url();
    _dio?.options.headers = await _headerMap();
    try{
      var response = await _dio?.request<String>(
          url,
          data: dataMap,
          options: Options(method: "post")
      );
      if(response?.statusCode==200){
        return true;
      }else{
        return false;
      }
    }catch(e){
      return false;
    }
  }

  Future<Map<String,dynamic>> _headerMap() async {
    var appVersion = await FlutterTbaInfo.instance.getAppVersion();
    var idfv = await FlutterTbaInfo.instance.getIdfv();
    var idfa = await FlutterTbaInfo.instance.getIdfa();
    return {
      "stabile":appVersion,
      "corpsman":idfv,
      "hull":idfa,
    };
  }

  Future<String> _url()async{
    var clientTs = DateTime.now().millisecondsSinceEpoch;
    var manufacturer = await FlutterTbaInfo.instance.getManufacturer();
    return "$tbaUrl?chandler=$clientTs&posner=$manufacturer";
  }
}