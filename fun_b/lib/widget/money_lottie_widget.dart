import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fun_base/util/event/event_code.dart';
import 'package:fun_base/util/event/event_data.dart';
import 'package:fun_base/widget/lottie_widget.dart';

class MoneyLottieWidget extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _MoneyLottieWidgetState();
}

class _MoneyLottieWidgetState extends State<MoneyLottieWidget> with TickerProviderStateMixin{
  var showMoneyLottie=false;
  late AnimationController moneyLottieController;
  late StreamSubscription<EventData>? _ss;

  @override
  void initState() {
    super.initState();
    moneyLottieController=AnimationController(vsync: this,duration: const Duration(milliseconds: 800))..addStatusListener((status) {
      if(status==AnimationStatus.completed){
        showMoneyLottie=false;
        setState(() {});
        EventData(code: EventCode.updateUserCoinsB).send();
      }
    });
    _ss=eventBus.on<EventData>().listen((event) {
      if(event.code==EventCode.showMoneyLottie){
        showMoneyLottie=true;
        moneyLottieController..reset()..forward();
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) => Visibility(
    visible: showMoneyLottie,
    child: LottieWidget(name: "money", ext: "json",repeat: false,controller: moneyLottieController,),
  );

  @override
  void dispose() {
    moneyLottieController.dispose();
    _ss?.cancel();
    super.dispose();
  }
}