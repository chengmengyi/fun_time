import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_ad_ios_plugins/data/ad_info_data.dart';
import 'package:flutter_ad_ios_plugins/hep/ad_type.dart';
import 'package:flutter_ad_ios_plugins/hep/ios_ad_callback.dart';
import 'package:fun_base/util/base_local_data.dart';
import 'package:fun_base/util/firebase_hep.dart';
import 'package:fun_base/util/package_type/package_type_hep.dart';
import 'package:fun_base/util/tba_point/ad_point.dart';
import 'package:fun_base/util/tba_point/custom_point.dart';
import 'package:fun_base/util/tba_point/tab_point_hep.dart';
import 'package:fun_base/util/util.dart';

StorageData<int> lastAdLevel=StorageData<int>(key: "lastAdLevelB", defaultValue: 0);
StorageData<int> watchAdNum=StorageData<int>(key: "watchAdNumB", defaultValue: 0);


class AdHep{
  static final AdHep _instance = AdHep();
  static AdHep get instance=>_instance;
  int _lastShowTime=0;

  initAdData(){
    try{
      var json = _getConfigData();
      var data = ConfigAdData(
        maxShowNum: json["rushgkel"],
        maxClickNum: json["juehnbra"],
        oneRewardList: _getAdList(json["sqftm_rv_one"]),
        oneInterList: _getAdList(json["sqftm_int_one"]),
        twoRewardList: [],
        twoInterList: [],
      );
      FlutterIosAdHep.instance.initMax(maxKey: maxKey.base64(), data: data);
    }catch(e){
    }
  }

  List<AdInfoData> _getAdList(List list){
    List<AdInfoData> resultList=[];
    for (var value in list) {
      resultList.add(AdInfoData(adId: value["pqurnkgo"], adPlat: value["vjsilfos"], adType: value["tuskentl"]=="reward"?AdType.reward:AdType.interstitial, expireTime: value["meryslaf"], sort: value["ojkelgdg"]));
    }
    return resultList;
  }

  showAd({
    required AdType adType,
    required AdPosId adPosId,
    required bool showAd,
    required Function() closeAd,
  }){
    if(_checkIsDoubleClick()){
      return;
    }
    if(!showAd){
      closeAd.call();
      return;
    }
    TbaPointHep.instance.pointEvent(CustomId.sqftm_ad_chance,params: {"ad_pos_id":adPosId.name});
    var resultData = FlutterIosAdHep.instance.getCacheResultData(adType);
    if(null==resultData){
      FlutterIosAdHep.instance.loadAd(adType);
      if(adType==AdType.reward){
        showToast("Ad loading failed, please try again later");
      }
      if(adType==AdType.interstitial){
        closeAd.call();
      }
      return;
    }
    FlutterIosAdHep.instance.showAd(
      adType: adType,
      iosAdCallback: IosAdCallback(
        showSuccess: (ad,info){
          _uploadWatchNumToTba();
          TbaPointHep.instance.adEvent(ad, info, adPosId);
          TbaPointHep.instance.pointEvent(CustomId.sqftm_ad_impression,params: {"ad_pos_id":adPosId.name});
        },
        showFail: (ad){
          TbaPointHep.instance.pointEvent(CustomId.sqftm_ad_impression_fail,params: {"ad_pos_id":adPosId.name});
          FlutterIosAdHep.instance.loadAd(adType);
        },
        closeAd: (){
          closeAd.call();
        },
        onAdRevenuePaidCallback: (ad,info){
          PackageTypeHep.instance.uploadAfRevenue(ad, info?.adId??"", adPosId);
        },
      ),
    );
  }

  showTaskAd({
    required AdType adType,
    required Function() closeAd,
  }){
    if(_checkIsDoubleClick()){
      return;
    }
    TbaPointHep.instance.pointEvent(CustomId.sqftm_ad_chance,params: {"ad_pos_id":AdPosId.sqftm_skipwait_rv.name});
    var resultData = FlutterIosAdHep.instance.getCacheResultData(adType);
    if(null==resultData){
      FlutterIosAdHep.instance.loadAd(adType);
      showToast("Ad loading failed, please try again later");
      return;
    }
    FlutterIosAdHep.instance.showAd(
      adType: adType,
      iosAdCallback: IosAdCallback(
        showSuccess: (ad,info){
          _uploadWatchNumToTba();
          TbaPointHep.instance.adEvent(ad, info, AdPosId.sqftm_skipwait_rv);
          TbaPointHep.instance.pointEvent(CustomId.sqftm_ad_impression,params: {"ad_pos_id":AdPosId.sqftm_skipwait_rv.name});
        },
        showFail: (ad){
          FlutterIosAdHep.instance.loadAd(adType);
          showToast("Ad display failed, please try again later");
        },
        closeAd: (){
          closeAd.call();
        },
        onAdRevenuePaidCallback: (ad,info){
          PackageTypeHep.instance.uploadAfRevenue(ad, info?.adId??"", AdPosId.sqftm_skipwait_rv);
        },
      ),
    );
  }

  showOpenAd({required Function() closeAd,}){
    TbaPointHep.instance.pointEvent(CustomId.sqftm_ad_chance,params: {"ad_pos_id":AdPosId.sqftm_launch.name});
    var resultData = FlutterIosAdHep.instance.getCacheResultData(AdType.interstitial);
    if(null==resultData){
      FlutterIosAdHep.instance.loadAd(AdType.interstitial);
      closeAd.call();
      return;
    }
    FlutterIosAdHep.instance.showAd(
      adType: AdType.interstitial,
      iosAdCallback: IosAdCallback(
        showSuccess: (ad,info){
          _uploadWatchNumToTba();
          TbaPointHep.instance.adEvent(ad, info, AdPosId.sqftm_launch);
          TbaPointHep.instance.pointEvent(CustomId.sqftm_ad_impression,params: {"ad_pos_id":AdPosId.sqftm_launch.name});
        },
        showFail: (ad){
          TbaPointHep.instance.pointEvent(CustomId.sqftm_ad_impression_fail,params: {"ad_pos_id":AdPosId.sqftm_launch.name});
          FlutterIosAdHep.instance.loadAd(AdType.interstitial);
          closeAd.call();
        },
        closeAd: (){
          closeAd.call();
        },
        onAdRevenuePaidCallback: (ad,info){
          PackageTypeHep.instance.uploadAfRevenue(ad, info?.adId??"", AdPosId.sqftm_launch);
        },
      ),
    );
  }
  
  _uploadWatchNumToTba(){
    watchAdNum.saveData(watchAdNum.getData()+1);
    var adLevel = lastAdLevel.getData()+5;
    if(watchAdNum.getData()>=adLevel){
      TbaPointHep.instance.pointEvent(CustomId.cash_ad_detail,params: {"number":adLevel});
      lastAdLevel.saveData(adLevel);
    }
  }

  updateAdData(){
    try{
      var json = _getConfigData();
      var data = ConfigAdData(
        maxShowNum: json["rushgkel"],
        maxClickNum: json["juehnbra"],
        oneRewardList: _getAdList(json["sqftm_rv_one"]),
        oneInterList: _getAdList(json["sqftm_int_one"]),
        twoRewardList: [],
        twoInterList: [],
      );
      FlutterIosAdHep.instance.updateAdData(data);
    }catch(e){
    }
  }

  _getConfigData(){
    try{
      var data = adConfig.getData();
      if(data.isEmpty){
        return jsonDecode(localAdStr.base64());
      }
      return jsonDecode(data);
    }catch(e){
      return jsonDecode(localAdStr.base64());
    }
  }

  bool _checkIsDoubleClick(){
    var nowTime = DateTime.now().millisecondsSinceEpoch;
    if(nowTime-_lastShowTime>500){
      _lastShowTime=nowTime;
      return false;
    }
    return true;
  }
}