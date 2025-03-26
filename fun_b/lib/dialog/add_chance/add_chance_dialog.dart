import 'package:flutter/material.dart';
import 'package:fun_b/dialog/add_chance/add_chance_controller.dart';
import 'package:fun_b/hep/game_config_hep.dart';
import 'package:fun_base/base/base_dialog.dart';
import 'package:fun_base/routers/routers_utils.dart';
import 'package:fun_base/util/util.dart';
import 'package:fun_base/widget/local_image_widget.dart';
import 'package:fun_base/widget/text_widget.dart';

class AddChanceDialog extends BaseDialog<AddChanceController>{
  WinnerType winnerType;
  AddChanceDialog({required this.winnerType});

  @override
  AddChanceController createController() => AddChanceController();

  @override
  Widget createWidget() => Container(
    width: double.infinity,
    margin: EdgeInsets.only(left: 40.w,right: 40.w),
    child: SizedBox(
      width: double.infinity,
      height: 260.h,
      child: Stack(
        children: [
          LocalImageWidget(image: "add1", width: double.infinity, height: 260.h),
          Positioned(
            top: 5.h,
            left: 12.w,
            child: TextWidget(data: "More Cards", color: "#FFFFFF", size: 24.sp,fontWeight: FontWeight.bold,),
          ),
          Positioned(
            right: 10.w,
            child: InkWell(
              onTap: (){
                RouterUtils.back();
              },
              child: LocalImageWidget(image: "icon_close", width: 28.w, height: 28.w),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: EdgeInsets.only(top: 56.h),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  LocalImageWidget(image: "add2", width: 84.w, height: 84.w),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      LocalImageWidget(image: "add3", width: 64.w, height: 64.w),
                      TextWidget(data: "x1", color: "#FFFFFF", size: 24.sp,fontWeight: FontWeight.bold,)
                    ],
                  )
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: InkWell(
              onTap: (){
                ftController.clickVideo(winnerType);
              },
              child: Container(
                width: 160.w,
                height: 40.h,
                margin: EdgeInsets.only(bottom: 16.h),
                child: Stack(
                  children: [
                    LocalImageWidget(image: "add4", width: double.infinity, height: 40.h),
                    Align(
                      child: TextWidget(data: "GET", color: "#FFFFFF", size: 18.sp,fontWeight: FontWeight.bold,showShadows: true,),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.only(left: 10.w),
                        child: LocalImageWidget(image: "icon_video", width: 18.w, height: 18.w),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    ),
  );
}