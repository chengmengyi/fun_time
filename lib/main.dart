import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fun_a/hep/game_config_hep.dart';
import 'package:fun_a/hep/local_data.dart';
import 'package:fun_a/hep/user_info_hep.dart';
import 'package:fun_a/routers/_routers_list.dart';
import 'package:fun_b/hep/cash_hep.dart';
import 'package:fun_b/hep/level_hep.dart';
import 'package:fun_b/routers/_routers_list.dart';
import 'package:fun_base/routers/base_routers/base_routers_list.dart';
import 'package:fun_base/routers/base_routers/base_routers_name.dart';
import 'package:fun_base/util/ad_hep.dart';
import 'package:fun_base/util/util.dart';
import 'package:fun_b/hep/game_config_hep.dart' as bGameConfig;
import 'package:fun_b/hep/user_info_hep.dart' as bUserInfo;

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarDividerColor: null,
        statusBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
      )
  );
  await GetStorage.init();

  //init a
  GameConfigHep.instance.initData();
  UserInfoHep.instance.initUserInfo();

  //init b
  AdHep.instance.initAdData(maxKey.base64(), localAdStr.base64());
  LevelHep.instance.initLevelData();
  bGameConfig.GameConfigHep.instance.initData();
  bUserInfo.UserInfoHep.instance.initUserInfo();
  CashHep.instance.initData();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var list=BaseRoutersList.baseList+ARoutersList.aList+BRoutersList.bList;
    return ScreenUtilInit(
      designSize: const Size(360, 780),
      builder: (c,child)=>GetMaterialApp(
        title: 'Scratch FunTime',
        enableLog: true,
        darkTheme: ThemeData.dark(),
        themeMode: ThemeMode.system,
        initialRoute: BaseRoutersName.launch,
        debugShowCheckedModeBanner: false,
        getPages: list,
        defaultTransition: Transition.rightToLeft,
        builder: (context,widget){
          return  MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: widget!,
          );
        },
      ),
    );
  }
}