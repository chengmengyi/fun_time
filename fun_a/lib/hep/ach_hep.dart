import 'package:fun_a/bean/ach_bean.dart';
import 'package:fun_base/util/event/event_code.dart';
import 'package:fun_base/util/event/event_data.dart';
import 'package:fun_base/util/sql/base_sql_hep.dart';
import 'package:fun_base/util/sql/sql_table_name.dart';

class AchType{
  static const String fruit="fruit";
  static const String winner="winner";
  static const String betting="betting";
  static const String chasing="chasing";
  static const String coins2000="coins2000";
  static const String coins5000="coins5000";
  static const String coins8000="coins8000";
}

class AchStatus{
  static const int go=0;
  static const int receive=1;
  static const int collected=2;
}

class AchHep {
  static final AchHep _instance = AchHep();
  static AchHep get instance => _instance;

  Future<List<AchBean>> getAchList()async{
    var sql = await BaseSqlHep.instance.initSql();
    var list = await sql.query(SqlTableName.achA);
    List<AchBean> resultList=[];
    if(list.isEmpty){
      resultList.add(AchBean(title: "Scrape the Fruit Match card 3 times",currentPro: 0,totalPro: 3,achType: AchType.fruit,status: AchStatus.go));
      resultList.add(AchBean(title: "Scrape the Winner Game card 5 times",currentPro: 0,totalPro: 5,achType: AchType.winner,status: AchStatus.go));
      resultList.add(AchBean(title: "Scrape the Betting High card 8 times",currentPro: 0,totalPro: 8,achType: AchType.betting,status: AchStatus.go));
      resultList.add(AchBean(title: "Scrape the Chasing Lucky card 10 times",currentPro: 0,totalPro: 10,achType: AchType.chasing,status: AchStatus.go));
      resultList.add(AchBean(title: "Obtained a total of 2000 gold coins",currentPro: 0,totalPro: 2000,achType: AchType.coins2000,status: AchStatus.go));
      resultList.add(AchBean(title: "Obtained a total of 5000 gold coins",currentPro: 0,totalPro: 5000,achType: AchType.coins5000,status: AchStatus.go));
      resultList.add(AchBean(title: "Obtained a total of 8000 gold coins",currentPro: 0,totalPro: 8000,achType: AchType.coins8000,status: AchStatus.go));
      for (var value in resultList) {
        await sql.insert(SqlTableName.achA, value.toJson());
      }
    }
    for (var value in list) {
      resultList.add(AchBean.fromJson(value));
    }
    return resultList;
  }

  updateAchPro(String achType)async{
    var sql = await BaseSqlHep.instance.initSql();
    var list = await sql.query(SqlTableName.achA,where: '"achType" = ? ',whereArgs: [achType]);
    if(list.isEmpty){
      return;
    }
    var newMap = Map<String, Object?>.from(list.first);
    var currentPro = newMap["currentPro"] as int;
    var totalPro = newMap["totalPro"] as int;
    var status = newMap["status"] as int;
    if(status!=AchStatus.go){
      return;
    }
    if(currentPro<totalPro){
      newMap["currentPro"]=currentPro+1;
    }
    if(currentPro+1>=totalPro){
      newMap["status"]=AchStatus.receive;
    }
    await sql.update(SqlTableName.achA, newMap,where: '"id" = ?', whereArgs: [newMap["id"]]);
    EventData(code: EventCode.updateAchA).send();
  }

  updateAchCoinsPro(int addNum)async{
    var sql = await BaseSqlHep.instance.initSql();
    var list = await sql.query(SqlTableName.achA);
    if(list.isEmpty){
      return;
    }
    for (var value in list) {
      var newMap = Map<String, Object?>.from(value);
      var achType = newMap["achType"] as String;
      if(achType==AchType.coins2000||achType==AchType.coins5000||achType==AchType.coins8000){
        var status = newMap["status"] as int;
        if(status!=AchStatus.go){
          continue;
        }
        var currentPro = newMap["currentPro"] as int;
        var totalPro = newMap["totalPro"] as int;
        if(currentPro<totalPro){
          newMap["currentPro"]=currentPro+addNum;
        }
        if(currentPro+addNum>=totalPro){
          newMap["status"]=AchStatus.receive;
        }
        await sql.update(SqlTableName.achA, newMap,where: '"id" = ?', whereArgs: [newMap["id"]]);
      }
    }
    EventData(code: EventCode.updateAchA).send();
  }

  updateAchCollectedStatus(String achType)async{
    var sql = await BaseSqlHep.instance.initSql();
    var list = await sql.query(SqlTableName.achA,where: '"achType" = ? ',whereArgs: [achType]);
    if(list.isEmpty){
      return;
    }
    var newMap = Map<String, Object?>.from(list.first);
    newMap["status"]=AchStatus.collected;
    await sql.update(SqlTableName.achA, newMap,where: '"id" = ?', whereArgs: [newMap["id"]]);
    EventData(code: EventCode.updateAchA).send();
  }
}