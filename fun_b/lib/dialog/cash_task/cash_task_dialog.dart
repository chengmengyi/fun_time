import 'package:flutter/material.dart';
import 'package:fun_b/bean/cash_info_bean.dart';
import 'package:fun_b/dialog/cash_task/cash_task_controller.dart';
import 'package:fun_b/hep/cash_hep.dart';
import 'package:fun_base/base/base_dialog.dart';
import 'package:fun_base/util/tba_point/custom_point.dart';
import 'package:fun_base/util/tba_point/tab_point_hep.dart';
import 'package:fun_base/util/util.dart';
import 'package:fun_base/widget/local_image_widget.dart';
import 'package:fun_base/widget/text_widget.dart';

class CashTaskDialog extends BaseDialog<CashTaskController>{
  CashInfoBean bean;
  CashTaskDialog({required this.bean});

  @override
  initView() {
    var tixianTask = CashHep.instance.getConfigTaskByIndex(bean.taskIndex??0);
    if(null!=tixianTask){
      TbaPointHep.instance.pointEvent(CustomId.one_last_step_pop,params: {"pop_from":tixianTask.title});
    }
  }

  @override
  CashTaskController createController() => CashTaskController();

  @override
  Widget createWidget() => Container(
    width: double.infinity,
    padding: EdgeInsets.all(16.w),
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
        TextWidget(
          data: "Only one step left to speed up withdrawal",
          color: "#000000",
          size: 16.sp,
          fontWeight: FontWeight.bold,
          textAlign: TextAlign.center,
        ),
        TextWidget(data: "\$${bean.cashMoney}", color: "#FFC718", size: 28.sp,fontWeight: FontWeight.bold,),
        _taskWidget(),
        SizedBox(height: 16.h,),
        _btnWidget(),
      ],
    ),
  );

  _taskWidget()=>Container(
    width: double.infinity,
    color: "#F0F0F0".toColor(),
    padding: EdgeInsets.all(12.w),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        LocalImageWidget(image: ftController.getTaskIcon(bean), width: 100.w, height: 100.h),
        SizedBox(height: 8.h,),
        TextWidget(data: ftController.getTaskStr(bean), color: "#000000", size: 12.sp,fontWeight: FontWeight.bold,),
        TextWidget(data: "${bean.currentPro??0}/${bean.totalPro??0}", color: "#FF3333", size: 14.sp,fontWeight: FontWeight.bold),
      ],
    ),
  );

  _btnWidget()=>InkWell(
    onTap: (){
      ftController.clickGo(bean);
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
      child: TextWidget(data: "Go", color: "#FFFFFF", size: 16.sp,fontWeight: FontWeight.bold
        ,),
    ),
  );
}