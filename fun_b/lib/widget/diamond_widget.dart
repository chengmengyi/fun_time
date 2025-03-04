import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fun_b/dialog/up_level/up_level_dialog.dart';
import 'package:fun_b/hep/storage/storage_bean.dart';
import 'package:fun_b/hep/user_info_hep.dart';
import 'package:fun_base/routers/routers_utils.dart';
import 'package:fun_base/util/event/event_code.dart';
import 'package:fun_base/util/event/event_data.dart';
import 'package:fun_base/util/util.dart';
import 'package:fun_base/widget/finger_widget.dart';
import 'package:fun_base/widget/local_image_widget.dart';
import 'package:fun_base/widget/text_widget.dart';

class DiamondWidget extends StatefulWidget{
  GlobalKey? globalKey;
  DiamondWidget({this.globalKey});

  @override
  State<StatefulWidget> createState() => _DiamondWidgetState();
}

class _DiamondWidgetState extends State<DiamondWidget>{
  var showFinger=false;
  StreamSubscription<EventData>? _ss;

  @override
  void initState() {
    super.initState();
    showFinger=showLevelFinger.get();
    _ss=eventBus.on<EventData>().listen((event) {
      switch(event.code){
        case EventCode.updateUserDiamondA:
          setState(() {});
          break;
        case EventCode.showLevelFingerA:
          if(!showFinger){
            showFinger=true;
            showLevelFinger.save(true);
            setState(() {});
          }
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: (){
      RouterUtils.dialog(
        widget: UpLevelDialog(
          showFinger: showFinger,
          dismiss: (){
            showFinger=false;
            showLevelFinger.save(false);
            setState(() {});
          },
        ),
      );
    },
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            LocalImageWidget(image: "icon_level", width: 32.w, height: 32.w),
            TextWidget(data: "${UserInfoHep.instance.getUserDiamond()~/3}", color: "#FFE227", size: 14.sp,fontWeight: FontWeight.bold,)
          ],
        ),
        Container(
          width: 32.w,
          height: 8.h,
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 2.w,right: 2.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: ["#4D55BB".toColor(),"#262E97".toColor()]
            ),
            border: Border.all(
              width: 1.w,
              color: "#000000".toColor(),
            )
          ),
          child: Container(
            width: 10.w,
            height: 4.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: ["#FFC73A".toColor(),"#FF9D00".toColor()]
              ),
            ),
          ),
        )
      ],
    ),
  );

  @override
  void dispose() {
    super.dispose();
    _ss?.cancel();
  }
}