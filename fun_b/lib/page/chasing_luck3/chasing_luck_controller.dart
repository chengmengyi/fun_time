import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fun_b/bean/winner_back_bean.dart';
import 'package:fun_b/bean/winner_reward_bean.dart';
import 'package:fun_b/dialog/add_chance/add_chance_dialog.dart';
import 'package:fun_b/dialog/big_win/big_win_dialog.dart';
import 'package:fun_b/dialog/no_win/no_win_dialog.dart';
import 'package:fun_b/dialog/normal_win/normal_win_dialog.dart';
import 'package:fun_b/hep/auto_scratch.dart';
import 'package:fun_b/hep/game_config_hep.dart';
import 'package:fun_b/hep/played_num_hep.dart';
import 'package:fun_b/hep/user_info_hep.dart';
import 'package:fun_base/base/base_controller.dart';
import 'package:fun_base/routers/routers_utils.dart';
import 'package:fun_base/util/event/event_code.dart';
import 'package:fun_base/util/event/event_result.dart';
import 'package:fun_base/util/util.dart';
import 'package:fun_base/util/voice_player.dart';

class ChasingLuckController extends BaseController with GetTickerProviderStateMixin{
  var startScratch=false,showDiamondAnimator=false,canPlay=true;
  WinnerType winnerType=WinnerType.chasingLuck;
  late WinnerBackBean _winnerBackBean;
  List<WinnerRewardBean> winnerRewardList=[];
  final key = GlobalKey<ScratcherState>();
  GlobalKey diamondGlobalKey=GlobalKey();
  GlobalKey diamondEndGlobalKey=GlobalKey();

  Offset diamondEndOffset=Offset.zero;
  late AnimationController diamondLottieController;
  Animation<Offset>? diamondAnimation;
  final List<String> _allIconList=["luck4","luck5","luck6","luck7","luck8","luck9"];
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
    _initWinnerBean();
    autoScratch=AutoScratch(key);
  }

  _initWinnerBean(){
    _winnerBackBean = GameConfigHep.instance.getWinnerBean(winnerType);
    winnerRewardList.clear();
    if(_winnerBackBean.winNum>0){
      final Random random = Random();
      final List<String> selectedTwoElements = [];
      while (selectedTwoElements.length < _winnerBackBean.winNum) {
        String randomElement = _allIconList[random.nextInt(_allIconList.length)];
        if (!selectedTwoElements.contains(randomElement)) {
          selectedTwoElements.add(randomElement);
        }
      }
      for (var value in selectedTwoElements) {
        for (int i = 0; i < 3; i++) {
          winnerRewardList.add(WinnerRewardBean(rewardNum: _winnerBackBean.coinsNum, winType: _winnerBackBean.winType, winner: true, iconList: [value]));
        }
      }
      final List<String> remainingElements = _allIconList.where((element) => !selectedTwoElements.contains(element)).toList();
      while (winnerRewardList.length < 12) {
        final String randomElement = remainingElements[random.nextInt(remainingElements.length)];
        final int count = winnerRewardList.where((element) => element.iconList.first == randomElement).length;
        if (count < 2) {
          winnerRewardList.add(WinnerRewardBean(rewardNum: Random().nextInt(_winnerBackBean.rewardNormal), winType: WinType.coins, winner: false, iconList: [randomElement]));
        }
      }

    }else{
      for (var value in _generateRandomList()) {
        winnerRewardList.add(WinnerRewardBean(rewardNum: Random().nextInt(_winnerBackBean.rewardNormal), winType: WinType.coins, winner: false, iconList: [value]));
      }
    }
    winnerRewardList.shuffle();
    update(["play"]);
  }

  List<String> _generateRandomList() {
    final List<String> resultList = [];
    final Random random = Random();

    while (resultList.length < 12) {
      final int randomIndex = random.nextInt(_allIconList.length);
      final String selectedElement = _allIconList[randomIndex];
      final int count = resultList.where((element) => element == selectedElement).length;
      if (count < 2) {
        resultList.add(selectedElement);
      }
    }
    resultList.shuffle(random);
    return resultList;
  }

  String getRewardIcon(){
    if(_winnerBackBean.winNum>0){
      var indexWhere = winnerRewardList.indexWhere((element) => element.winner);
      if(indexWhere>=0){
        return winnerRewardList[indexWhere].iconList.first;
      }else{
        return "fruit3";
      }
    }else{
      var newList = List.from(_allIconList);
      for (var value in winnerRewardList) {
        var first = value.iconList.first;
        if(newList.contains(first)){
          newList.remove(first);
        }
      }
      if(newList.isNotEmpty){
        return newList.first;
      }
      return "fruit3";
    }
  }

  List<String> getRandomElements(int count) {
    final random = Random();
    List<String> result = [];
    final remaining = List.from(_allIconList);

    while (result.length < count && remaining.isNotEmpty) {
      final index = random.nextInt(remaining.length);
      result.add(remaining[index]);
      remaining.removeAt(index);
    }

    return result;
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
    super.onClose();
  }
}