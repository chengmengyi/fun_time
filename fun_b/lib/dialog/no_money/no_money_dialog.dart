import 'package:flutter/material.dart';
import 'package:fun_b/dialog/no_money/no_money_controller.dart';
import 'package:fun_b/hep/user_info_hep.dart';
import 'package:fun_base/base/base_dialog.dart';
import 'package:fun_base/util/util.dart';
import 'package:fun_base/widget/text_widget.dart';

class NoMoneyDialog extends BaseDialog<NoMoneyController>{
  int money;
  NoMoneyDialog({required this.money});

  @override
  NoMoneyController createController() => NoMoneyController();

  @override
  Widget createWidget() => Container(
    width: double.infinity,
    margin: EdgeInsets.only(left: 40.w,right: 40.w),
    decoration: BoxDecoration(
      color: "#FFFFFF".toColor(),
      border: Border.all(
        width: 1.w,
        color: "#000000".toColor(),
      )
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 16.h,),
        TextWidget(data: "Cash Out", color: "#000000", size: 20.sp,fontWeight: FontWeight.bold,),
        SizedBox(height: 16.h,),
        Container(
          margin: EdgeInsets.only(left: 20.w,right: 20.w),
          child: RichText(
            text: TextSpan(
              children: [
                //Your current balance is $100,Collect $200 and you can withdraw cash!Go and Get more Cash!
                TextSpan(
                  text: "Your current balance is ",
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: "#000000".toColor(),
                  )
                ),
                TextSpan(
                    text: "\$${UserInfoHep.instance.getUserCoins()}",
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: "#FF3333".toColor(),
                    )
                ),
                TextSpan(
                    text: ",Collect ",
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: "#000000".toColor(),
                    )
                ),
                TextSpan(
                    text: "\$$money",
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: "#FF3333".toColor(),
                    )
                ),
                TextSpan(
                    text: " and you can withdraw cash!Go and Get more Cash!",
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: "#000000".toColor(),
                    )
                ),
              ]
            ),
          ),
        ),
        SizedBox(height: 16.h,),
        InkWell(
          onTap: (){
            ftController.click();
          },
          child: Container(
            width: double.infinity,
            height: 40.h,
            alignment: Alignment.center,
            margin: EdgeInsets.only(left: 30.w,right: 30.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: ["#F46C00".toColor(),"#FFD524".toColor()],
              ),
              border: Border.all(
                width: 1.w,
                color: "#000000".toColor(),
              )
            ),
            child: TextWidget(data: "Get More Cash", color: "#FFFFFF", size: 16.sp,fontWeight: FontWeight.bold
              ,),
          ),
        ),
        SizedBox(height: 16.h,),
      ],
    ),
  );
}