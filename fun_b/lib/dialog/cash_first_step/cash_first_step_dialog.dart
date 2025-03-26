import 'package:flutter/material.dart';
import 'package:fun_b/bean/cash_info_bean.dart';
import 'package:fun_b/dialog/cash_first_step/cash_first_step_controller.dart';
import 'package:fun_b/hep/hep.dart';
import 'package:fun_base/base/base_dialog.dart';
import 'package:fun_base/routers/routers_utils.dart';
import 'package:fun_base/util/util.dart';
import 'package:fun_base/widget/local_image_widget.dart';
import 'package:fun_base/widget/text_widget.dart';

class CashFirstStepDialog extends BaseDialog<CashFirstStepController>{
  int cashType;
  int cashMoney;
  CashInfoBean bean;
  CashFirstStepDialog({
    required this.cashType,
    required this.cashMoney,
    required this.bean,
  });

  @override
  CashFirstStepController createController() => CashFirstStepController();

  @override
  Widget createWidget() => Container(
    width: double.infinity,
    height: 328.h,
    margin: EdgeInsets.only(left: 40.w,right: 40.w),
    child: Stack(
      alignment: Alignment.topCenter,
      children: [
        LocalImageWidget(image: "first1", width: double.infinity, height: 458.h),
        Positioned(
          top: 6.h,
          left: 10.w,
          child: TextWidget(data: "Cash Out", color: "#FFFFFF", size: 20.sp,fontStyle: FontStyle.italic,fontWeight: FontWeight.bold,),
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
            _moneyWidget(),
            _progressWidget(),
            SizedBox(height: 20.h,),
            _btnWidget(),
          ],
        )
      ],
    ),
  );

  _moneyWidget()=>Container(
    width: double.infinity,
    height: 144.h,
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
                data: "Congratulations, You are in the withdrawal approval queue.",
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

  _progressWidget()=>Container(
    margin: EdgeInsets.only(top: 12.h,left: 28.w,right: 28.w),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextWidget(data: "Scratch 10 cards", color: "#FF3333", size: 14.sp,fontWeight: FontWeight.bold,),
        SizedBox(height: 10.h,),
        Stack(
          alignment: Alignment.center,
          children: [
            LayoutBuilder(
              builder: (context,bc){
                var maxWidth = bc.maxWidth;
                return Container(
                  width: double.infinity,
                  height:  12.h,
                  color: "#060832".toColor(),
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 2.w,right: 2.w),
                  child: Container(
                    width: (maxWidth-4.w)*ftController.getPro(bean),
                    height: 8.h,
                    color: "#FFD84B".toColor(),
                  ),
                );
              },
            ),
            TextWidget(data: "${bean.currentPro??0}/${bean.totalPro??0}", color: "#FFFFFF", size: 10.sp,fontWeight: FontWeight.bold,)
          ],
        )
      ],
    ),
  );

  _btnWidget()=>InkWell(
    onTap: (){
      ftController.click();
    },
    child: SizedBox(
      width: 220.w,
      height: 38.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          LocalImageWidget(image: "rank3", width: double.infinity, height: 52.h),
          TextWidget(data: "Cash Out", color: "#FFFFFF", size: 18.sp,fontWeight: FontWeight.bold,),
        ],
      ),
    ),
  );
}