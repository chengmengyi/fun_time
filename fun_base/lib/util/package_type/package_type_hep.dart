import 'package:flutter/foundation.dart';
import 'package:flutter_ad_ios_plugins/data/storage_data.dart';
import 'package:flutter_ad_ios_plugins/hep/hep.dart';
import 'package:fun_base/util/package_type/appsflyer_type.dart';
import 'package:fun_base/util/package_type/cloak_type.dart';

StorageData<bool> localPackageIsB=StorageData<bool>(key: "localPackageIsB", defaultValue: false);

class PackageTypeHep{
  static final PackageTypeHep _instance = PackageTypeHep();
  static PackageTypeHep get instance => _instance;

  var _clockWhite=false,_afB=false;

  initCheck()async{
    CloakType().requestClock((white){
      _clockWhite=white;
    });

    AppsflyerType().init((){
      _afB=true;
    });
  }

  bool checkPackage(){
    if(kDebugMode){
      "package type---> debug always b".log();
      return true;
    }
    if(localPackageIsB.getData()){
      "package type---> local type is b".log();
      return true;
    }
    if(!_clockWhite){
      "package type---> cloak is black".log();
      return false;
    }
    if(!_afB){
      "package type---> af is a".log();
      return false;
    }
    localPackageIsB.saveData(true);
    return true;
  }
}