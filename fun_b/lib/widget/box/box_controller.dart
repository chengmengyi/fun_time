import 'dart:async';

import 'package:fun_b/dialog/box/box_dialog.dart';
import 'package:fun_b/hep/storage/storage_bean.dart';
import 'package:fun_base/base/base_controller.dart';
import 'package:fun_base/routers/routers_utils.dart';
import 'package:fun_base/util/event/event_code.dart';
import 'package:fun_base/util/event/event_result.dart';
import 'package:fun_base/util/tba_point/custom_point.dart';
import 'package:fun_base/util/tba_point/tab_point_hep.dart';

class BoxController extends BaseController{
  var countTime=0;
  Timer? _timer;

  @override
  void onReady() {
    super.onReady();
    _checkCountTime();
  }

  _checkCountTime(){
    var timer = boxCountTimer.getData();
    if(timer<=0){
      return;
    }
    var timeSecond = boxLastTimeSecond.getData();
    var nowTime = DateTime.now().millisecondsSinceEpoch;
    if(nowTime>=(timeSecond*1000+timer)){
      return;
    }
    countTime=((timeSecond*1000+timer)-nowTime)~/1000;
    update(["time"]);
    _timer=Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      countTime--;
      update(["time"]);
      if(countTime<=0){
        _timer?.cancel();
      }
    });
  }

  @override
  EventResult? initEventResult() => EventResult(
    call: (data){
      switch(data.code){
        case EventCode.clickBox:
          clickBox();
          break;
      }
    },
  );

  clickBox(){
    TbaPointHep.instance.pointEvent(CustomId.box_c);
    if(countTime>0){
      return;
    }
    RouterUtils.dialog(
      widget: BoxDialog(
        dismiss: (bool received){
          if(received){
            _updateTimer();
          }
        },
      ),
    );
  }

  _updateTimer(){
    var timeSecond = boxLastTimeSecond.getData()+15;
    if(timeSecond>120){
      timeSecond=120;
    }
    boxCountTimer.saveData(DateTime.now().millisecondsSinceEpoch);
    boxLastTimeSecond.saveData(timeSecond);
    _checkCountTime();
  }
}