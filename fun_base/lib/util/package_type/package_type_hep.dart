import 'package:flutter/foundation.dart';
import 'package:flutter_ad_ios_plugins/data/storage_data.dart';
import 'package:flutter_ad_ios_plugins/hep/hep.dart';
import 'package:fun_base/routers/b_routers_name.dart';
import 'package:fun_base/routers/routers_utils.dart';
import 'package:fun_base/util/firebase_hep.dart';
import 'package:fun_base/util/package_type/appsflyer_type.dart';
import 'package:fun_base/util/package_type/cloak_type.dart';
import 'package:applovin_max/applovin_max.dart';
import 'package:fun_base/util/tba_point/ad_point.dart';

StorageData<bool> localPackageIsB=StorageData<bool>(key: "localPackageIsB", defaultValue: false);

class PackageTypeHep{
  static final PackageTypeHep _instance = PackageTypeHep();
  static PackageTypeHep get instance => _instance;

  var _clockWhite=false,_afB=false,aPackageShowed=false;
  Function()? cloakResultCall;
  AppsflyerType? _appsflyerType;

  initCheck()async{
    CloakType().requestClock((white){
      _clockWhite=white;
      cloakResultCall?.call();
      if(_clockWhite){
        _checkAutoToB();
      }
    });
    _appsflyerType=AppsflyerType();
    _appsflyerType?.init((){
      _afB=true;
      _checkAutoToB();
    });
  }

  bool checkPackage(){
    // if(kDebugMode){
    //   "package type---> debug always b".log();
    //   return true;
    // }
    if(localPackageIsB.getData()){
      "package type---> local type is b".log();
      return true;
    }
    if(!_clockWhite){
      "package type---> cloak is black".log();
      return false;
    }
    if(FirebaseHep.instance.funtime_af_on=="1"&&!_afB){
      "package type---> af is a".log();
      return false;
    }
    "package type---> cloak and af is b".log();
    localPackageIsB.saveData(true);
    return true;
  }

  _checkAutoToB(){
    "package type---> _checkAutoToB---->$aPackageShowed".log();
    if(!aPackageShowed){
      return;
    }
    if(checkPackage()){
      aPackageShowed=false;
      RouterUtils.offNamed(routersName: BRoutersName.home);
    }
  }

  uploadAfRevenue(MaxAd? ad,String adId,AdPosId posId){
    _appsflyerType?.uploadAdRevenue(ad, adId, posId);
  }

  bool cloakIsWhite()=>_clockWhite;
}