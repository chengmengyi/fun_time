import 'package:flutter/material.dart';
import 'package:fun_b/dialog/comment/comment_success/comment_success_controller.dart';
import 'package:fun_base/base/base_dialog.dart';
import 'package:fun_base/routers/routers_utils.dart';
import 'package:fun_base/util/util.dart';
import 'package:fun_base/widget/local_image_widget.dart';
import 'package:fun_base/widget/text_widget.dart';

class CommentSuccessDialog extends BaseDialog<CommentSuccessController>{
  @override
  CommentSuccessController createController() => CommentSuccessController();

  @override
  Widget createWidget() => Container(
    width: double.infinity,
    height: 248.h,
    margin: EdgeInsets.only(left: 40.w,right: 40.w),
    child: Stack(
      alignment: Alignment.center,
      children: [
        LocalImageWidget(image: "set1", width: double.infinity, height: 248.h),
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
            LocalImageWidget(image: "success1", width: 88.w, height: 88.w),
            SizedBox(height: 12.h,),
            TextWidget(data: "Thanks For Your Feedback", color: "#000000", size: 14.sp,fontWeight: FontWeight.bold,),
            SizedBox(height: 12.h,),
            InkWell(
              onTap: (){
                RouterUtils.back();
              },
              child: SizedBox(
                width: 220.w,
                height: 38.h,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    LocalImageWidget(image: "rank3", width: double.infinity, height: 52.h),
                    TextWidget(data: "OK", color: "#FFFFFF", size: 18.sp,fontWeight: FontWeight.bold,),
                  ],
                ),
              ),
            )
          ],
        )
      ],
    ),
  );
}