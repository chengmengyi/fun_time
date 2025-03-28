import 'package:flutter/material.dart';
import 'package:fun_b/bean/level_data.dart';
import 'package:fun_b/hep/level_hep.dart';
import 'package:fun_b/hep/user_info_hep.dart';
import 'package:fun_b/page/level/level_controller.dart';
import 'package:fun_base/base/base_widget.dart';
import 'package:fun_base/routers/routers_utils.dart';
import 'package:fun_base/util/util.dart';
import 'package:fun_base/widget/local_image_widget.dart';
import 'package:fun_base/widget/text_widget.dart';

class LevelPage extends BaseWidget<LevelController>{
  @override
  LevelController createController() => LevelController();

  @override
  Widget createWidget() => Scaffold(
    body: Column(
      children: [
        _topWidget(),
        _levelWidget(),
        _listWidget(),
      ],
    ),
  );

  _topWidget()=>SizedBox(
    width: double.infinity,
    height: 210.h,
    child: Stack(
      children: [
        LocalImageWidget(image: "level1", width: double.infinity, height: double.infinity),
        Positioned(
          right: 16.w,
          child: SafeArea(
            child: InkWell(
              onTap: (){
                RouterUtils.back();
              },
              child: LocalImageWidget(image: "level2", width: 32.w, height: 32.w),
            ),
          ),
        )
      ],
    ),
  );

  _levelWidget()=>SizedBox(
    width: double.infinity,
    height: 60.h,
    child: Stack(
      alignment: Alignment.center,
      children: [
        LocalImageWidget(image: "level3", width: double.infinity, height: double.infinity),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 260.w,
              height: 40.h,
              child: Stack(
                children: [
                  Align(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 240.w,
                          height: 20.h,
                          padding: EdgeInsets.only(left: 2.w,right: 2.w),
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                            color: "#2B2B2B".toColor(),
                            borderRadius: BorderRadius.circular(10.w),
                          ),
                          child: Container(
                            width: (236.w)*ftController.getLevelPro(),
                            height: 16.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.w),
                              gradient: LinearGradient(colors: ["#FFC73A".toColor(),"#FF9D00".toColor()])
                            ),
                          ),
                        ),
                        TextWidget(data: "${UserInfoHep.instance.getUserDiamond()%3}/3", color: "#FFFFFF", size: 14.sp,fontWeight: FontWeight.bold,)
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: LocalImageWidget(image: "level4", width: 40.w, height: 40.h),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        LocalImageWidget(image: "level5", width: 40.w, height: 40.h),
                        TextWidget(data: "${ftController.getCurrentLevel()}", color: "#FFE227", size: 14.sp,fontWeight: FontWeight.bold,)
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        )
      ],
    ),
  );

  _listWidget()=>Expanded(
    child: Stack(
      children: [
        LocalImageWidget(image: "level8", width: double.infinity, height: double.infinity),
        Container(
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 60.h,),
                MediaQuery.removePadding(
                  removeTop: true,
                  context: ftController.context,
                  child: GetBuilder<LevelController>(
                    id: "list",
                    builder: (_)=>ListView.builder(
                      itemCount: ftController.list.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context,index)=>_itemWidget(ftController.list[index]),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  LocalImageWidget(image: "level6", width: double.infinity, height: 48.h),
                  TextWidget(data: "FREE PASS", color: "#114674", size: 18.sp,fontWeight: FontWeight.bold,),
                ],
              ),
            ),
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  LocalImageWidget(image: "level7", width: double.infinity, height: 48.h),
                  TextWidget(data: "GOLD PASS", color: "#114674", size: 18.sp,fontWeight: FontWeight.bold,),
                ],
              ),
            ),
          ],
        ),
      ],
    ),
  );

  _itemWidget(LevelData data)=>SizedBox(
    width: double.infinity,
    height: 148.h,
    child: Stack(
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                height: 148.h,
                alignment: Alignment.center,
                child: SizedBox(
                  width: 120.w,
                  height: 120.h,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Stack(
                        children: [
                          LocalImageWidget(image: "level9", width: 88.w, height: 118.h),
                          Positioned(
                            right: 0,
                            bottom: 34.h,
                            child: TextWidget(data: "\$50", color: "#FFFFFF", size: 20.sp,fontWeight: FontWeight.bold,),
                          )
                        ],
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          margin: EdgeInsets.only(bottom: 4.h),
                          child: InkWell(
                            onTap: (){
                              ftController.clickSingle(data);
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                LocalImageWidget(image: data.singleStatus==LevelStatus.canReceive?"level15":"level10", width: 80.w, height: 26.h),
                                TextWidget(
                                  data: "Claim",
                                  color: "#FFFFFF",
                                  size: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  colorOpacity: data.singleStatus==LevelStatus.canReceive?null:0.3,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Visibility(
                          visible: data.singleStatus!=LevelStatus.canReceive,
                          child: LocalImageWidget(image: data.singleStatus==LevelStatus.normal?"level12":"level11", width: 36.w, height: 36.w),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                LocalImageWidget(image: ftController.getCurrentLevel()>=(data.levelNum??0)?"level17":"level16", width: 16.w, height: double.infinity),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    LocalImageWidget(image: ftController.getCurrentLevel()>=(data.levelNum??0)?"level18":"level19", width: 40.w, height: 40.w),
                    TextWidget(data: "${data.levelNum??0}", color: "#FFFFFF", size: 16.sp,fontWeight: FontWeight.bold,)
                  ],
                )
              ],
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                height: 148.h,
                alignment: Alignment.center,
                child: SizedBox(
                  width: 120.w,
                  height: 120.h,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Stack(
                        children: [
                          LocalImageWidget(image: "level13", width: 88.w, height: 118.h),
                          Positioned(
                            right: 0,
                            bottom: 34.h,
                            child: TextWidget(data: "\$100", color: "#FFFFFF", size: 20.sp,fontWeight: FontWeight.bold,),
                          )
                        ],
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          margin: EdgeInsets.only(bottom: 4.h),
                          child: InkWell(
                            onTap: (){
                              ftController.clickDouble(data);
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                LocalImageWidget(image: data.doubleStatus==LevelStatus.canReceive?"level15":"level10", width: 80.w, height: 26.h),
                                TextWidget(
                                  data: "Claim",
                                  color: "#FFFFFF",
                                  size: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  colorOpacity: data.doubleStatus==LevelStatus.canReceive?null:0.3,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: LocalImageWidget(
                          image: data.doubleStatus==LevelStatus.normal?"level12":data.doubleStatus==LevelStatus.canReceive?"level14":"level11",
                          width: 36.w,
                          height: 36.w,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    ),
  );
}