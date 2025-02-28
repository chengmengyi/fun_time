import 'package:fun_base/base/base_controller.dart';
import 'package:fun_base/routers/routers_utils.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebController extends BaseController{
  late WebViewController controller;

  @override
  void onInit() {
    super.onInit();
    print(RouterUtils.getArguments()["url"]);
    controller=WebViewController();
  }

  @override
  void onReady() {
    super.onReady();
    controller.loadRequest(Uri.parse(RouterUtils.getArguments()["url"]));
  }
}