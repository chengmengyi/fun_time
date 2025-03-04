import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fun_a/bean/winner_back_bean.dart';
import 'package:fun_a/bean/winner_reward_bean.dart';
import 'package:fun_a/dialog/add_chance/add_chance_dialog.dart';
import 'package:fun_a/dialog/big_win/big_win_dialog.dart';
import 'package:fun_a/dialog/no_win/no_win_dialog.dart';
import 'package:fun_a/dialog/normal_win/normal_win_dialog.dart';
import 'package:fun_a/hep/ach_hep.dart';
import 'package:fun_a/hep/auto_scratch.dart';
import 'package:fun_a/hep/game_config_hep.dart';
import 'package:fun_a/hep/played_num_hep.dart';
import 'package:fun_a/hep/user_info_hep.dart';
import 'package:fun_base/base/base_controller.dart';
import 'package:fun_base/routers/routers_utils.dart';
import 'package:fun_base/util/event/event_code.dart';
import 'package:fun_base/util/event/event_result.dart';
import 'package:fun_base/util/util.dart';
import 'package:fun_base/util/voice_player.dart';

class WinnerGameController extends BaseController with GetTickerProviderStateMixin{
  var startScratch=false,showDiamondAnimator=false,canPlay=true;
  WinnerType winnerType=WinnerType.winnerGame;
  late WinnerBackBean _winnerBackBean;
  List<WinnerRewardBean> winnerRewardList=[];
  final key = GlobalKey<ScratcherState>();
  GlobalKey diamondGlobalKey=GlobalKey();
  GlobalKey diamondEndGlobalKey=GlobalKey();
  final List<String> _allIconList=["winner4","winner5","winner6","winner7","winner8","winner9",];

  Offset diamondEndOffset=Offset.zero;
  late AnimationController diamondLottieController;
  Animation<Offset>? diamondAnimation;

  Offset? iconOffset;
  AutoScratch? autoScratch;

  late AnimationController scaleController;

  @override
  void onInit() {
    super.onInit();
    diamondLottieController=AnimationController(vsync: this,duration: const Duration(milliseconds: 2000))
      ..addListener(() {
        update(["diamond"]);
      })
      ..addStatusListener((status) {
        if(status==AnimationStatus.completed){
          UserInfoHep.instance.updateUserDiamond(_winnerBackBean.winNum);
          showDiamondAnimator=false;
          update(["diamond"]);
          _reset();
        }
      });

    scaleController=AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
      lowerBound: 1,
      upperBound: 1.2,
    )
      ..addStatusListener((status) {
        if(status==AnimationStatus.completed){
          scaleController.reverse();
        }else if(status==AnimationStatus.dismissed){
          scaleController.forward();
        }
      });
  }

  @override
  void onReady() {
    super.onReady();
    _initWinBackBean();
    autoScratch=AutoScratch(key);
  }

  clickCheckCard()async{
    if(startScratch){
      return;
    }
    if(UserInfoHep.instance.getPlayNum(winnerType)<=0){
      RouterUtils.dialog(
          widget: AddChanceDialog(
            winnerType: winnerType,
          )
      );
      return;
    }
    startScratch=true;
    if(canPlay){
      VoicePlayer.instance.playVoiceMp3();
      autoScratch?.startAuto(
        key: key,
        iconOffsetCall: (offset){
          iconOffset=offset;
          update(["gold_icon"]);
        },
      );
    }else{
      if(!await PlayedNumHep.instance.checkHasNextPlay(winnerType)){
        RouterUtils.back();
      }
    }
  }

  onThreshold()async{
    autoScratch?.stopWhile=true;
    Future.delayed(const Duration(milliseconds: 100),(){
      iconOffset=null;
      update(["gold_icon"]);
    });
    key.currentState?.reveal();
    if(_winnerBackBean.winNum>0){
      scaleController..reset()..forward();
    }
    await Future.delayed(const Duration(milliseconds: 1600));
    _checkResult();
  }

  _checkResult(){
    AchHep.instance.updateAchPro(AchType.winner);
    PlayedNumHep.instance.updatePlayedNum(winnerType);
    scaleController.stop();
    var totalReward = winnerRewardList.where((bean) => bean.winner).fold(0, (previousValue, element) => previousValue + element.rewardNum);
    if(totalReward<=0){
      RouterUtils.dialog(
        widget: NoWinDialog(
          dismiss: (){
            _reset();
          },
        ),
      );
      return;
    }
    if(_winnerBackBean.winType==WinType.diamond){
      var renderBox = diamondGlobalKey.currentContext!.findRenderObject() as RenderBox;
      var offset = renderBox.localToGlobal(Offset.zero);
      var endRenderBox = diamondEndGlobalKey.currentContext!.findRenderObject() as RenderBox;
      diamondEndOffset=endRenderBox.localToGlobal(Offset.zero);
      showDiamondAnimator=true;
      update(["diamond"]);
      diamondAnimation=Tween<Offset>(
        begin: offset,
        end: diamondEndOffset,
      ).animate(CurvedAnimation(parent: diamondLottieController, curve: Curves.elasticInOut));

      diamondLottieController..reset()..forward();
      return;
    }
    if(totalReward>=_winnerBackBean.bigWin){
      RouterUtils.dialog(
        widget: BigWinDialog(
          reward: totalReward,
          dismiss: (){
            _reset();
          },
        ),
      );
    }else{
      RouterUtils.dialog(
        widget: NormalWinDialog(
          reward: totalReward,
          dismiss: (){
            _reset();
          },
        ),
      );
    }
  }

  _reset()async{
    startScratch=false;
    _initWinBackBean();
    key.currentState?.reset();
    autoScratch?.stopWhile=false;
    iconOffset=null;
    update(["gold_icon"]);
    await UserInfoHep.instance.updateCanPlayNum(-1,winnerType);
    update(["num"]);
    canPlay = await PlayedNumHep.instance.checkCanPlay(winnerType);
    if(!canPlay){
      update(["check_btn"]);
    }
  }

  updateIconOffset(DragUpdateDetails details){
    var offset = details.localPosition;
    iconOffset=Offset(offset.dx+(autoScratch?.marginLeft??0), offset.dy+(autoScratch?.marginTop??0));
    update(["gold_icon"]);
  }

  onScratchStart(){
    if(UserInfoHep.instance.getPlayNum(winnerType)<=0){
      RouterUtils.dialog(
        widget: AddChanceDialog(
          winnerType: winnerType,
        )
      );
      return;
    }
    VoicePlayer.instance.playVoiceMp3();
    startScratch=true;
  }

  onScratchEnd(){
    startScratch=false;
  }

  clickBack(){
    if(startScratch){
      return;
    }
    RouterUtils.back();
  }

  _initWinBackBean(){
    _winnerBackBean = GameConfigHep.instance.getWinnerBean(winnerType);
    winnerRewardList.clear();
    if(_winnerBackBean.winType==WinType.diamond){
      while(winnerRewardList.length<_winnerBackBean.winNum){
        var icon = _allIconList.random();
        winnerRewardList.add(WinnerRewardBean(rewardNum: 1, winType: WinType.diamond,winner: true,iconList: [icon,icon,icon]));
      }
    }else{
      while(winnerRewardList.length<_winnerBackBean.winNum){
        var icon = _allIconList.random();
        winnerRewardList.add(WinnerRewardBean(rewardNum: _winnerBackBean.coinsNum, winType: WinType.coins,winner: true,iconList: [icon,icon,icon]));
      }
    }
    while(winnerRewardList.length<4){
      var rewardBean = WinnerRewardBean(rewardNum: Random().nextInt(_winnerBackBean.rewardNormal), winType: WinType.coins,winner: false,iconList: randomSelect(_allIconList, 3, 2));
      if(_winnerBackBean.winType==WinType.diamond){
        winnerRewardList.insert(0, rewardBean);
      }else{
        winnerRewardList.add(rewardBean);
      }
    }
    update(["play"]);
  }

  @override
  EventResult? initEventResult() => EventResult(
    call: (data){
      switch(data.code){
        case EventCode.updatePlayNumA:
          update(["num"]);
          break;
      }
    }
  );

  @override
  void onClose() {
    scaleController.dispose();
    diamondLottieController.dispose();
    super.onClose();
  }
}