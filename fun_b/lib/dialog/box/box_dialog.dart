import 'package:flutter/material.dart';
import 'package:fun_b/dialog/box/box_dialog_controller.dart';
import 'package:fun_b/widget/watch_video_widget.dart';
import 'package:fun_base/base/base_dialog.dart';
import 'package:fun_base/routers/routers_utils.dart';
import 'package:fun_base/util/util.dart';
import 'package:fun_base/widget/local_image_widget.dart';
import 'package:fun_base/widget/lottie_widget.dart';
import 'package:fun_base/widget/text_widget.dart';

class BoxDialog extends BaseDialog<BoxDialogController>{
  Function(bool received) dismiss;
  BoxDialog({
    required this.dismiss,
});
  @override
  BoxDialogController createController() => BoxDialogController();

  @override
  Widget createWidget() => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      LocalImageWidget(image: "box1", width: 233.w, height: 40.h),
      Stack(
        alignment: Alignment.center,
        children: [
          LocalImageWidget(image: "guang", width: 280.w, height: 280.w),
          LottieWidget(
            name: "xiangzi",
            ext: "json",
            width: 180.w,
            height: 180.w,
            repeat: false,
            controller: ftController.moneyLottieController,
          ),
        ],
      ),
      GetBuilder<BoxDialogController>(
        id: "info",
        builder: (_)=>Visibility(
          visible: ftController.showInfo,
          maintainAnimation: true,
          maintainState: true,
          maintainSize: true,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextWidget(data: "\$${ftController.addNum}", color: "#FFE32A", size: 36.sp,fontWeight: FontWeight.bold,),
              WatchVideoWidget(
                btnStr: "Claim Now",
                click: (){
                  ftController.clickDouble(dismiss);
                },
              ),
              InkWell(
                onTap: (){
                  ftController.clickGiveUp(dismiss);
                },
                child: TextWidget(data: "Give Up", color: "#FFFFFF", size: 18.sp,fontWeight: FontWeight.bold, showShadows: true,),
              )
            ],
          ),
        ),
      )
    ],
  );
}