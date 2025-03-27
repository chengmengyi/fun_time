import 'package:flutter/material.dart';
import 'package:fun_b/hep/user_info_hep.dart';
import 'package:fun_b/page/home/cash/cash_controller.dart';
import 'package:fun_base/base/base_widget.dart';
import 'package:fun_base/util/util.dart';
import 'package:fun_base/widget/local_image_widget.dart';
import 'package:fun_base/widget/text_widget.dart';

class CashChild extends BaseWidget<CashController>{
  @override
  CashController createController() => CashController();

  @override
  Widget createWidget() => Stack(
    children: [
      LocalImageWidget(image: "cash_bg", width: double.infinity, height: double.infinity),
      SafeArea(
        child: Column(
          children: [
            SizedBox(height: 16.h,),
            _cashTypeListWidget(),
            SizedBox(height: 16.h,),
            _cashMoneyWidget(),
            SizedBox(height: 16.h,),
            _amountWidget(),
            SizedBox(height: 40.w,),
          ],
        ),
      )
    ],
  );

  _cashTypeListWidget()=>SizedBox(
    width: double.infinity,
    height: 36.h,
    child: GetBuilder<CashController>(
      id: "cash_type",
      builder: (_)=>ListView.builder(
        itemCount: ftController.cashTypeList.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context,index){
          var bean = ftController.cashTypeList[index];
          return InkWell(
            onTap: (){
              ftController.clickCashType(index);
            },
            child: Container(
              margin: EdgeInsets.only(left: 5.w,right: 5.w),
              child: LocalImageWidget(image: ftController.chooseCashTypeIndex==index?bean.selIcon:bean.unsIcon, width: 108.w, height: 36.h),
            ),
          );
        },
      ),
    ),
  );

  _cashMoneyWidget()=>Container(
    margin: EdgeInsets.only(left: 12.w,right: 12.w),
    child: Stack(
      children: [
        GetBuilder<CashController>(
          id: "cash_bg",
          builder: (_)=>LocalImageWidget(image: ftController.getCashMoneyBg(), width: double.infinity, height: 120.h),
        ),
        Positioned(
          top: 4.h,
          left: 12.w,
          child: TextWidget(data: "100% winning", color: "#BABCCF", size: 12.sp,fontWeight: FontWeight.bold,),
        ),
        Positioned(
          right: 12.w,
          bottom: 0,
          child: GetBuilder<CashController>(
            id: "money",
            builder: (_)=>TextWidget(data: "\$${UserInfoHep.instance.getUserCoins()}", color: "#FFFFFF", size: 32.sp,fontWeight: FontWeight.bold,),
          ),
        )
      ],
    ),
  );

  _amountWidget()=>Expanded(
    child: Container(
      width: double.infinity,
      height: double.infinity,
      margin: EdgeInsets.only(left: 12.w,right: 12.w),
      child: Stack(
        children: [
          LocalImageWidget(image: "cash_bg2", width: double.infinity, height: double.infinity),
          Column(
            children: [
              SizedBox(height: 48.h,),
              Expanded(
                child: GetBuilder<CashController>(
                  id: "list",
                  builder: (_)=>ListView.builder(
                    itemCount: ftController.cashList.length,
                    itemBuilder: (context,index){
                      var bean = ftController.cashList[index];
                      return Container(
                        width: double.infinity,
                        padding: EdgeInsets.only(left: 8.w,right: 8.w,bottom: 8.h),
                        margin: EdgeInsets.only(left: 8.w,right: 8.w,bottom: 12.h),
                        decoration: const BoxDecoration(
                          image: DecorationImage(image: AssetImage("ft_resource/image/cash1.webp"),fit: BoxFit.fill),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                TextWidget(data: "\$${bean.cashMoney}", color: "#000000", size: 24.sp,fontWeight: FontWeight.bold,),
                                const Spacer(),
                                InkWell(
                                  onTap: (){
                                    ftController.clickCashBtn(bean);
                                  },
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      LocalImageWidget(image: ftController.getCashBtnIcon(bean.cashInfoBean), width: 88.w, height: 24.h),
                                      TextWidget(data: ftController.getCashBtnStr(bean.cashInfoBean), color: "#FFFFFF", size: 14.sp,fontWeight: FontWeight.bold,),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 10.h,),
                            null!=bean.cashInfoBean?
                            Row(
                              children: [
                                LocalImageWidget(image: ftController.getTaskIcon(bean.cashInfoBean), width: 36.w, height: 36.w),
                                SizedBox(width: 10.w,),
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextWidget(data: ftController.getTaskLeftStr(bean.cashInfoBean!), color: "#000000", size: 14.sp,fontWeight: FontWeight.bold,),
                                          TextWidget(data: "${bean.cashInfoBean?.totalPro??0}", color: "#FF3333", size: 14.sp,fontWeight: FontWeight.bold,),
                                          TextWidget(data: ftController.getTaskRightStr(bean.cashInfoBean!), color: "#000000", size: 14.sp,fontWeight: FontWeight.bold,),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: LayoutBuilder(
                                              builder: (context,bc){
                                                var maxWidth = bc.maxWidth;
                                                return Container(
                                                  width: maxWidth,
                                                  height:  12.h,
                                                  color: "#060832".toColor(),
                                                  alignment: Alignment.centerLeft,
                                                  padding: EdgeInsets.only(left: 2.w,right: 2.w),
                                                  child: Container(
                                                    width: (maxWidth-4.w)*ftController.getTaskPro(bean.cashInfoBean),
                                                    height: 8.h,
                                                    color: "#FFD84B".toColor(),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          SizedBox(width: 4.w,),
                                          TextWidget(data: "${bean.cashInfoBean?.currentPro??0}/${bean.cashInfoBean?.totalPro??0}", color: "#7A7A7A", size: 12.sp)
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ):
                            Row(
                              children: [
                                LocalImageWidget(image: "cash3", width: 24.w, height: 24.w),
                                SizedBox(width: 4.w,),
                                Expanded(
                                  child: LayoutBuilder(
                                    builder: (context,bc){
                                      var maxWidth = bc.maxWidth;
                                      return Container(
                                        width: double.infinity,
                                        height:  12.h,
                                        color: "#060832".toColor(),
                                        alignment: Alignment.centerLeft,
                                        padding: EdgeInsets.only(left: 2.w,right: 2.w),
                                        child: Container(
                                          width: (maxWidth-4.w)*ftController.getMoneyPro(bean.cashMoney),
                                          height: 8.h,
                                          color: "#FFD84B".toColor(),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(width: 4.w,),
                                TextWidget(data: "${UserInfoHep.instance.getUserCoins()}/${bean.cashMoney}", color: "#7A7A7A", size: 12.sp)
                              ],
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 16.w,right: 16.w,bottom: 20.h),
                child: TextWidget(data: "Tips:Cash will arrive in your account within 24 hours as soon as possible", color: "#858585", size: 14.sp),
              )
            ],
          )
        ],
      ),
    ),
  );
}