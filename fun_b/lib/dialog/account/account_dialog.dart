import 'package:flutter/material.dart';
import 'package:fun_b/dialog/account/account_controller.dart';
import 'package:fun_b/hep/hep.dart';
import 'package:fun_base/base/base_dialog.dart';
import 'package:fun_base/routers/routers_utils.dart';
import 'package:fun_base/util/util.dart';
import 'package:fun_base/widget/local_image_widget.dart';
import 'package:fun_base/widget/text_widget.dart';

class AccountDialog extends BaseDialog<AccountController>{
  int cashMoney;
  AccountDialog({required this.cashMoney});

  @override
  AccountController createController() => AccountController();

  @override
  bool hideKeyboard() => true;

  @override
  Widget createWidget() => Container(
    width: double.infinity,
    height: 248.h,
    margin: EdgeInsets.only(left: 40.w,right: 40.w),
    child: Stack(
      alignment: Alignment.topCenter,
      children: [
        LocalImageWidget(image: "set1", width: double.infinity, height: 284.h),
        Positioned(
          top: 4.h,
          left: 16.w,
          child: TextWidget(data: "Cash Out", color: "#FFFFFF", size: 24.sp,fontStyle: FontStyle.italic,fontWeight: FontWeight.bold,),
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
            SizedBox(height: 53.h,),
            LocalImageWidget(image: Hep.getCashTypeIcon(ftController.cashType), width: 108.w, height: 36.h),
            // _cashTypeListWidget(),
            SizedBox(height: 22.h,),
            _inputWidget(),
            SizedBox(height: 30.h,),
            _btnWidget(),
          ],
        )
      ],
    ),
  );

  // _cashTypeListWidget()=>Container(
  //   width: double.infinity,
  //   height: 36.h,
  //   margin: EdgeInsets.only(left: 16.w,right: 16.w),
  //   child: ListView.builder(
  //     itemCount: ftController.cashTypeList.length,
  //     scrollDirection: Axis.horizontal,
  //     itemBuilder: (context,index){
  //       var bean = ftController.cashTypeList[index];
  //       return Container(
  //         margin: EdgeInsets.only(left: 5.w,right: 5.w),
  //         child: LocalImageWidget(image: ftController.cashType==index?bean.selIcon:bean.unsIcon, width: 108.w, height: 36.h),
  //       );
  //     },
  //   ),
  // );

  _inputWidget()=>Container(
    width: double.infinity,
    height: 40.h,
    alignment: Alignment.center,
    margin: EdgeInsets.only(left: 20.w,right: 20.w),
    decoration: BoxDecoration(
      color: "#F4F4F4".toColor(),
      border: Border.all(
        width: 1.w,
        color: "#000000".toColor(),
      )
    ),
    child: TextField(
      enabled: true,
      maxLength: 20,
      textAlign: TextAlign.center,
      controller: ftController.textEditingController,
      keyboardType: TextInputType.number,
      style: TextStyle(
        fontSize: 14.sp,
        color: "#000000".toColor(),
        fontWeight: FontWeight.bold,
      ),
      decoration: InputDecoration(
        counterText: '',
        isCollapsed: true,
        hintText: ' Please input your account ID',
        hintStyle: TextStyle(
          fontSize: 14.sp,
          color: "#A3A3A3".toColor(),
        ),
        border: InputBorder.none,
      ),
      onChanged: (v){
        ftController.onChanged(v);
      },
    ),
  );

  _btnWidget()=>GetBuilder<AccountController>(
    id: "btn",
    builder: (_)=>InkWell(
      onTap: (){
        ftController.clickBtn(cashMoney);
      },
      child: Container(
        width: double.infinity,
        height: 40.h,
        margin: EdgeInsets.only(left: 22.w,right: 22.w),
        child: Stack(
          alignment: Alignment.center,
          children: [
            LocalImageWidget(image: ftController.hasContent?"account2":"account1", width: double.infinity, height: 40.h,),
            TextWidget(data: "Submit", color: ftController.hasContent?"#FFFFFF":"#000000", size: 18.sp,fontWeight: FontWeight.bold,)
          ],
        ),
      ),
    ),
  );
}