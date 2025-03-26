import 'dart:async';

import 'package:flutter_ad_ios_plugins/flutter_ios_ad_hep.dart';
import 'package:flutter_app_lifecycle/app_state_observer.dart';
import 'package:flutter_app_lifecycle/flutter_app_lifecycle.dart';
import 'package:fun_base/util/ad_hep.dart';
import 'package:fun_base/util/tba_point/tab_point_hep.dart';

class AppStateHep{
  static final AppStateHep _instance = AppStateHep();
  static AppStateHep get instance => _instance;

  Timer? _pausedTimer;
  var _isBack=false;

  initAppState(){
    FlutterAppLifecycle.instance.setCallObserver(
        AppStateObserver(call: (bool back) {
          if(back){
            _toBack();
          }else{
            _toFront();
          }
        })
    );
  }

  _toBack(){
    _pausedTimer=Timer(const Duration(milliseconds: 3000), () {
      _isBack=true;
    });
  }

  _toFront(){
    TbaPointHep.instance.sessionEvent();
    _pausedTimer?.cancel();
    Future.delayed(const Duration(milliseconds: 100),(){
      if(_isBack&&!FlutterIosAdHep.instance.adShowing()){
        AdHep.instance.showOpenAd(closeAd: (){});
      }
      _isBack=false;
    });
  }
}