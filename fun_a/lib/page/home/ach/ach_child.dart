import 'package:flutter/material.dart';
import 'package:fun_a/bean/ach_bean.dart';
import 'package:fun_a/dialog/set/set_dialog.dart';
import 'package:fun_a/page/home/ach/ach_controller.dart';
import 'package:fun_a/widget/coins_widget.dart';
import 'package:fun_a/widget/diamond_widget.dart';
import 'package:fun_base/base/base_widget.dart';
import 'package:fun_base/routers/routers_utils.dart';
import 'package:fun_base/util/util.dart';
import 'package:fun_base/widget/local_image_widget.dart';
import 'package:fun_base/widget/text_widget.dart';

class AchChild extends BaseWidget<AchController>{
  @override
  AchController createController() => AchController();

  @override
  Widget createWidget() => Stack(
    children: [
      LocalImageWidget(image: "ach1", width: double.infinity, height: double.infinity),
      SafeArea(
        child: Column(
          children: [
            _topWidget(),
            Expanded(
              child: Container(
                width: double.infinity,
                height: double.infinity,
                margin: EdgeInsets.only(left: 12.w,right: 12.w),
                child: Stack(
                  children: [
                    LocalImageWidget(image: "ach2", width: double.infinity, height: double.infinity),
                    GetBuilder<AchController>(
                      id: "list",
                      builder: (_)=>ListView.builder(
                        itemCount: ftController.achList.length,
                        itemBuilder: (context,index)=>_itemWidget(ftController.achList[index]),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 88.w,),
          ],
        ),
      ),
    ],
  );

  _itemWidget(AchBean bean)=>Container(
    width: double.infinity,
    height: 64.h,
    margin: EdgeInsets.only(left: 12.w,right: 12.w,top: 12.h),
    child: Stack(
      alignment: Alignment.centerLeft,
      children: [
        LocalImageWidget(image: "ach3", width: double.infinity, height: double.infinity),
        Row(
          children: [
            SizedBox(width: 8.w,),
            Container(
              width: 40.w,
              height: 40.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: "#FFFFFF".toColor(),
                border: Border.all(
                  width: 1.w,
                  color: "#000000".toColor(),
                )
              ),
              child: LocalImageWidget(image: "ach4", width: 36.w, height: 36.w ),
            ),
            SizedBox(width: 8.w,),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget(data: bean.title??"", color: "#000000", size: 12.sp,overflow: TextOverflow.ellipsis,fontWeight: FontWeight.bold,),
                  Row(
                    children: [
                      Expanded(
                        child: LayoutBuilder(
                          builder: (context,bc){
                            var maxWidth = bc.maxWidth;
                            return Container(
                              height: 12.w,
                              color: "#060832".toColor(),
                              padding: EdgeInsets.all(2.w),
                              alignment: Alignment.centerLeft,
                              child: Container(
                                width: maxWidth*ftController.getPro(bean),
                                height: double.infinity,
                                color: "#FFD84B".toColor(),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(width: 4.w,),
                      TextWidget(data: "${bean.currentPro??0}/${bean.totalPro??0}", color: "#7A7A7A", size: 12.sp,fontWeight: FontWeight.bold,),
                      SizedBox(width: 16.w,),
                      InkWell(
                        onTap: (){
                          ftController.clickBtn(bean);
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            LocalImageWidget(image: "ach5", width:  68.w, height: 24.h),
                            TextWidget(data: ftController.getBtnStr(bean), color: "#FFFFFF", size: 12.sp,fontWeight: FontWeight.bold,)
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            SizedBox(width: 8.w,),
          ],
        )
      ],
    ),
  );

  _topWidget()=>Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(width: 16.w,),
      CoinsWidget(),
      SizedBox(width: 8.w,),
      DiamondWidget(),
      const Spacer(),
      InkWell(
        onTap: (){
          RouterUtils.dialog(widget: SetDialog());
        },
        child: LocalImageWidget(image: "icon_set", width: 32.w, height: 32.w),
      ),
      SizedBox(width: 16.w,),
    ],
  );
}