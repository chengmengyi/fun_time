import 'package:flutter/material.dart';
import 'package:fun_b/dialog/comment/comment_controller.dart';
import 'package:fun_base/base/base_dialog.dart';
import 'package:fun_base/routers/routers_utils.dart';
import 'package:fun_base/util/util.dart';
import 'package:fun_base/widget/finger_widget.dart';
import 'package:fun_base/widget/local_image_widget.dart';
import 'package:fun_base/widget/text_widget.dart';

class CommentDialog extends BaseDialog<CommentController>{
  Function(int star) dismiss;
  CommentDialog({required this.dismiss});

  @override
  CommentController createController() => CommentController();

  @override
  Widget createWidget() => Container(
    width: double.infinity,
    height: 320.h,
    margin: EdgeInsets.only(left: 40.w,right: 40.w),
    child: Stack(
      alignment: Alignment.topCenter,
      children: [
        LocalImageWidget(image: "set1", width: double.infinity, height: 320.h),
        Positioned(
          top: 10.h,
          left: 16.w,
          child: TextWidget(data: "Give Us A Good Review", color: "#FFFFFF", size: 16.sp,fontStyle: FontStyle.italic,fontWeight: FontWeight.bold,),
        ),
        Positioned(
          top: 0,
          right: 8.w,
          child: InkWell(
            onTap: (){
              ftController.clickClose();
            },
            child: LocalImageWidget(image: "icon_close", width: 28.w, height: 28.h),
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 60.h,),
            LocalImageWidget(image: "logo", width: 88.w, height: 88.h),
            SizedBox(height: 16.h,),
            _starWidget(),
            SizedBox(height: 16.h,),
            _btnWidget(),
          ],
        ),
        Positioned(
          top: 180.h,
          right: 10.w,
          child: GetBuilder<CommentController>(
            id: "finger",
            builder: (_)=>Visibility(
              visible: ftController.canClick,
              child: InkWell(
                onTap: (){
                  ftController.clickStar(4,dismiss);
                },
                child: FingerWidget(),
              ),
            ),
          ),
        )
      ],
    ),
  );

  _starWidget()=>Container(
    width: double.infinity,
    margin: EdgeInsets.only(left: 20.w,right: 20.w),
    child: GetBuilder<CommentController>(
      id: "list",
      builder: (_)=>StaggeredGridView.countBuilder(
        padding: const EdgeInsets.all(0),
        itemCount: 5,
        shrinkWrap: true,
        crossAxisCount: 5,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context,index){
          return InkWell(
            onTap: (){
              ftController.clickStar(index,dismiss);
            },
            child: LocalImageWidget(image: ftController.starIndex>=index?"star_sel":"star_uns", width: 40.w, height: 40.w),
          );
        },
        staggeredTileBuilder: (int index) => const StaggeredTile.fit(1),
      ),
    ),
  );

  _btnWidget()=>InkWell(
    onTap: (){
      ftController.clickStar(4,dismiss);
    },
    child: SizedBox(
      width: 220.w,
      height: 38.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          LocalImageWidget(image: "rank3", width: double.infinity, height: 52.h),
          TextWidget(data: "Give 5 Stars", color: "#FFFFFF", size: 18.sp,fontWeight: FontWeight.bold,),
        ],
      ),
    ),
  );
}