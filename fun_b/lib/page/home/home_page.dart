import 'package:flutter/material.dart';
import 'package:fun_b/bean/home_bottom_bean.dart';
import 'package:fun_b/page/home/home_controller.dart';
import 'package:fun_base/base/base_widget.dart';
import 'package:fun_base/util/util.dart';
import 'package:fun_base/widget/finger_widget.dart';
import 'package:fun_base/widget/local_image_widget.dart';
import 'package:fun_base/widget/text_widget.dart';

class HomePage extends BaseWidget<BHomeController>{
  @override
  BHomeController createController() => BHomeController();

  @override
  Widget createWidget() => Scaffold(
    body: GetBuilder<BHomeController>(
      id: "page",
      builder: (_)=>Stack(
        children: [
          IndexedStack(
            index: ftController.chooseIndex,
            children: ftController.pageList,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _bottomWidget(),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: _cashFingerWidget(),
          ),
        ],
      ),
    ),
    resizeToAvoidBottomInset: false,
  );

  _bottomWidget()=>SizedBox(
    width: double.infinity,
    height: 88.w,
    child: Stack(
      alignment: Alignment.bottomCenter,
      children: [
        LocalImageWidget(image: "home_bottom_bg", width: double.infinity, height: double.infinity),
        Row(
          children: [
            Expanded(child: _bottomItemWidget(ftController.list.first,0)),
            Expanded(child: _bottomItemWidget(ftController.list.last,1)),
          ],
        )
      ],
    ),
  );

  _bottomItemWidget(HomeBottomBean bean,index)=>Container(
    width: double.infinity,
    height: 88.h,
    alignment: Alignment.bottomCenter,
    child: InkWell(
      onTap: (){
        ftController.clickBottom(index);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LocalImageWidget(image: ftController.chooseIndex==index?bean.sel:bean.uns, width: 36.w, height: 36.w),
          TextWidget(data: bean.text, color: ftController.chooseIndex==index?"#FFDC16":"#8FAAFF", size: 14.sp,fontWeight: FontWeight.bold,),
          SizedBox(height: 6.h,)
        ],
      ),
    ),
  );

  _cashFingerWidget()=>GetBuilder<BHomeController>(
    id: "cash_finger",
    builder: (_){
      return Visibility(
        visible: ftController.showCashFinger,
        child: Container(
          margin: EdgeInsets.only(right: 60.w),
          child: InkWell(
            onTap: (){
              ftController.clickBottom(1);
            },
            child: FingerWidget(),
          ),
        ),
      );
    },
  );
}