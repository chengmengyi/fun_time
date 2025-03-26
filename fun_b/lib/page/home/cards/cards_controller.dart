import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fun_b/bean/home_list_bean.dart';
import 'package:fun_b/dialog/add_chance/add_chance_dialog.dart';
import 'package:fun_b/dialog/comment/comment_dialog.dart';
import 'package:fun_b/hep/cash_hep.dart';
import 'package:fun_b/hep/comment_hep.dart';
import 'package:fun_b/hep/game_config_hep.dart';
import 'package:fun_b/hep/hep.dart';
import 'package:fun_b/hep/played_num_hep.dart';
import 'package:fun_b/hep/user_info_hep.dart';
import 'package:fun_base/base/base_controller.dart';
import 'package:fun_base/routers/routers_utils.dart';
import 'package:fun_base/util/event/event_code.dart';
import 'package:fun_base/util/event/event_data.dart';
import 'package:fun_base/util/event/event_result.dart';
import 'package:fun_base/util/package_type/package_type_hep.dart';
import 'package:fun_base/util/sql/base_sql_hep.dart';
import 'package:fun_base/util/tba_point/custom_point.dart';
import 'package:fun_base/util/tba_point/tab_point_hep.dart';

class CardsController extends BaseController{
  var chooseIndex=0;
  List<HomeListBean> homeList=[
    HomeListBean(uns: "list_uns1", sel: "list_sel1", center: "list1",numIcon: "num1",winnerType: WinnerType.winnerGame),
    HomeListBean(uns: "list_uns2", sel: "list_sel2", center: "list2",numIcon: "num2",winnerType: WinnerType.fruitMatch),
    HomeListBean(uns: "list_uns3", sel: "list_sel3", center: "list3",numIcon: "num3",winnerType: WinnerType.chasingLuck),
    HomeListBean(uns: "list_uns4", sel: "list_sel4", center: "list4",numIcon: "num4",winnerType: WinnerType.casinoRush),
    HomeListBean(uns: "list_uns5", sel: "list_sel5", center: "list5",numIcon: "num5",winnerType: WinnerType.winOrLose),
    HomeListBean(uns: "list_uns6", sel: "list_sel6", center: "list6",numIcon: "num6",winnerType: WinnerType.luckyNumber),
    HomeListBean(uns: "list_uns7", sel: "list_sel7", center: "list7",numIcon: "num7",winnerType: WinnerType.bettingHigh),
  ];

  GlobalKey boxGlobalKey=GlobalKey();
  Offset? boxFingerOffset;
  GlobalKey playGlobalKey=GlobalKey();
  Offset? playFingerOffset;

  @override
  void onReady() {
    super.onReady();
    _showBoxFinger();
    _showPlayFinger();
  }

  clickItem(index){
    if(index==chooseIndex){
      return;
    }
    chooseIndex=index;
    update(["sel_list","center","num"]);
  }

  clickLeft(){
    if(chooseIndex<=0){
      return;
    }
    clickItem(chooseIndex-1);
  }

  clickRight(){
    if(chooseIndex>=homeList.length-1){
      return;
    }
    clickItem(chooseIndex+1);
  }

  toPlay()async{
    if(null!=playFingerOffset){
      playFingerOffset=null;
      update(["play_finger"]);
    }
    var bean = homeList[chooseIndex];
    var canPlay = await PlayedNumHep.instance.checkCanPlay(bean.winnerType);
    if(canPlay){
      Hep.toPlayPage(bean.winnerType);
    }
  }

  WinnerType getWinnerTypeByIndex() => WinnerType.values[chooseIndex];

  String getWinUpColor(){
    var bean = homeList[chooseIndex];
    switch(bean.winnerType){
      case WinnerType.winnerGame: return "#FF3333";
      // case WinnerType.fruitMatch:
      // case WinnerType.casinoRush:
      // case WinnerType.winOrLose:
      // case WinnerType.bettingHigh:
      // case WinnerType.chasingLuck: return "#FFF70F";
      default: return "#FFF70F";
    }
  }

  addChance(){
    RouterUtils.dialog(widget: AddChanceDialog(winnerType: homeList[chooseIndex].winnerType,));
  }

  @override
  EventResult? initEventResult() => EventResult(
    call: (data){
      switch(data.code){
        case EventCode.updatePlayNumB:
          update(["num"]);
          break;
      }
    },
  );

  _showBoxFinger(){
    var renderBox = boxGlobalKey.currentContext!.findRenderObject() as RenderBox;
    boxFingerOffset = renderBox.localToGlobal(Offset.zero);
    update(["box_finger"]);
  }

  _showPlayFinger(){
    var findRenderObject = playGlobalKey.currentContext!.findRenderObject() as RenderBox;
    playFingerOffset=findRenderObject.localToGlobal(Offset.zero);
    update(["play_finger"]);
  }

  clickBox(){
    if(null!=boxFingerOffset){
      boxFingerOffset=null;
      update(["box_finger"]);
    }
    EventData(code: EventCode.clickBox).send();
  }

  test(){
    if(!kDebugMode){
      return;
    }
    // UserInfoHep.instance.updateUserCoins(500);
    CashHep.instance.updateCashTask(CashTaskType.card);
  }
}