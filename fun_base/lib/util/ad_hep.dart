import 'dart:convert';
import 'package:flutter_ad_ios_plugins/data/ad_info_data.dart';
import 'package:flutter_ad_ios_plugins/hep/ad_type.dart';
import 'package:flutter_ad_ios_plugins/hep/ios_ad_callback.dart';
import 'package:fun_base/util/util.dart';

class AdHep{
  static final AdHep _instance = AdHep();
  static AdHep get instance=>_instance;

  initAdData(String maxKey,String localAdStr){
    try{
      var json = jsonDecode(localAdStr);
      var data = ConfigAdData(
        maxShowNum: json["rushgkel"],
        maxClickNum: json["juehnbra"],
        oneRewardList: _getAdList(json["sqftm_arv_one"]),
        oneInterList: [],
        twoRewardList: [],
        twoInterList: [],
      );
      FlutterIosAdHep.instance.initMax(maxKey: maxKey, data: data);
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
    required Function() closeAd,
  }){
    var resultData = FlutterIosAdHep.instance.getCacheResultData(adType);
    if(null==resultData){
      showToast("Ad loading failed, please try again later");
      return;
    }
    FlutterIosAdHep.instance.showAd(
      adType: adType,
      iosAdCallback: IosAdCallback(
        showSuccess: (ad,info){

        },
        showFail: (ad){
          FlutterIosAdHep.instance.loadAd(adType);
        },
        closeAd: (){
          closeAd.call();
        },
        onAdRevenuePaidCallback: (ad,info){

        },
      ),
    );
  }
}