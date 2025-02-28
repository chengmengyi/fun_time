import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fun_base/base/base_widget.dart';
import 'package:fun_base/base_page/web_page/web_controller.dart';
import 'package:fun_base/routers/routers_utils.dart';
import 'package:fun_base/widget/local_image_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebPage extends BaseWidget<WebController>{
  @override
  WebController createController() => WebController();

  @override
  Widget createWidget() => Scaffold(
    body: Stack(
      alignment: Alignment.topCenter,
      children: [
        LocalImageWidget(image: "launch", width: double.infinity, height: double.infinity),
        SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(left: 12.w,bottom: 12.w),
                child: InkWell(
                  onTap: (){
                    RouterUtils.back();
                  },
                  child: LocalImageWidget(image: "icon_close", width: 30.w, height: 30.w),
                ),
              ),
              Expanded(child: WebViewWidget(controller: ftController.controller))
            ],
          ),
        )
      ],
    ),
  );
}