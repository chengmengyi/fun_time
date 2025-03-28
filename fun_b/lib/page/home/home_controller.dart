import 'package:flutter/material.dart';
import 'package:fun_b/bean/home_bottom_bean.dart';
import 'package:fun_b/hep/comment_hep.dart';
import 'package:fun_b/hep/played_num_hep.dart';
import 'package:fun_b/hep/storage/storage_bean.dart';
import 'package:fun_b/page/home/cards/cards_child.dart';
import 'package:fun_b/page/home/cash/cash_child.dart';
import 'package:fun_base/base/base_controller.dart';
import 'package:fun_base/util/app_state_hep.dart';
import 'package:fun_base/util/event/event_code.dart';
import 'package:fun_base/util/event/event_result.dart';
import 'package:fun_base/util/h5_hep.dart';
import 'package:fun_base/util/notification_hep.dart';
import 'package:fun_base/util/tba_point/custom_point.dart';
import 'package:fun_base/util/tba_point/tab_point_hep.dart';
import 'package:fun_base/util/voice_player.dart';
class BHomeController extends BaseController{
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
    AppStateHep.instance.initAppState();
    PlayedNumHep.instance.initPlayNumData();
    VoicePlayer.instance.playBgMp3();
    NotificationHep.instance.initNotification();
    TbaPointHep.instance.sqlEvent();
    TbaPointHep.instance.pointEvent(CustomId.card_page,params: {"user_b":1});
    H5Hep.instance.methodB1();
    H5Hep.instance.methodB2();
  }

  @override
  void onReady() {
    super.onReady();
    CommentHep.instance.showCommentDialog();
    firstOpenApp.saveData(false);
  }

  clickBottom(index){
    if(chooseIndex==index){
      return;
    }
    if(index==1){
      TbaPointHep.instance.pointEvent(CustomId.cash_page);
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
          Future.delayed(const Duration(milliseconds: 3000),(){
            CommentHep.instance.showCommentDialog();
          });
          break;
        case EventCode.updateHomeIndex:
          clickBottom(data.intValue??0);
          break;
      }
    },
  );
}