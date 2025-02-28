import 'package:flutter/material.dart';
import 'package:fun_a/dialog/set/set_controller.dart';
import 'package:fun_base/base/base_dialog.dart';
import 'package:fun_base/routers/routers_utils.dart';
import 'package:fun_base/util/util.dart';
import 'package:fun_base/util/voice_player.dart';
import 'package:fun_base/widget/local_image_widget.dart';
import 'package:fun_base/widget/text_widget.dart';

class SetDialog extends BaseDialog<SetController>{
  @override
  SetController createController() => SetController();

  @override
  Widget createWidget() => Container(
    width: double.infinity,
    height: 284.h,
    margin: EdgeInsets.only(left: 40.w,right: 40.w),
    child: Stack(
      alignment: Alignment.bottomCenter,
      children: [
        LocalImageWidget(image: "set1", width: double.infinity, height: 284.h),
        Positioned(
          top: 4.h,
          left: 16.w,
          child: TextWidget(data: "Setting", color: "#FFFFFF", size: 24.sp,fontStyle: FontStyle.italic,fontWeight: FontWeight.bold,),
        ),
        Positioned(
          top: 0,
          right: 8.w,
          child: InkWell(
            onTap: (){
              RouterUtils.back();
            },
            child: LocalImageWidget(image: "icon_close", width: 28.w, height: 28.h),
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GetBuilder<SetController>(
                  id: "bg",
                  builder: (_)=>InkWell(
                    onTap: (){
                      ftController.clickBg();
                    },
                    child: LocalImageWidget(image: playBgStorage.getData()?"bg_open":"bg_close", width: 88.w, height: 88.h),
                  ),
                ),
                SizedBox(width: 10.w,),
                GetBuilder<SetController>(
                  id: "gk",
                  builder: (_)=>InkWell(
                    onTap: (){
                      ftController.clickGk();
                    },
                    child: LocalImageWidget(image: playGkStorage.getData()?"gk_open":"gk_close", width: 88.w, height: 88.h),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h,),
            InkWell(
              onTap: (){
                ftController.toWeb();
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  LocalImageWidget(image: "set2", width: 220.w, height: 38.h),
                  TextWidget(data: "Privacy Policy", color: "#000000", size: 18.sp,fontWeight: FontWeight.bold,)
                ],
              ),
            ),
            SizedBox(height: 12.h,),
            InkWell(
              onTap: (){
                ftController.toEmail();
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  LocalImageWidget(image: "set2", width: 220.w, height: 38.h),
                  TextWidget(data: "Contact Us", color: "#000000", size: 18.sp,fontWeight: FontWeight.bold,)
                ],
              ),
            ),
            SizedBox(height: 18.h,)
          ],
        )
      ],
    ),
  );
}