import 'package:fun_b/page/betting_high7/betting_high_page.dart';
import 'package:fun_b/page/casino_rush4/casino_rush_page.dart';
import 'package:fun_b/page/chasing_luck3/chasing_luck_page.dart';
import 'package:fun_b/page/fruit_match2/fruit_match_page.dart';
import 'package:fun_b/page/home/home_page.dart';
import 'package:fun_b/page/luck_number6/luck_number_page.dart';
import 'package:fun_b/page/win_or_lose5/win_or_lose_page.dart';
import 'package:fun_b/page/winner_game1/winner_game_page.dart';
import 'package:fun_base/routers/b_routers_name.dart';
import 'package:fun_base/util/util.dart';

class BRoutersList{
  static final bList=[
    GetPage(
        name: BRoutersName.home,
        page: ()=> HomePage(),
        transition: Transition.fadeIn
    ),
    GetPage(
        name: BRoutersName.winnerGame,
        page: ()=> WinnerGamePage(),
        transition: Transition.fadeIn
    ),
    GetPage(
        name: BRoutersName.fruitMatch,
        page: ()=> FruitMatchPage(),
        transition: Transition.fadeIn
    ),
    GetPage(
        name: BRoutersName.chasingLuck,
        page: ()=> ChasingLuckPage(),
        transition: Transition.fadeIn
    ),
    GetPage(
        name: BRoutersName.casinoRush,
        page: ()=> CasinoRushPage(),
        transition: Transition.fadeIn
    ),
    GetPage(
        name: BRoutersName.winOrLose,
        page: ()=> WinOrLosePage(),
        transition: Transition.fadeIn
    ),
    GetPage(
        name: BRoutersName.luckNumber,
        page: ()=> LuckNumberPage(),
        transition: Transition.fadeIn
    ),
    GetPage(
        name: BRoutersName.bettingHigh,
        page: ()=> BettingHighPage(),
        transition: Transition.fadeIn
    ),
  ];
}