import 'package:flutter/material.dart';
import 'package:fun_b/dialog/normal_win/normal_win_controller.dart';
import 'package:fun_b/hep/game_config_hep.dart';
import 'package:fun_base/base/base_dialog.dart';
import 'package:fun_base/util/util.dart';
import 'package:fun_base/widget/local_image_widget.dart';
import 'package:fun_base/widget/text_widget.dart';

class NormalWinDialog extends BaseDialog<NormalWinController>{
  int reward;
  WinnerType winnerType;
  Function() dismiss;
  NormalWinDialog({
    required this.reward,
    required this.winnerType,
    required this.dismiss,
  });

  @override
  initView() {
    ftController.winnerType=winnerType;
  }

  @override
  NormalWinController createController() => NormalWinController();

  @override
  Widget createWidget() => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      _rewardWidget(),
      SizedBox(height: 12.h,),
      _btnWidget(),
    ],
  );

  _rewardWidget()=>SizedBox(
    width: 200.w,
    height: 266.h,
    child: Stack(
      children: [
        LocalImageWidget(image: "big5", width: 200.w, height: 266.h),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: EdgeInsets.only(bottom: 44.h),
            child: Stack(
              alignment: Alignment.center,
              children: [
                LocalImageWidget(image: "big3", width: 180.w, height: 44.h),
                TextWidget(data: "$reward", color: "#FFE32A", size: 24.sp,fontWeight: FontWeight.bold,)
              ],
            ),
          ),
        )
      ],
    ),
  );

  _btnWidget()=>Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      InkWell(
        onTap: (){
          ftController.clickDouble(reward,dismiss);
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            LocalImageWidget(image: "big4", width: 200.w, height: 58.h),
            TextWidget(data: "Claim Double", color: "#FFFFFF", size: 20.sp,fontWeight: FontWeight.bold,),
          ],
        ),
      ),
      InkWell(
        onTap: (){
          ftController.clickSingle(reward,dismiss);
        },
        child: TextWidget(data: "Claim", color: "#FFFFFF", size: 20.sp,fontWeight: FontWeight.bold,),
      )
    ],
  );
}