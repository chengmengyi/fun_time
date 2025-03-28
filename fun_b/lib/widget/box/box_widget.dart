import 'package:flutter/material.dart';
import 'package:fun_b/widget/box/box_controller.dart';
import 'package:fun_base/base/base_widget.dart';
import 'package:fun_base/util/util.dart';
import 'package:fun_base/widget/local_image_widget.dart';
import 'package:fun_base/widget/text_widget.dart';

class BoxWidget extends BaseWidget<BoxController>{

  @override
  BoxController createController() => BoxController();

  @override
  Widget createWidget() => GetBuilder<BoxController>(
    id: "time",
    builder: (_)=>Stack(
      alignment: Alignment.center,
      children: [
        InkWell(
          onTap: (){
            ftController.clickBox();
          },
          child: LocalImageWidget(image: ftController.countTime<=0?"icon_box":"icon_box2", width: 32.w, height: 32.w),
        ),
        Visibility(
          visible: ftController.countTime>0,
          child: TextWidget(data: "${ftController.countTime}s", color: "#FFFFFF", size: 12.sp,fontWeight: FontWeight.bold,),
        )
      ],
    ),
  );
}
