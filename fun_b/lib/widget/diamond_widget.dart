import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fun_b/dialog/up_level/up_level_dialog.dart';
import 'package:fun_b/hep/storage/storage_bean.dart';
import 'package:fun_b/hep/user_info_hep.dart';
import 'package:fun_base/routers/b_routers_name.dart';
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
    showFinger=showLevelFinger.getData();
    _ss=eventBus.on<EventData>().listen((event) {
      switch(event.code){
        case EventCode.updateUserDiamondB:
          setState(() {});
          break;
        case EventCode.showLevelFingerB:
          if(!showFinger){
            showFinger=true;
            showLevelFinger.saveData(true);
            setState(() {});
          }
          break;
        case EventCode.hideLevelFinger:
          showFinger=false;
          showLevelFinger.saveData(false);
          setState(() {});
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: (){
      EventData(code: EventCode.hideLevelFinger).send();
      RouterUtils.toNamed(routersName: BRoutersName.level);
    },
    child: Stack(
      children: [
        Stack(
          alignment: Alignment.centerLeft,
          children: [
            Container(
              height: 28.h,
              margin: EdgeInsets.only(left: 16.w),
              padding: EdgeInsets.only(right: 10.w),
              decoration: const BoxDecoration(
                image: DecorationImage(image: AssetImage("ft_resource/image/diamond_bg1.webp"),fit: BoxFit.fill),
              ),
              child: Container(
                padding: EdgeInsets.only(left: 20.w,right: 20.w),
                decoration: const BoxDecoration(
                  image: DecorationImage(image: AssetImage("ft_resource/image/diamond_bg2.webp"),),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextWidget(data: "${UserInfoHep.instance.getUserDiamond()%3}/3", color: "#FFFFFF", size: 16.sp,fontWeight: FontWeight.bold,showShadows: true,),
                    SizedBox(width: 2.w,),
                    SizedBox(
                      key: widget.globalKey,
                      child: LocalImageWidget(image: "icon_diamond", width: 20.w, height: 20.w),
                    ),
                  ],
                ),
              ),
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                LocalImageWidget(image: "icon_level", width: 32.w, height: 32.w),
                TextWidget(data: "${UserInfoHep.instance.getUserDiamond()~/3}", color: "#FFE227", size: 14.sp,fontWeight: FontWeight.bold,showShadows: true,)
              ],
            ),
          ],
        ),
        Container(
          margin: EdgeInsets.only(left: 40.w,top: 20.h),
          child: Visibility(
            visible: showFinger,
            maintainAnimation: true,
            maintainState: true,
            maintainSize: true,
            child: FingerWidget(),
          ),
        ),
      ],
    ),
  );

  @override
  void dispose() {
    super.dispose();
    _ss?.cancel();
  }
}