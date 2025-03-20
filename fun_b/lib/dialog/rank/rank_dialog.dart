import 'package:flutter/material.dart';
import 'package:fun_b/dialog/rank/rank_controller.dart';
import 'package:fun_base/base/base_dialog.dart';
import 'package:fun_base/routers/routers_utils.dart';
import 'package:fun_base/util/util.dart';
import 'package:fun_base/widget/local_image_widget.dart';
import 'package:fun_base/widget/text_widget.dart';

class RankDialog extends BaseDialog<RankController>{
  @override
  RankController createController() => RankController();

  @override
  Widget createWidget() => Container(
    width: double.infinity,
    height: 458.h,
    margin: EdgeInsets.only(left: 40.w,right: 40.w),
    child: Stack(
      alignment: Alignment.bottomCenter,
      children: [
        LocalImageWidget(image: "rank1", width: double.infinity, height: 458.h),
        Positioned(
          top: 4.h,
          left: 16.w,
          child: TextWidget(data: "Withdrawal approval ", color: "#FFFFFF", size: 24.sp,fontStyle: FontStyle.italic,fontWeight: FontWeight.bold,),
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
          children: [

          ],
        )
      ],
    ),
  );
}