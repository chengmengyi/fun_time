import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class H5Hep{
  static final H5Hep _instance = H5Hep();
  static H5Hep get instance => _instance;

  static const MethodChannel _funTimeChannel = MethodChannel('com.scratch.funtime.pro.h5');
  initChannel(BuildContext context){
    _funTimeChannel.setMethodCallHandler((MethodCall call) async {
      if (call.method == 'funtime_h5_method') {
        var data = call.arguments;
        if (data != null) {
          double? quizX = double.tryParse('${data['quizX']}');
          double? quizY = double.tryParse('${data['quizY']}');
          if (quizX != null && quizY != null) {
            Offset flutterCoordinates = Offset(quizX, quizY);
            RenderBox? renderBox = context.findRenderObject() as RenderBox?;
            BoxHitTestResult hitTestResult = BoxHitTestResult();
            renderBox?.hitTest(hitTestResult, position: flutterCoordinates);
            if (hitTestResult.path.isNotEmpty) {
              GestureBinding.instance.handlePointerEvent(
                  PointerAddedEvent(pointer: 0, position: flutterCoordinates));
              GestureBinding.instance.handlePointerEvent(
                  PointerDownEvent(pointer: 0, position: flutterCoordinates));
              GestureBinding.instance.handlePointerEvent(
                  PointerUpEvent(pointer: 0, position: flutterCoordinates));
            } else {
            }
          }
        }
      }
    });
  }

  /// 2.进入A面时就调用（只调用一次）
  Future<void> methodA() async {
    _funTimeChannel.invokeMethod('methodA');
  }
  /// 3.进入B面时就调用（只调用一次）
  Future<void> methodB1() async {
    _funTimeChannel.invokeMethod('methodB1');
  }
  /// 4.进入B面时就调用（只调用一次）
  Future<void> methodB2() async {
    _funTimeChannel.invokeMethod('methodB2');
  }
  /// 5.点击项目右上角打开web游戏调用（只调用一次）
  Future<void> clickH5() async {
    _funTimeChannel.invokeMethod('clickH5');
  }
}