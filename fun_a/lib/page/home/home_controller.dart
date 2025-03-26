import 'package:flutter/material.dart';
import 'package:fun_a/bean/home_bottom_bean.dart';
import 'package:fun_a/hep/played_num_hep.dart';
import 'package:fun_a/page/home/ach/ach_child.dart';
import 'package:fun_a/page/home/cards/cards_child.dart';
import 'package:fun_base/base/base_controller.dart';
import 'package:fun_base/util/tba_point/custom_point.dart';
import 'package:fun_base/util/tba_point/tab_point_hep.dart';
import 'package:fun_base/util/voice_player.dart';
class HomeController extends BaseController{
  var chooseIndex=0;
  List<HomeBottomBean> list=[
    HomeBottomBean(uns: "card_uns", sel: "card_sel", text: "Cards"),
    HomeBottomBean(uns: "ach_uns", sel: "ach_sel", text: "Achieve"),
  ];
  List<Widget> pageList=[CardsChild(),AchChild()];

  @override
  void onInit() {
    super.onInit();
    PlayedNumHep.instance.initPlayNumData();
    VoicePlayer.instance.playBgMp3();
    TbaPointHep.instance.sqlEvent();
    TbaPointHep.instance.pointEvent(CustomId.card_page,params: {"user_b":0});
  }

  clickBottom(index){
    if(chooseIndex==index){
      return;
    }
    chooseIndex=index;
    update(["page"]);
  }
}