import 'package:flutter/material.dart';
import 'package:fun_b/dialog/rank/rank_controller.dart';
import 'package:fun_b/hep/hep.dart';
import 'package:fun_base/base/base_dialog.dart';
import 'package:fun_base/routers/routers_utils.dart';
import 'package:fun_base/util/util.dart';
import 'package:fun_base/widget/local_image_widget.dart';
import 'package:fun_base/widget/text_widget.dart';

class RankDialog extends BaseDialog<RankController>{
  int cashType;
  int cashMoney;
  RankDialog({
    required this.cashType,
    required this.cashMoney,
  });

  @override
  initView() {
    ftController.cashType=cashType;
    ftController.cashMoney=cashMoney;
  }

  @override
  RankController createController() => RankController();

  @override
  Widget createWidget() => Container(
    width: double.infinity,
    height: 458.h,
    margin: EdgeInsets.only(left: 40.w,right: 40.w),
    child: Stack(
      alignment: Alignment.topCenter,
      children: [
        LocalImageWidget(image: "rank1", width: double.infinity, height: 458.h),
        Positioned(
          top: 6.h,
          left: 10.w,
          child: TextWidget(data: "Withdrawal approval ", color: "#FFFFFF", size: 20.sp,fontStyle: FontStyle.italic,fontWeight: FontWeight.bold,),
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
            SizedBox(height: 12.h,),
            _myRankWidget(),
            SizedBox(height: 10.h,),
            _rankListWidget(),
            SizedBox(height: 10.h,),
            _btnWidget(),
            SizedBox(height: 10.h,),
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

  _myRankWidget()=>GetBuilder<RankController>(
    id: "rank",
    builder: (_)=>RichText(
      text: TextSpan(
          children: [
            TextSpan(
                text: "${ftController.rankAll}",
                style: TextStyle(
                  fontSize: 12.sp,
                  color: "#FF3333".toColor(),
                  fontWeight: FontWeight.bold,
                )
            ),
            TextSpan(
                text: " in queue,Your Current rank:",
                style: TextStyle(
                  fontSize: 12.sp,
                  color: "#000000".toColor(),
                  fontWeight: FontWeight.bold,
                )
            ),
            TextSpan(
                text: "${ftController.myRankNum}",
                style: TextStyle(
                  fontSize: 12.sp,
                  color: "#FF3333".toColor(),
                  fontWeight: FontWeight.bold,
                )
            ),
          ]
      ),
    ),
  );

  _rankListWidget()=>Expanded(
    child: Container(
      width: double.infinity,
      height: double.infinity,
      margin: EdgeInsets.only(left: 16.w,right: 16.w),
      decoration: BoxDecoration(
        border: Border.all(
          width: 1.w,
          color: "#000000".toColor()
        )
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  height: 32.h,
                  alignment: Alignment.center,
                  child: TextWidget(data: "Rank", color: "#666666", size: 12.sp,fontWeight: FontWeight.bold,),
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  height: 32.h,
                  alignment: Alignment.center,
                  child: TextWidget(data: "Account", color: "#666666", size: 12.sp,fontWeight: FontWeight.bold,),
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  height: 32.h,
                  alignment: Alignment.center,
                  child: TextWidget(data: "Amount", color: "#666666", size: 12.sp,fontWeight: FontWeight.bold,),
                ),
              ),
            ],
          ),
          Expanded(
            child: GetBuilder<RankController>(
              id: "rank_list",
              builder: (_)=>ListView.builder(
                itemCount: ftController.rankList.length,
                itemBuilder: (context,index){
                  var bean = ftController.rankList[index];
                  var isMe = index==ftController.myRankNum-1;
                  return Container(
                    width: double.infinity,
                    height: 32.h,
                    color: index%2==0?"#EEF3F8".toColor():"#FFFFFF".toColor(),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            height: 32.h,
                            alignment: Alignment.center,
                            child: TextWidget(data: "${index+1}", color: isMe?"#FF3333":"#000000", size: 12.sp,fontWeight: FontWeight.bold,),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            height: 32.h,
                            alignment: Alignment.center,
                            child: TextWidget(data: ftController.hideAccount(bean.account), color: isMe?"#FF3333":"#000000", size: 10.sp,fontWeight: FontWeight.bold,),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            height: 32.h,
                            alignment: Alignment.center,
                            child: TextWidget(data: "\$${bean.amount}", color: isMe?"#FF3333":"#000000", size: 12.sp,fontWeight: FontWeight.bold,),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    ),
  );
  
  _btnWidget()=>GetBuilder<RankController>(
    id: "btn",
    builder: (_)=>InkWell(
      onTap: (){
        ftController.clickWatchAd();
      },
      child: SizedBox(
        width: 220.w,
        height: 38.h,
        child: Stack(
          children: [
            LocalImageWidget(image: "rank3", width: double.infinity, height: 52.h),
            Align(
              child: TextWidget(data: ftController.myRankNum<=1?"Cash Out":"Skip Wait", color: "#FFFFFF", size: 18.sp,fontWeight: FontWeight.bold,),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Visibility(
                visible: ftController.myRankNum>1,
                child: Container(
                  margin: EdgeInsets.only(left: 21.w),
                  child: LocalImageWidget(image: "icon_video", width: 18.w, height: 18.w),
                ),
              ),
            )
          ],
        ),
      ),
    ),
  );
}