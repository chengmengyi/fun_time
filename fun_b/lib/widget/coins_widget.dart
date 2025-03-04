import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fun_b/hep/user_info_hep.dart';
import 'package:fun_base/util/event/event_code.dart';
import 'package:fun_base/util/event/event_data.dart';
import 'package:fun_base/util/util.dart';
import 'package:fun_base/widget/local_image_widget.dart';
import 'package:fun_base/widget/text_widget.dart';

class CoinsWidget extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _CoinsWidgetState();
}

class _CoinsWidgetState extends State<CoinsWidget>{
  StreamSubscription<EventData>? _ss;

  @override
  void initState() {
    super.initState();
    _ss=eventBus.on<EventData>().listen((event) {
      if(event.code==EventCode.updateUserCoinsA){
        setState(() {});
      }
    });
  }
  @override
  Widget build(BuildContext context) => SizedBox(
    width:  162.w,
    height: 32.h,
    child: Stack(
      alignment: Alignment.centerLeft,
      children: [
        Container(
          margin: EdgeInsets.only(left: 16.w,right: 16.w),
          child: Stack(
            alignment: Alignment.center,
            children: [
              LocalImageWidget(image: "coins_bg", width: 140.w, height: 28.h),
              TextWidget(data: "${UserInfoHep.instance.getUserCoins()}", color: "#FFFFFF", size: 18.sp,fontWeight: FontWeight.bold,),
            ],
          ),
        ),
        LocalImageWidget(image: "icon_money", width: 36.w, height: 36.w),
        Align(
          alignment: Alignment.centerRight,
          child: LocalImageWidget(image: "coins2", width: 56.w, height: 32.w),
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