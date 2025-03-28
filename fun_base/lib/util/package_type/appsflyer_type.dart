import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:flutter_ad_ios_plugins/data/storage_data.dart';
import 'package:flutter_ad_ios_plugins/hep/hep.dart';
import 'package:flutter_tba_info/flutter_tba_info.dart';
import 'package:fun_base/util/tba_point/ad_point.dart';
import 'package:fun_base/util/tba_point/custom_point.dart';
import 'package:fun_base/util/tba_point/tab_point_hep.dart';
import 'package:applovin_max/applovin_max.dart';

StorageData<bool> firstGetAf=StorageData<bool>(key: "firstGetAf", defaultValue: true);

class AppsflyerType{
  AppsflyerSdk? _appsflyerSdk;

  init(Function() call)async{
    _appsflyerSdk=AppsflyerSdk(AppsFlyerOptions(
      afDevKey: "AqRnMjgPdYZBeZTLwoyAdT",
      appId: "6742642528",
      timeToWaitForATTUserAuthorization: 8,
      disableAdvertisingIdentifier: false,
      disableCollectASA: false,
      manualStart: true,
    ));
    await _appsflyerSdk?.initSdk(registerConversionDataCallback: true);
    var s = await FlutterTbaInfo.instance.getDistinctId();
    _appsflyerSdk?.setCustomerUserId(s);
    _appsflyerSdk?.onInstallConversionData((res){
      "package type---> request af result-->$res".log();
      try{
        if(res["status"]=="success"){
          var status = res["payload"]["af_status"].toString();
          var isB = status!="Organic";
          TbaPointHep.instance.pointEvent(CustomId.af_suc,params: {"af_user":isB?1:0});
          if(isB){
            if(firstGetAf.getData()){
              TbaPointHep.instance.pointEvent(CustomId.organic_to_buy);
              firstGetAf.saveData(false);
            }
            call.call();
            // if(appsflyerResult.get().isEmpty){
            //   PointUtils.instance.pointEvent(AppPointId.organic_to_buy);
            //   appsflyerResult.save(status);
            // }
            // CheckUserUtils.instance.delayCheckResult();
          }
        }
      }catch(e){

      }
    });
    TbaPointHep.instance.pointEvent(CustomId.af_req);
    _startAf();
  }

  _startAf(){
    "package type---> start request af".log();
    _appsflyerSdk?.startSDK(
        onSuccess: (){
          "package type---> initAppsflyer success".log();
        },
        onError: (code,msg){
          "package type---> initAppsflyer fail--->$code---->$msg".log();
          Future.delayed(const Duration(milliseconds: 1000),(){
            _startAf();
          });
        }
    );
  }

  uploadAdRevenue(MaxAd? ad,String adId,AdPosId pointId){
    _appsflyerSdk?.logAdRevenue(
        AdRevenueData(
            monetizationNetwork: ad?.networkName??"",
            mediationNetwork: AFMediationNetwork.applovinMax.value,
            currencyIso4217Code: "USD",
            revenue: ad?.revenue??0,
            additionalParameters: {
              "adRevenueUnit": adId,
              "adRevenuePlacement": pointId.name,
            }
        )
    );
  }
}