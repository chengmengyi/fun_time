import 'package:flutter/material.dart';
import 'package:fun_b/dialog/cash_success/cash_success_controller.dart';
import 'package:fun_b/hep/hep.dart';
import 'package:fun_base/base/base_dialog.dart';
import 'package:fun_base/routers/routers_utils.dart';
import 'package:fun_base/util/util.dart';
import 'package:fun_base/widget/local_image_widget.dart';
import 'package:fun_base/widget/text_widget.dart';

class CashSuccessDialog extends BaseDialog<CashSuccessController>{
  int cashType;
  int cashMoney;
  CashSuccessDialog({required this.cashType,required this.cashMoney});

  @override
  CashSuccessController createController() => CashSuccessController();
  @override
  Widget createWidget() => Container(
    width: double.infinity,
    height: 284.h,
    margin: EdgeInsets.only(left: 40.w,right: 40.w),
    child: Stack(
      alignment: Alignment.topCenter,
      children: [
        LocalImageWidget(image: "set1", width: double.infinity, height: 284.h),
        Positioned(
          top: 4.h,
          left: 16.w,
          child: TextWidget(data: "Withdrawal Successful ", color: "#FFFFFF", size: 16.sp,fontStyle: FontStyle.italic,fontWeight: FontWeight.bold,),
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
            _moneyWidget(),
            SizedBox(height: 12.h,),
            _btnWidget(),
          ],
        )
      ],
    ),
  );

  _moneyWidget()=>Container(
    width: double.infinity,
    height: 160.h,
    margin: EdgeInsets.only(top: 43.h,left: 10.w,right: 10.w),
    child: Stack(
      alignment: Alignment.center,
      children: [
        LocalImageWidget(image: "rank2", width: double.infinity, height: 144.h),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            LocalImageWidget(image: Hep.getCashTypeIcon(cashType), width: 108.w, height: 36.h),
            TextWidget(data: "\$$cashMoney", color: "#FFC718", size: 28.sp,fontWeight: FontWeight.bold,),
            Container(
              margin: EdgeInsets.only(left: 12.w,right: 12.w),
              child: TextWidget(
                data: "Your withdrawal amount has been issued and will arrive in 3-5 working days. Please check your account",
                color: "#7A7A7A",
                size: 12.sp,
                textAlign: TextAlign.center,
              ),
            )
          ],
        )
      ],
    ),
  );

  _btnWidget()=>InkWell(
    onTap: (){
      ftController.click(cashType,cashMoney);
    },
    child: SizedBox(
      width: 220.w,
      height: 38.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          LocalImageWidget(image: "rank3", width: double.infinity, height: 52.h),
          TextWidget(data: "I know", color: "#FFFFFF", size: 18.sp,fontWeight: FontWeight.bold,),
        ],
      ),
    ),
  );
}