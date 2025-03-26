import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fun_b/hep/cash_hep.dart';
import 'package:fun_b/hep/user_info_hep.dart';
import 'package:fun_base/util/ad_hep.dart';
import 'package:fun_base/util/tba_point/ad_point.dart';
import 'package:fun_base/util/tba_point/custom_point.dart';
import 'package:fun_base/util/tba_point/tab_point_hep.dart';
import 'package:fun_base/util/util.dart';
import 'package:fun_base/widget/local_image_widget.dart';
import 'package:fun_base/widget/text_widget.dart';

class PopsWidget extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _PopsWidgetState();
}

class _PopsWidgetState extends State<PopsWidget>{
  var maxWidth=0.0,maxHeight=0.0,startRight=true,startDown=true,top=0.0,left=0.0,showBubble=true;
  GlobalKey globalKey=GlobalKey();
  Timer? _timer;
  double addNum=CashHep.instance.getFloatAddNum();

  @override
  void initState() {
    super.initState();
    Future((){
      _initTimer();
    });
  }
  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    height: double.infinity,
    key: globalKey,
    child: Stack(
      children: [
        Positioned(
          top: top,
          left: left,
          child: InkWell(
            onTap: (){
              clickFloat();
            },
            child: SizedBox(
              width: 80.w,
              height: 80.w,
              child: Stack(
                children: [
                  LocalImageWidget(image: "pop1", width: 80.w, height: 80.w),
                  Align(
                    alignment: Alignment.topLeft,
                    child: LocalImageWidget(image: "pop2", width: 18.w, height: 18.w),
                  ),
                  Align(
                    child: LocalImageWidget(image: "icon_money", width: 56.w, height: 56.w),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: TextWidget(data: "\$$addNum", color: "#FFD725", size: 18.sp,fontWeight: FontWeight.bold,),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    ),
  );


  _initTimer(){
    var renderBox = globalKey.currentContext!.findRenderObject() as RenderBox;
    var size = renderBox.size;
    maxWidth=size.width-80.w;
    maxHeight=size.height-80.w;
    _timer=Timer.periodic(const Duration(milliseconds: 10), (timer) {
      if(startRight){
        left++;
        if(startDown){
          top++;
          if(top>=maxHeight){
            startDown=false;
          }
        }else{
          top--;
          if(top<=0){
            startDown=true;
          }
        }
        if(left>=maxWidth){
          startRight=false;
        }
      }else{
        left--;
        if(startDown){
          top++;
          if(top>=maxHeight){
            startDown=false;
          }
        }else{
          top--;
          if(top<=0){
            startDown=true;
          }
        }
        if(left<=0){
          startRight=true;
        }
      }
      setState(() { });
    });
  }

  clickFloat(){
    TbaPointHep.instance.pointEvent(CustomId.float_c);
    AdHep.instance.showAd(
      adType: AdType.reward,
      adPosId: AdPosId.sqftm_bubble_rv,
      showIntAd: CashHep.instance.checkShowIntAd(AdType.reward),
      closeAd: (){
        UserInfoHep.instance.updateUserCoins(addNum);
        addNum=CashHep.instance.getFloatAddNum();
        setState(() { });
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer=null;
    super.dispose();

  }
}