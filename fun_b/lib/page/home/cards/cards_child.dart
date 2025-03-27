import 'package:flutter/material.dart';
import 'package:fun_b/dialog/set/set_dialog.dart';
import 'package:fun_b/hep/user_info_hep.dart';
import 'package:fun_b/page/home/cards/cards_controller.dart';
import 'package:fun_b/widget/box/box_widget.dart';
import 'package:fun_b/widget/coins_widget.dart';
import 'package:fun_b/widget/diamond_widget.dart';
import 'package:fun_b/widget/money_lottie_widget.dart';
import 'package:fun_b/widget/pops_widget.dart';
import 'package:fun_b/widget/win_up_widget.dart';
import 'package:fun_base/base/base_widget.dart';
import 'package:fun_base/routers/routers_utils.dart';
import 'package:fun_base/util/h5_hep.dart';
import 'package:fun_base/util/util.dart';
import 'package:fun_base/widget/finger_widget.dart';
import 'package:fun_base/widget/local_image_widget.dart';
import 'package:fun_base/widget/lottie_widget.dart';
import 'package:fun_base/widget/text_widget.dart';

class CardsChild extends BaseWidget<CardsController>{
  @override
  CardsController createController() => CardsController();

  @override
  Widget createWidget() => Stack(
    children: [
      LocalImageWidget(image: "home1", width: double.infinity, height: double.infinity),
      SafeArea(
        child: Column(
          children: [
            _topWidget(),
            SizedBox(height: 20.h,),
            _selListWidget(),
            SizedBox(height: 16.h,),
            _centerWidget(),
            SizedBox(height: 16.h,),
            _numWidget(),
            SizedBox(height: 16.h,),
            InkWell(
              onTap: (){
                ftController.toPlay();
              },
              child: SizedBox(
                key: ftController.playGlobalKey,
                child: LocalImageWidget(image: "play", width: 248.w, height: 84.h),
              ),
            )
          ],
        ),
      ),
      Positioned(
        left: 12.w,
        bottom: 180.h,
        child: GetBuilder<CardsController>(
          id: "game_icon",
          builder: (_)=>Visibility(
            visible: ftController.showGameIcon,
            child: InkWell(
              onTap: (){
                H5Hep.instance.clickH5();
              },
              child: LocalImageWidget(image: "icon_h5", width: 40.w, height: 40.w),
            ),
          ),
        ),
      ),
      _boxFingerWidget(),
      _playFingerWidget(),
      PopsWidget(),
      MoneyLottieWidget(),
    ],
  );

  _numWidget()=>GetBuilder<CardsController>(
    id: "num",
    builder: (_)=>SizedBox(
      width: 164.w,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Container(
            width: 132.w,
            height: 28.w,
            alignment: Alignment.center,
            margin: EdgeInsets.only(left: 16.w,right: 16.w),
            decoration: BoxDecoration(
                color: "#FFFFFF".toColor(),
                border: Border.all(
                  width: 1.w,
                  color: "#000000".toColor(),
                )
            ),
            child: TextWidget(data: "${UserInfoHep.instance.getPlayNum(ftController.getWinnerTypeByIndex())}", color: "#FFD84B", size: 20.sp,fontWeight: FontWeight.bold,),
          ),
          LocalImageWidget(image: ftController.homeList[ftController.chooseIndex].numIcon, width: 32.w, height: 32.w),
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: (){
                ftController.addChance();
              },
              child: LocalImageWidget(image: "icon_add", width: 32.w, height: 32.w),
            ),
          ),
        ],
      ),
    ),
  );

  _centerWidget()=>Row(
    children: [
      SizedBox(width: 12.w,),
      InkWell(
        onTap: (){
          ftController.clickLeft();
        },
        child: LocalImageWidget(image: "icon_left", width: 28.w, height: 28.w),
      ),
      const Spacer(),
      GetBuilder<CardsController>(
        id: "center",
        builder: (_)=>Stack(
          alignment: Alignment.bottomCenter,
          children: [
            InkWell(
              onTap: (){
                ftController.test();
              },
              child: LocalImageWidget(image: ftController.homeList[ftController.chooseIndex].center, width: 234.w, height: 330.h),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 33.h),
              child: WinUpWidget(
                leftFontSize: 18.sp,
                rightFontSize: 24.sp,
                numTextColor: ftController.getWinUpColor(),
                winnerType: ftController.homeList[ftController.chooseIndex].winnerType,
              ),
            )
          ],
        ),
      ),
      const Spacer(),
      InkWell(
        onTap: (){
          ftController.clickRight();
        },
        child: LocalImageWidget(image: "icon_right", width: 28.w, height: 28.w),
      ),
      SizedBox(width: 12.w,),
    ],
  );

  _selListWidget()=>SizedBox(
    width: double.infinity,
    height: 88.h,
    child: GetBuilder<CardsController>(
      id: "sel_list",
      builder: (_)=>ListView.builder(
        itemCount: ftController.homeList.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context,index){
          var bean = ftController.homeList[index];
          return InkWell(
            onTap: (){
              ftController.clickItem(index);
            },
            child: Container(
              margin: EdgeInsets.only(left: 12.w),
              child: LocalImageWidget(image: index==ftController.chooseIndex?bean.sel:bean.uns, width: 68.w, height: 88.h),
            ),
          );
        },
      ),
    ),
  );

  _topWidget()=>Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(width: 16.w,),
      CoinsWidget(fromPlayDetail: false,fromHome: false,),
      SizedBox(width: 8.w,),
      DiamondWidget(),
      const Spacer(),
      InkWell(
        onTap: (){
          ftController.clickBox();
        },
        child: SizedBox(
          key: ftController.boxGlobalKey,
          child: BoxWidget(),
        ),
      ),
      SizedBox(width: 16.w,),
    ],
  );

  _boxFingerWidget()=>GetBuilder<CardsController>(
    id: "box_finger",
    builder: (_){
      var offset = ftController.boxFingerOffset;
      var x = (offset?.dx??0)+10.w;
      var y = (offset?.dy??0)+10.h;
      return Visibility(
        visible: null!=ftController.boxFingerOffset,
        child: Container(
          margin: EdgeInsets.only(left: x,top: y),
          child: InkWell(
            onTap: (){
              ftController.clickBox();
            },
            child: FingerWidget(),
          ),
        ),
      );
    },
  );

  _playFingerWidget()=>GetBuilder<CardsController>(
    id: "play_finger",
    builder: (_){
      var offset = ftController.playFingerOffset;
      var x = (offset?.dx??0)+120.w;
      var y = (offset?.dy??0)+42.h;
      return Visibility(
        visible: null!=ftController.playFingerOffset,
        child: Container(
          margin: EdgeInsets.only(left: x,top: y),
          child: InkWell(
            onTap: (){
              ftController.toPlay();
            },
            child: FingerWidget(),
          ),
        ),
      );
    },
  );
}