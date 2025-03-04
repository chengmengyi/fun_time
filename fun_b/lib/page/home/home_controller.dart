import 'package:flutter/material.dart';
import 'package:fun_b/bean/home_bottom_bean.dart';
import 'package:fun_b/hep/played_num_hep.dart';
import 'package:fun_b/page/home/cards/cards_child.dart';
import 'package:fun_b/page/home/cash/cash_child.dart';
import 'package:fun_base/base/base_controller.dart';
import 'package:fun_base/util/voice_player.dart';
class HomeController extends BaseController{
  var chooseIndex=0;
  List<HomeBottomBean> list=[
    HomeBottomBean(uns: "card_uns", sel: "card_sel", text: "Cards"),
    HomeBottomBean(uns: "ach_uns", sel: "ach_sel", text: "Cash"),
  ];
  List<Widget> pageList=[CardsChild(),CashChild()];

  @override
  void onInit() {
    super.onInit();
    PlayedNumHep.instance.initPlayNumData();
    VoicePlayer.instance.playBgMp3();
  }

  clickBottom(index){
    if(chooseIndex==index){
      return;
    }
    chooseIndex=index;
    update(["page"]);
  }
}