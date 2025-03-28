import 'dart:io';

import 'package:flutter_tba_info/flutter_tba_info.dart';
import 'package:fun_base/util/tba_point/custom_point.dart';
import 'package:fun_base/util/tba_point/tab_point_hep.dart';

class CloakType{
  var _tryNum=0;

  requestClock(Function(bool) call)async{
    if(_tryNum==0){
      TbaPointHep.instance.pointEvent(CustomId.cloak_req);
    }
    var bundleId = await FlutterTbaInfo.instance.getBundleId();
    var os = Platform.isAndroid?"cunard":"circe";
    var appVersion = await FlutterTbaInfo.instance.getAppVersion();
    var distinctId = await FlutterTbaInfo.instance.getDistinctId();
    var clientTs = DateTime.now().millisecondsSinceEpoch;
    var deviceModel = await FlutterTbaInfo.instance.getDeviceModel();
    var osVersion = await FlutterTbaInfo.instance.getOsVersion();
    var idfv = await FlutterTbaInfo.instance.getIdfv();
    var gaid = await FlutterTbaInfo.instance.getGaid();
    var androidId = await FlutterTbaInfo.instance.getAndroidId();
    var idfa = await FlutterTbaInfo.instance.getIdfa();
    var map={
      "emblem":bundleId,
      "pergamon":os,
      "stabile":appVersion,
      "contrast":distinctId,
      "chandler":clientTs,
      "macho":deviceModel,
      "hepatica":osVersion,
      "corpsman":idfv,
      "sheet":gaid,
      "question":androidId,
      "hull":idfa,
    };
    var result = await TbaPointHep.instance.requestCloak(map);
    if(result.isEmpty){
      _tryNum++;
      Future.delayed(const Duration(milliseconds: 2000),(){
        requestClock(call);
      });
    }else{
      var white = result=="ferocity";
      TbaPointHep.instance.pointEvent(CustomId.cloak_suc,params: {"cloak_user":white?1:0});
      call.call(white);
    }
  }
}