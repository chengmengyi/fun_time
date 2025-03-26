import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fun_base/base/base_controller.dart';
import 'package:fun_base/routers/a_routers_name.dart';
import 'package:fun_base/routers/b_routers_name.dart';
import 'package:fun_base/routers/routers_utils.dart';
import 'package:fun_base/util/ad_hep.dart';
import 'package:fun_base/util/notification_hep.dart';
import 'package:fun_base/util/package_type/package_type_hep.dart';
import 'package:fun_base/util/tba_point/custom_point.dart';
import 'package:fun_base/util/tba_point/tab_point_hep.dart';
import 'package:get/get.dart';

class LaunchController extends BaseController with GetSingleTickerProviderStateMixin{
  late AnimationController _animationController;

  @override
  void onInit() {
    super.onInit();
    _initAnimator();
    _tbaPoint();
  }

  @override
  void onReady() {
    super.onReady();
    _animationController.forward();
  }

  _initAnimator(){
    _animationController=AnimationController(duration: const Duration(seconds: 13),vsync: this)
      ..addListener(() {
        update(["progress"]);
      })
      ..addStatusListener((status) {
        if(status==AnimationStatus.completed){
          _checkPackageType();
        }
      });
  }

  String getProgressStr()=>"${(_animationController.value*100).toInt()}%";

  double getProgress()=>_animationController.value;

  double getIconMarginLeft(){
    var left = _animationController.value*(200.w);
    var max=168.w;
    if(left>=max){
      return max;
    }
    return left;
  }

  _checkPackageType(){
    var b = PackageTypeHep.instance.checkPackage();
    if(b){
      AdHep.instance.showOpenAd(
        closeAd: (){
          RouterUtils.offNamed(routersName: BRoutersName.home);
        },
      );
    }else{
      RouterUtils.offNamed(routersName: ARoutersName.home);
    }
  }

  _tbaPoint()async{
    var launchAppByNotification = await NotificationHep.instance.getLaunchAppByNotification();
    TbaPointHep.instance.pointEvent(CustomId.launch_page,params: {"source_from":launchAppByNotification?"push":"icon"});
  }

  @override
  void onClose() {
    _animationController.dispose();
    super.onClose();
  }
}