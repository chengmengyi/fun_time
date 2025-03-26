import 'package:flutter/material.dart';
import 'package:fun_base/util/util.dart';
import 'package:fun_base/widget/local_image_widget.dart';
import 'package:fun_base/widget/text_widget.dart';

class WatchVideoWidget extends StatelessWidget{
  String btnStr;
  Function() click;
  WatchVideoWidget({
    required this.btnStr,
    required this.click,
});

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: (){
      click.call();
    },
    child: SizedBox(
      width: 240.w,
      height: 52.h,
      child: Stack(
        children: [
          LocalImageWidget(image: "watch1", width: double.infinity, height: 52.h),
          Align(
            child: TextWidget(
              data: btnStr,
              color: "#FFFFFF",
              size: 18.sp,
              fontWeight: FontWeight.bold,
              showShadows: true,
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: EdgeInsets.only(left: 21.w),
              child: LocalImageWidget(image: "icon_video", width: 18.w, height: 18.w),
            ),
          )
        ],
      ),
    ),
  );
}