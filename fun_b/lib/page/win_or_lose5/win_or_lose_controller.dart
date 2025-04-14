import 'dart:async';

import 'package:fun_b/hep/auto_scratch.dart';
import 'package:fun_base/base/base_controller.dart';
import 'package:fun_base/util/util.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fun_b/bean/winner_back_bean.dart';
import 'package:fun_b/bean/winner_reward_bean.dart';
import 'package:fun_b/dialog/add_chance/add_chance_dialog.dart';
import 'package:fun_b/dialog/big_win/big_win_dialog.dart';
import 'package:fun_b/dialog/no_win/no_win_dialog.dart';
import 'package:fun_b/dialog/normal_win/normal_win_dialog.dart';
import 'package:fun_b/hep/game_config_hep.dart';
import 'package:fun_b/hep/played_num_hep.dart';
import 'package:fun_b/hep/user_info_hep.dart';
import 'package:fun_base/routers/routers_utils.dart';
import 'package:fun_base/util/event/event_code.dart';
import 'package:fun_base/util/event/event_result.dart';
import 'package:fun_base/util/voice_player.dart';

class WinOrLoseController extends BaseController with GetTickerProviderStateMixin{
  var startScratch=false,showDiamondAnimator=false,canPlay=true,showGuaKaFinger=true,noAnyOperate=true;
  WinnerType winnerType=WinnerType.winOrLose;
  late WinnerBackBean _winnerBackBean;
  List<WinnerRewardBean> winnerRewardList=[];
  final key = GlobalKey<ScratcherState>();
  GlobalKey diamondGlobalKey=GlobalKey();
  GlobalKey diamondEndGlobalKey=GlobalKey();

  Offset diamondEndOffset=Offset.zero;
  late AnimationController diamondLottieController;
  Animation<Offset>? diamondAnimation;
  final List<String> _allIconList=["red","black"];

  Offset? iconOffset;
  AutoScratch? autoScratch;

  late AnimationController scaleController;
  Timer? _showGuaKaFingerTimer;


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
    _initWinnerBean();
    autoScratch=AutoScratch(key);
  }

  _initWinnerBean(){
    _winnerBackBean = GameConfigHep.instance.getWinnerBean(winnerType);
    winnerRewardList.clear();
    if(_winnerBackBean.winNum>0){
      while(winnerRewardList.length<_winnerBackBean.winNum){
        var randomNumbers = _getTwoRandomNumbers();
        winnerRewardList.add(WinnerRewardBean(rewardNum: _winnerBackBean.coinsNum, winType: _winnerBackBean.winType, winner: true, iconList: ["${_allIconList.random()}${randomNumbers.last}","${_allIconList.random()}${randomNumbers.first}"]));
      }
    }
    while(winnerRewardList.length<4){
      var randomNumbers = _getTwoRandomNumbers();
      winnerRewardList.add(WinnerRewardBean(rewardNum: Random().nextInt(_winnerBackBean.rewardNormal), winType: WinType.coins, winner: false, iconList: ["${_allIconList.random()}${randomNumbers.first}","${_allIconList.random()}${randomNumbers.last}"]));
    }

    update(["play"]);
  }

  //第二个大于第一个
  List<int> _getTwoRandomNumbers() {
    Random random = Random();
    Set<int> numbersSet = {};
    while (numbersSet.length < 2) {
      numbersSet.add(random.nextInt(13));
    }
    List<int> numbersList = numbersSet.toList()..sort();
    return numbersList;
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
    noAnyOperate=false;
    _checkFirstGua();
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
    await Future.delayed(const Duration(milliseconds: 1000));
    _checkResult();
  }

  _checkResult(){
    scaleController.stop();
    PlayedNumHep.instance.updatePlayedNum(winnerType);
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
          winnerType: winnerType,
          dismiss: (){
            _reset();
          },
        ),
      );
    }
  }

  _reset()async{
    startScratch=false;
    _initWinnerBean();
    key.currentState?.reset();
    autoScratch?.stopWhile=false;
    iconOffset=null;
    noAnyOperate=true;
    _startShowGuaKaFingerTimer();
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
    noAnyOperate=false;
    _checkFirstGua();
    VoicePlayer.instance.playVoiceMp3();
    startScratch=true;
  }

  onScratchEnd(){
    startScratch=false;
  }

  _checkFirstGua(){
    showGuaKaFinger=false;
    update(["gua_finger"]);
  }

  _startShowGuaKaFingerTimer(){
    _showGuaKaFingerTimer?.cancel();
    _showGuaKaFingerTimer=Timer(const Duration(milliseconds: 3000), (){
      if(noAnyOperate){
        showGuaKaFinger=true;
        update(["gua_finger"]);
      }
    });
  }


  clickBack(){
    if(startScratch){
      return;
    }
    RouterUtils.back();
  }

  @override
  EventResult? initEventResult() => EventResult(
      call: (data){
        switch(data.code){
          case EventCode.updatePlayNumB:
            update(["num"]);
            break;
        }
      }
  );

  @override
  void onClose() {
    scaleController.dispose();
    diamondLottieController.dispose();
    _showGuaKaFingerTimer?.cancel();
    _showGuaKaFingerTimer=null;
    super.onClose();
  }
}