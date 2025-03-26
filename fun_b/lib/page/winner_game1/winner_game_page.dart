import 'package:flutter/material.dart';
import 'package:fun_b/bean/winner_back_bean.dart';
import 'package:fun_b/hep/storage/storage_bean.dart';
import 'package:fun_b/page/winner_game1/winner_game_controller.dart';
import 'package:fun_b/widget/money_lottie_widget.dart';
import 'package:fun_b/widget/play_num_widget.dart';
import 'package:fun_b/widget/play_top_widget.dart';
import 'package:fun_b/widget/pops_widget.dart';
import 'package:fun_b/widget/win_up_widget.dart';
import 'package:fun_base/base/base_widget.dart';
import 'package:fun_base/util/util.dart';
import 'package:fun_base/widget/local_image_widget.dart';
import 'package:fun_base/widget/lottie_widget.dart';
import 'package:fun_base/widget/text_widget.dart';

class WinnerGamePage extends BaseWidget<WinnerGameController>{
  @override
  WinnerGameController createController() => WinnerGameController();

  @override
  Widget createWidget() => WillPopScope(
      child: Scaffold(
        body: Stack(
          children: [
            LocalImageWidget(image: "play_bg", width: double.infinity, height: double.infinity),
            SafeArea(
              child: Column(
                children: [
                  PlayTopWidget(
                    globalKey: ftController.diamondEndGlobalKey,
                    clickBack: (){
                      ftController.clickBack();
                    },
                  ),
                  SizedBox(height: 20.h,),
                  _playWidget(),
                  SizedBox(height: 20.h,),
                  _numWidget(),
                  SizedBox(height: 10.h,),
                  GetBuilder<WinnerGameController>(
                    id: "check_btn",
                    builder: (_)=>InkWell(
                      onTap: (){
                        ftController.clickCheckCard();
                      },
                      child: LocalImageWidget(image: ftController.canPlay?"check_card":"next_card", width: 268.w, height: 84.h),
                    ),
                  )
                ],
              ),
            ),
            _diamondWidget(),
            _goldWidget(),
            PopsWidget(),
            MoneyLottieWidget(),
          ],
        ),
      ),
    onWillPop: ()async{
      ftController.clickBack();
      return false;
    },
  );

  _playWidget()=>SizedBox(
    width: 312.w,
    height: 440.h,
    child: Stack(
      children: [
        LocalImageWidget(image: "winner1", width: 312.w, height: 440.h),
        Container(
          width: double.infinity,
          height: 240.h,
          margin: EdgeInsets.only(left: 12.w,right: 12.w,top: 106.h),
          child: Scratcher(
            enabled: true,
            brushSize: 80,
            threshold: 70,
            key: ftController.key,
            color: Colors.transparent,
            onThreshold: (){
              ftController.onThreshold();
            },
            onScratchUpdate: (details){
              ftController.updateIconOffset(details);
            },
            onScratchStart: (){
              ftController.onScratchStart();
            },
            onScratchEnd: (){
              ftController.onScratchEnd();
            },
            image: Image.asset('ft_resource/image/winner2.webp',fit: BoxFit.fill,),
            child: GetBuilder<WinnerGameController>(
              id: "play",
              builder: (_)=>LayoutBuilder(
                builder: (context,bc){
                  var maxWidth = bc.maxWidth;
                  var maxHeight = bc.maxHeight;
                  return SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: Stack(
                      children: [
                        LocalImageWidget(image: "winner3", width: double.infinity, height: double.infinity),
                        Row(
                          children: [
                            SizedBox(
                              width: maxWidth/4,
                              height: maxHeight,
                              child: ListView.builder(
                                itemCount: ftController.winnerRewardList.length,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context,index){
                                  var rewardBean = ftController.winnerRewardList[index];
                                  return Container(
                                    width: maxWidth/4,
                                    height: maxHeight/4,
                                    alignment: Alignment.center,
                                    child: rewardBean.winType==WinType.coins?
                                    TextWidget(data: "\$${rewardBean.rewardNum}", color: "#FFD725", size: 16.sp,fontWeight: FontWeight.bold,fontFamily: "ft",showShadows: true,):
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(
                                          key: index==ftController.winnerRewardList.length-1?ftController.diamondGlobalKey:null,
                                          child: LocalImageWidget(image: "icon_diamond", width: 24.w, height: 24.h),
                                        ),
                                        TextWidget(data: "+${rewardBean.rewardNum}", color: "#FFD725", size: 16.sp,fontWeight: FontWeight.bold,fontFamily: "ft",)
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: ftController.winnerRewardList.length,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context,index){
                                  var rewardBean = ftController.winnerRewardList[index];
                                  var iconList = rewardBean.iconList;
                                  return SizedBox(
                                    width: double.infinity,
                                    height: maxHeight/4,
                                    child: Row(
                                      children: List.generate(iconList.length, (i) => Container(
                                        width: maxWidth/4,
                                        height: maxHeight/4,
                                        alignment: Alignment.center,
                                        child: rewardBean.winner?
                                        ScaleTransition(
                                          scale: ftController.scaleController,
                                          child: LocalImageWidget(image: iconList[i], width: 52.w, height: 52.h),
                                        ):
                                        LocalImageWidget(image: iconList[i], width: 52.w, height: 52.h),
                                      )),
                                    ),
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: EdgeInsets.only(bottom: 46.h),
            child: WinUpWidget(winnerType: ftController.winnerType,),
          ),
        ),
        GetBuilder<WinnerGameController>(
          id: "gua_finger",
          builder: (_)=>Visibility(
            visible: firstGuaka.getData(),
            child: Container(
              margin: EdgeInsets.only(top: 106.h),
              child: IgnorePointer(
                child: LottieWidget(name: "guakai", ext: "json"),
              ),
            ),
          ),
        ),
      ],
    ),
  );

  _numWidget()=>GetBuilder<WinnerGameController>(
    id: "num",
    builder: (_)=>PlayNumWidget(winnerType: ftController.winnerType),
  );

  _diamondWidget()=>GetBuilder<WinnerGameController>(
    id: "diamond",
    builder: (_){
      var value = ftController.diamondAnimation?.value;
      var dx = value?.dx??0;
      var dy = value?.dy??0;
      return Visibility(
        visible: ftController.showDiamondAnimator,
        child: Container(
          margin: EdgeInsets.only(left: dx<=0?0:dx,top: dy<=0?0:dy),
          child: LocalImageWidget(image: "icon_diamond", width: 24.w, height: 24.h),
        ),
      );
    },
  );

  _goldWidget()=>GetBuilder<WinnerGameController>(
    id: "gold_icon",
    builder: (_){
      var left=null==ftController.iconOffset?0.0:ftController.iconOffset?.dx??0.0;
      var top=null==ftController.iconOffset?0.0:ftController.iconOffset?.dy??0.0;
      return null==ftController.iconOffset?
      Container():
      Container(
        margin: EdgeInsets.only(left: left<0?0:left,top: top<0?0:top),
        child: Image.asset("ft_resource/image/coins.png",width: 40,height: 40),
      );
    },
  );
}