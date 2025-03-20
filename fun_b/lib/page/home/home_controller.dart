import 'package:flutter/material.dart';
import 'package:fun_b/bean/home_bottom_bean.dart';
import 'package:fun_b/hep/notification_hep.dart';
import 'package:fun_b/hep/played_num_hep.dart';
import 'package:fun_b/hep/storage/storage_bean.dart';
import 'package:fun_b/page/home/cards/cards_child.dart';
import 'package:fun_b/page/home/cash/cash_child.dart';
import 'package:fun_base/base/base_controller.dart';
import 'package:fun_base/util/event/event_code.dart';
import 'package:fun_base/util/event/event_result.dart';
import 'package:fun_base/util/voice_player.dart';
class HomeController extends BaseController{
  var chooseIndex=0,showCashFinger=false;
  List<HomeBottomBean> list=[
    HomeBottomBean(uns: "card_uns", sel: "card_sel", text: "Cards"),
    HomeBottomBean(uns: "ach_uns", sel: "ach_sel", text: "Cash"),
  ];
  List<Widget> pageList=[CardsChild(),CashChild()];
  GlobalKey cashGlobalKey=GlobalKey();

  @override
  void onInit() {
    super.onInit();
    PlayedNumHep.instance.initPlayNumData();
    VoicePlayer.instance.playBgMp3();
    NotificationHep.instance.initNotification();
  }

  clickBottom(index){
    if(chooseIndex==index){
      return;
    }
    if(showCashFinger){
      showCashFinger=false;
      update(["cash_finger"]);
    }
    chooseIndex=index;
    update(["page"]);
  }

  @override
  EventResult? initEventResult() => EventResult(
    call: (data){
      switch(data.code){
        case EventCode.firstGetReward:
          firstGetReward.saveData(false);
          showCashFinger=true;
          update(["cash_finger"]);
          break;
        case EventCode.updateHomeIndex:
          clickBottom(data.intValue??0);
          break;
      }
    },
  );
}