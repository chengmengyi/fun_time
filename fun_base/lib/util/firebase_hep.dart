import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_ad_ios_plugins/hep/hep.dart';
import 'package:fun_base/util/ad_hep.dart';
import 'package:fun_base/util/storage_data.dart';

StorageData<String> otherBConfig=StorageData<String>(key: "otherBConfig", defaultValue: "");
StorageData<String> gameConfig=StorageData<String>(key: "gameConfig", defaultValue: "");
StorageData<String> adConfig=StorageData<String>(key: "adConfig", defaultValue: "");


class FirebaseHep{
  static final FirebaseHep _instance = FirebaseHep();
  static FirebaseHep get instance => _instance;

  var funtime_af_on="1";
  FirebaseRemoteConfig? _firebaseRemoteConfig;
  Function()? otherBCall;
  Function()? gameCall;

  initFirebase()async{
    try{
      await Firebase.initializeApp();
      _firebaseRemoteConfig=FirebaseRemoteConfig.instance;
      await _firebaseRemoteConfig?.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(seconds: 1),
      ));
      var result = await _firebaseRemoteConfig?.fetchAndActivate();
      if(result==true){
        _getFirebaseConfig();
      }else{
        Future.delayed(const Duration(milliseconds: 1000),(){
          "try again init firebase".log();
          initFirebase();
        });
      }
    }catch(e){
      Future.delayed(const Duration(milliseconds: 1000),(){
        "try again init firebase".log();
        initFirebase();
      });
    }
  }

  _getFirebaseConfig()async{
    var funtimeAf = _firebaseRemoteConfig?.getString("funtime_af_on")??"";
    if(funtimeAf.isNotEmpty){
      funtime_af_on=funtimeAf;
    }
    var other_b = _firebaseRemoteConfig?.getString("other_b")??"";
    if(otherBConfig.getData().isEmpty&&other_b.isNotEmpty){
      otherBConfig.saveData(other_b);
      otherBCall?.call();
    }
    var game = _firebaseRemoteConfig?.getString("c83_scratch_number")??"";
    if(gameConfig.getData().isEmpty&&game.isNotEmpty){
      gameConfig.saveData(game);
      gameCall?.call();
    }
    var ad = _firebaseRemoteConfig?.getString("sqftm_ad_config")??"";
    if(ad.isNotEmpty){
      adConfig.saveData(ad);
      AdHep.instance.updateAdData();
    }
  }
}