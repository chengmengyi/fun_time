import 'package:fun_b/bean/user_info_bean.dart';
import 'package:fun_b/hep/cash_hep.dart';
import 'package:fun_b/hep/comment_hep.dart';
import 'package:fun_b/hep/game_config_hep.dart';
import 'package:fun_b/hep/level_hep.dart';
import 'package:fun_b/hep/storage/storage_bean.dart';
import 'package:fun_base/util/event/event_code.dart';
import 'package:fun_base/util/event/event_data.dart';
import 'package:fun_base/util/sql/base_sql_hep.dart';
import 'package:fun_base/util/sql/sql_table_name.dart';
import 'package:fun_base/util/tba_point/custom_point.dart';
import 'package:fun_base/util/tba_point/tab_point_hep.dart';
import 'package:fun_base/util/util.dart';

class UserInfoHep{
  static final UserInfoHep _instance = UserInfoHep();
  static UserInfoHep get instance => _instance;

  UserInfoBean? _userInfoBean;

  initUserInfo()async{
    var db = await BaseSqlHep.instance.initSql();
    var list = await db.query(SqlTableName.userInfoB);
    if(list.isEmpty){
      _userInfoBean=UserInfoBean(
        coinsNum: 0.0,
        diamondNum: 0,
        winnerGamePlayNum: 10,
        fruitMatchPlayNum: 10,
        chasingLuckPlayNum: 10,
        casinoRushPlayNum: 10,
        winOrLosePlayNum: 10,
        luckyNumberPlayNum: 10,
        bettingHighPlayNum: 10,
      );
      var id = await db.insert(SqlTableName.userInfoB, _userInfoBean?.toJson()??{});
      _userInfoBean?.id=id;
      return;
    }
    _userInfoBean=UserInfoBean.fromJson(list.first);
  }

  updateUserCoins(dynamic coins){
    if(coins is! int&& coins is! double){
      return;
    }
    var coinsNum = _userInfoBean?.coinsNum??0;
    _userInfoBean?.coinsNum=(Decimal.parse("$coinsNum")+Decimal.parse("$coins")).toDouble();
    var moneyLevel = (Decimal.parse("${lastMoneyLevel.getData()}")+Decimal.fromInt(100)).toDouble();
    if((_userInfoBean?.coinsNum??0)>=moneyLevel){
      TbaPointHep.instance.pointEvent(CustomId.cash_money_detail,params: {"money":moneyLevel});
      lastMoneyLevel.saveData(moneyLevel);
    }
    EventData(code: EventCode.showMoneyLottie).send();
    if(coins>0&&firstGetReward.getData()){
      EventData(code: EventCode.firstGetReward).send();
    }
    if(coins>0){
      CashHep.instance.checkShowAccountDialog();
    }
  }

  updateUserDiamond(int add)async{
    var diamondNum = _userInfoBean?.diamondNum??0;
    var lastLevel = diamondNum~/3;
    _userInfoBean?.diamondNum=diamondNum+add;
    await _saveUserInfo();
    EventData(code: EventCode.updateUserDiamondB).send();
    var nowLevel = (_userInfoBean?.diamondNum??0)~/3;
    if(nowLevel>lastLevel){
      EventData(code: EventCode.showLevelFingerB).send();
      LevelHep.instance.updateLevelData(nowLevel, LevelStatus.canReceive,UpdateLevelStatusType.all);
    }
  }

  int getUserDiamond()=>_userInfoBean?.diamondNum??0;

  double getUserCoins()=>_userInfoBean?.coinsNum??0.0;

  int getPlayNum(WinnerType winnerType){
    switch(winnerType){
      case WinnerType.winnerGame: return _userInfoBean?.winnerGamePlayNum??0;
      case WinnerType.fruitMatch: return _userInfoBean?.fruitMatchPlayNum??0;
      case WinnerType.chasingLuck: return _userInfoBean?.chasingLuckPlayNum??0;
      case WinnerType.casinoRush: return _userInfoBean?.casinoRushPlayNum??0;
      case WinnerType.winOrLose: return _userInfoBean?.winOrLosePlayNum??0;
      case WinnerType.luckyNumber: return _userInfoBean?.luckyNumberPlayNum??0;
      case WinnerType.bettingHigh: return _userInfoBean?.bettingHighPlayNum??0;
      default: return 0;
    }
  }

  updateCanPlayNum(int num,WinnerType winnerType,{bool fromVideo=false})async{
    var coinsNum = _userInfoBean?.coinsNum??0;
    if(num>0&&!fromVideo){
      if(coinsNum<num*100){
        showToast("Your gold coins are insufficient");
        return;
      }
      _userInfoBean?.coinsNum=coinsNum-num*100;
    }
    switch(winnerType){
      case WinnerType.winnerGame:
        _userInfoBean?.winnerGamePlayNum=(_userInfoBean?.winnerGamePlayNum??0)+num;
        if((_userInfoBean?.winnerGamePlayNum??0)<0){
          _userInfoBean?.winnerGamePlayNum=0;
        }
        break;
      case WinnerType.fruitMatch:
        _userInfoBean?.fruitMatchPlayNum=(_userInfoBean?.fruitMatchPlayNum??0)+num;
        if((_userInfoBean?.fruitMatchPlayNum??0)<0){
          _userInfoBean?.fruitMatchPlayNum=0;
        }
        break;
      case WinnerType.chasingLuck:
        _userInfoBean?.chasingLuckPlayNum=(_userInfoBean?.chasingLuckPlayNum??0)+num;
        if((_userInfoBean?.chasingLuckPlayNum??0)<0){
          _userInfoBean?.chasingLuckPlayNum=0;
        }
        break;
      case WinnerType.casinoRush:
        _userInfoBean?.casinoRushPlayNum=(_userInfoBean?.casinoRushPlayNum??0)+num;
        if((_userInfoBean?.casinoRushPlayNum??0)<0){
          _userInfoBean?.casinoRushPlayNum=0;
        }
        break;
      case WinnerType.winOrLose:
        _userInfoBean?.winOrLosePlayNum=(_userInfoBean?.winOrLosePlayNum??0)+num;
        if((_userInfoBean?.winOrLosePlayNum??0)<0){
          _userInfoBean?.winOrLosePlayNum=0;
        }
        break;
      case WinnerType.luckyNumber:
        _userInfoBean?.luckyNumberPlayNum=(_userInfoBean?.luckyNumberPlayNum??0)+num;
        if((_userInfoBean?.luckyNumberPlayNum??0)<0){
          _userInfoBean?.luckyNumberPlayNum=0;
        }
        break;
      case WinnerType.bettingHigh:
        _userInfoBean?.bettingHighPlayNum=(_userInfoBean?.bettingHighPlayNum??0)+num;
        if((_userInfoBean?.bettingHighPlayNum??0)<0){
          _userInfoBean?.bettingHighPlayNum=0;
        }
        break;
      default:

        break;
    }
    await _saveUserInfo();
    EventData(code: EventCode.updatePlayNumB).send();
    if(!fromVideo){
      EventData(code: EventCode.updateUserCoinsB).send();
    }
  }

  addAllTypePlayNum()async{
    _userInfoBean?.winnerGamePlayNum=(_userInfoBean?.winnerGamePlayNum??0)+1;
    _userInfoBean?.fruitMatchPlayNum=(_userInfoBean?.fruitMatchPlayNum??0)+1;
    _userInfoBean?.chasingLuckPlayNum=(_userInfoBean?.chasingLuckPlayNum??0)+1;
    _userInfoBean?.casinoRushPlayNum=(_userInfoBean?.casinoRushPlayNum??0)+1;
    _userInfoBean?.winOrLosePlayNum=(_userInfoBean?.winOrLosePlayNum??0)+1;
    _userInfoBean?.luckyNumberPlayNum=(_userInfoBean?.luckyNumberPlayNum??0)+1;
    _userInfoBean?.bettingHighPlayNum=(_userInfoBean?.bettingHighPlayNum??0)+1;
    await _saveUserInfo();
    EventData(code: EventCode.updatePlayNumB).send();
  }

  _saveUserInfo()async{
    var db = await BaseSqlHep.instance.initSql();
    await db.update(SqlTableName.userInfoB, _userInfoBean?.toJson()??{},where: '"id" = ?', whereArgs: [_userInfoBean?.id]);
  }


}