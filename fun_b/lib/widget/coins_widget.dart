import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fun_b/hep/user_info_hep.dart';
import 'package:fun_base/routers/routers_utils.dart';
import 'package:fun_base/util/event/event_code.dart';
import 'package:fun_base/util/event/event_data.dart';
import 'package:fun_base/util/util.dart';
import 'package:fun_base/widget/finger_widget.dart';
import 'package:fun_base/widget/local_image_widget.dart';
import 'package:fun_base/widget/text_widget.dart';

class CoinsWidget extends StatefulWidget{
  bool fromPlayDetail;
  bool fromHome;
  CoinsWidget({this.fromPlayDetail=true,this.fromHome=true});
  @override
  State<StatefulWidget> createState() => _CoinsWidgetState();
}

class _CoinsWidgetState extends State<CoinsWidget>{
  var showFinger=false;
  StreamSubscription<EventData>? _ss;

  @override
  void initState() {
    super.initState();
    _ss=eventBus.on<EventData>().listen((event) {
      switch(event.code){
        case EventCode.updateUserDiamondB:
          setState(() {});
          break;
        case EventCode.firstGetReward:
          if(widget.fromHome&&!showFinger){
            showFinger=true;
            setState(() {});
          }
          break;
      }
    });
  }
  @override
  Widget build(BuildContext context) => Stack(
    alignment: Alignment.topRight,
    children: [
      SizedBox(
        width:  162.w,
        height: 32.h,
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            Container(
              margin: EdgeInsets.only(left: 16.w,right: 16.w),
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  LocalImageWidget(image: "coins_bg", width: 140.w, height: 28.h),
                  Container(
                    margin: EdgeInsets.only(left: 20.w),
                    child: TextWidget(data: "\$${UserInfoHep.instance.getUserCoins()}", color: "#FFFFFF", size: 14.sp,fontWeight: FontWeight.bold,showShadows: true,),
                  ),
                ],
              ),
            ),
            LocalImageWidget(image: "icon_money", width: 36.w, height: 36.w),
            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: (){
                  _clickCash();
                },
                child: LocalImageWidget(image: "coins2", width: 56.w, height: 32.w),
              ),
            ),
          ],
        ),
      ),
      Container(
        margin: EdgeInsets.only(top: 20.h),
        child: Visibility(
          visible: showFinger,
          maintainAnimation: true,
          maintainState: true,
          maintainSize: true,
          child: InkWell(
            onTap: (){
              _clickCash();
            },
            child: FingerWidget(),
          ),
        ),
      ),
    ],
  );

  _clickCash(){
    if(widget.fromPlayDetail){
      RouterUtils.back();
    }
    EventData(code: EventCode.updateHomeIndex,intValue: 1).send();
  }

  @override
  void dispose() {
    super.dispose();
    _ss?.cancel();
  }
}