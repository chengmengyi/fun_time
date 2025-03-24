import 'dart:io';

import 'package:flutter_tba_info/flutter_tba_info.dart';

class BasePoint{

  Future<Map<String,dynamic>> getBaseMap()async{
    var systemLanguage = await FlutterTbaInfo.instance.getSystemLanguage();
    var logId = await FlutterTbaInfo.instance.getLogId();
    var androidId = await FlutterTbaInfo.instance.getAndroidId();
    var bundleId = await FlutterTbaInfo.instance.getBundleId();
    var manufacturer = await FlutterTbaInfo.instance.getManufacturer();
    var operator = await FlutterTbaInfo.instance.getOperator();
    var gaid = await FlutterTbaInfo.instance.getGaid();
    var os = Platform.isAndroid?"cunard":"circe";
    var idfv = await FlutterTbaInfo.instance.getIdfv();
    var networkType = await FlutterTbaInfo.instance.getNetworkType();
    var osCountry = await FlutterTbaInfo.instance.getOsCountry();
    var deviceModel = await FlutterTbaInfo.instance.getDeviceModel();
    var distinctId = await FlutterTbaInfo.instance.getDistinctId();
    var appVersion = await FlutterTbaInfo.instance.getAppVersion();
    var clientTs = DateTime.now().millisecondsSinceEpoch;
    var osVersion = await FlutterTbaInfo.instance.getOsVersion();
    var idfa = await FlutterTbaInfo.instance.getIdfa();
    var brand = await FlutterTbaInfo.instance.getBrand();
    return {
      "soya":{
        "boone":systemLanguage,
        "quirky":logId,
        "question":androidId,
        "emblem":bundleId,
        "posner":manufacturer,
        "schultz":operator,
        "sheet":gaid,
        "pergamon":os,
        "corpsman":idfv,
        "oldster":networkType,
        "anyhow":osCountry,
        "macho":deviceModel,
        "contrast":distinctId,
        "stabile":appVersion,
        "chandler":clientTs,
        "hepatica":osVersion,
        "hull":idfa,
        "manfred":brand,
      }
    };
  }
}