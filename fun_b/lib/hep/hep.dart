import 'package:fun_b/hep/game_config_hep.dart';
import 'package:fun_base/routers/b_routers_name.dart';
import 'package:fun_base/routers/routers_utils.dart';
import 'package:fun_base/util/tba_point/custom_point.dart';
import 'package:fun_base/util/tba_point/tab_point_hep.dart';

class Hep{
  static toPlayPage(WinnerType winnerType,{bool offCurrentPage=false}){
    String routerName="";
    switch(winnerType){
      case WinnerType.winnerGame:
        routerName=BRoutersName.winnerGame;
        break;
      case WinnerType.fruitMatch:
        routerName=BRoutersName.fruitMatch;
        break;
      case WinnerType.chasingLuck:
        routerName=BRoutersName.chasingLuck;
        break;
      case WinnerType.casinoRush:
        routerName=BRoutersName.casinoRush;
        break;
      case WinnerType.winOrLose:
        routerName=BRoutersName.winOrLose;
        break;
      case WinnerType.luckyNumber:
        routerName=BRoutersName.luckNumber;
        break;
      case WinnerType.bettingHigh:
        routerName=BRoutersName.bettingHigh;
        break;
      default:

        break;
    }
    var tbaPlayTypeStr = getTbaPlayTypeStr(winnerType);
    if(tbaPlayTypeStr.isNotEmpty){
      TbaPointHep.instance.pointEvent(CustomId.card_detail_page,params: {"page_from":tbaPlayTypeStr});
    }
    if(offCurrentPage){
      RouterUtils.offNamed(routersName: routerName);
    }else{
      RouterUtils.toNamed(routersName: routerName);
    }
  }

  static String getTbaPlayTypeStr(WinnerType winnerType){
    String pageFrom="";
    switch(winnerType){
      case WinnerType.winnerGame:
        pageFrom="winner";
        break;
      case WinnerType.fruitMatch:
        pageFrom="fruit";
        break;
      case WinnerType.chasingLuck:
        pageFrom="luck";
        break;
      case WinnerType.casinoRush:
        pageFrom="rush";
        break;
      case WinnerType.winOrLose:
        pageFrom="lose";
        break;
      case WinnerType.luckyNumber:
        pageFrom="number";
        break;
      case WinnerType.bettingHigh:
        pageFrom="high";
        break;
      default:

        break;
    }
    return pageFrom;
  }

  static String getCashTypeIcon(int cashType){
    switch(cashType){
      case 0: return "icon_sel_pal";
      case 1: return "icon_sel_ama";
      case 2: return "icon_sel_gp";
      case 3: return "icon_sel_master";
      case 4: return "icon_sel_cash";
      case 5: return "icon_sel_web";
      default: return "icon_sel_pal";
    }
  }
}