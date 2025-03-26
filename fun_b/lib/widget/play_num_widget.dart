import 'package:flutter/material.dart';
import 'package:fun_b/dialog/add_chance/add_chance_dialog.dart';
import 'package:fun_b/hep/game_config_hep.dart';
import 'package:fun_b/hep/user_info_hep.dart';
import 'package:fun_base/routers/routers_utils.dart';
import 'package:fun_base/util/util.dart';
import 'package:fun_base/widget/local_image_widget.dart';
import 'package:fun_base/widget/text_widget.dart';

class PlayNumWidget extends StatelessWidget{
  WinnerType winnerType;
  PlayNumWidget({required this.winnerType});

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 164.w,
    child: Stack(
      alignment: Alignment.centerLeft,
      children: [
        Container(
          width: 132.w,
          height: 28.w,
          alignment: Alignment.center,
          margin: EdgeInsets.only(left: 16.w,right: 16.w),
          decoration: BoxDecoration(
              color: "#FFFFFF".toColor(),
              border: Border.all(
                width: 1.w,
                color: "#000000".toColor(),
              )
          ),
          child: TextWidget(data: "${UserInfoHep.instance.getPlayNum(winnerType)}", color: "#FFD84B", size: 20.sp,fontWeight: FontWeight.bold),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: InkWell(
            onTap: (){
              RouterUtils.dialog(widget: AddChanceDialog(winnerType: winnerType,));
            },
            child: LocalImageWidget(image: "icon_add", width: 32.w, height: 32.w),
          ),
        ),
      ],
    ),
  );

}