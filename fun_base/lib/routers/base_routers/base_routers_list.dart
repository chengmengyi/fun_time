import 'package:fun_base/base_page/launch_page/launch_page.dart';
import 'package:fun_base/base_page/web_page/web_page.dart';
import 'package:get/get.dart';

import 'base_routers_name.dart';

class BaseRoutersList{
  static final baseList=[
    GetPage(
        name: BaseRoutersName.launch,
        page: ()=> LaunchPage(),
        transition: Transition.fadeIn
    ),
    GetPage(
        name: BaseRoutersName.web,
        page: ()=> WebPage(),
        transition: Transition.fadeIn
    ),
  ];
}