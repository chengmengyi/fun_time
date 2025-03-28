
import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:fun_b/bean/cash_info_bean.dart';
import 'package:fun_b/bean/cash_list_bean.dart';
import 'package:fun_b/bean/other_config_bean.dart';
import 'package:fun_b/dialog/account/account_dialog.dart';
import 'package:fun_b/hep/local_data.dart';
import 'package:fun_b/hep/storage/storage_bean.dart';
import 'package:fun_b/hep/user_info_hep.dart';
import 'package:fun_base/routers/routers_utils.dart';
import 'package:fun_base/util/event/event_code.dart';
import 'package:fun_base/util/event/event_data.dart';
import 'package:fun_base/util/firebase_hep.dart';
import 'package:fun_base/util/sql/base_sql_hep.dart';
import 'package:fun_base/util/sql/sql_table_name.dart';
import 'package:fun_base/util/util.dart';

class CashStatus{
  static const String cards="cards";
  static const String rank="rank";
  static const String task="task";
  static const String complete="complete";
}

class CashTaskType{
  static const String card="card";
  static const String video="video";
}

class CashHep{
  static final CashHep _instance = CashHep();
  static CashHep get instance => _instance;

  OtherConfigBean? _otherConfigBean;

  initData(){
    _otherConfigBean=OtherConfigBean.fromJson(_getConfigData());
    FirebaseHep.instance.otherBCall=(){
      _otherConfigBean=OtherConfigBean.fromJson(_getConfigData());
    };
  }

  Future<List<CashListBean>> initCashList(int cashType)async{
    var cashList = getConfigCashMoneyList();
    List<CashListBean> resultList=[];
    for (var value in cashList) {
      var cashInfoBean = await queryCashInfoByCashTypeMoney(cashType, value);
      resultList.add(CashListBean(cashMoney: value, cashInfoBean: cashInfoBean));
    }
    return resultList;
  }

  Future<CashInfoBean?> queryCashInfoByCashTypeMoney(int cashType,int cashMoney)async{
    var db = await BaseSqlHep.instance.initSql();
    var list = await db.query(SqlTableName.cashListB,where: '"cashType" = ? AND "cashMoney" = ?',whereArgs: [cashType,cashMoney]);
    if(list.isEmpty){
      return null;
    }
    return CashInfoBean.fromJson(list.first);
  }

  checkShowAccountDialog()async{
    if(UserInfoHep.instance.getUserCoins()<getConfigCashMoneyList().first){
      return;
    }
    var db = await BaseSqlHep.instance.initSql();
    var cashType = selectedCashType.getData();
    var list = await db.query(SqlTableName.cashListB,where: '"cashType" = ? ',whereArgs: [cashType]);
    if(list.isNotEmpty){
      return;
    }
    RouterUtils.dialog(
      widget: AccountDialog(
        cashMoney: getConfigCashMoneyList().first,
      ),
    );
  }

  Future<CashInfoBean> createCashTask(int cashType,int cashMoney,String account)async{
    var db = await BaseSqlHep.instance.initSql();
    var accountList = await db.query(SqlTableName.cashAccountB,where: '"cashType" = ?',whereArgs: [cashType]);
    if(accountList.isEmpty){
      db.insert(SqlTableName.cashAccountB, {"cashType":cashType,"account":account});
    }
    var list = await db.query(SqlTableName.cashListB,where: '"cashType" = ? AND "cashMoney" = ?',whereArgs: [cashType,cashMoney]);
    if(list.isNotEmpty){
      return CashInfoBean.fromJson(list.first);
    }
    var bean = CashInfoBean(
      cashType: cashType,
      cashMoney: cashMoney,
      taskIndex: 0,
      currentPro: 0,
      totalPro: 10,
      rankNum: 0,
      cashStatus:CashStatus.cards,
      rankAllPerson: 0,
    );
    await db.insert(SqlTableName.cashListB, bean.toJson());
    return bean;
  }

  updateCashTask(String cashTaskType)async{
    var db = await BaseSqlHep.instance.initSql();
    var list = await db.query(SqlTableName.cashListB);
    if(list.isEmpty){
      return;
    }
    for (var value in list) {
      var newMap = Map<String, Object?>.from(value);
      var taskIndex = newMap["taskIndex"] as int;
      var currentPro = newMap["currentPro"] as int;
      var totalPro = newMap["totalPro"] as int;
      var cashStatus = newMap["cashStatus"] as String;
      if(cashStatus==CashStatus.cards){
        if(currentPro+1>=totalPro){
          newMap["currentPro"]=totalPro;
          newMap["cashStatus"]=CashStatus.rank;
          newMap["rankNum"]=_otherConfigBean?.cashCurrent?.intCurrent??99;
          newMap["rankAllPerson"]=_otherConfigBean?.cashAll?.intAll??388;
        }else{
          newMap["currentPro"]=currentPro+1;
        }
        await db.update(SqlTableName.cashListB, newMap,where: '"id" = ? ',whereArgs: [newMap["id"]]);
      }else if(cashStatus==CashStatus.task){
        if(getConfigTaskByIndex(taskIndex)?.title==cashTaskType&&currentPro<totalPro){
          if(currentPro==totalPro-1){
            if(checkIsLastTask(taskIndex)){
              newMap["currentPro"]=totalPro;
              newMap["cashStatus"]=CashStatus.complete;
            }else{
              newMap["currentPro"]=0;
              newMap["taskIndex"]=taskIndex+1;
              newMap["totalPro"]=getNextConfigTaskByIndex(taskIndex)?.data??0;
            }
          }else{
            newMap["currentPro"]=currentPro+1;
          }
          await db.update(SqlTableName.cashListB, newMap,where: '"id" = ? ',whereArgs: [newMap["id"]]);
        }
      }
    }
    EventData(code: EventCode.updateCashList).send();
  }

  getCashAllPersonAndMyRank({required int cashType,required int cashMoney,required Function(int rankNum,int rankAllPerson,String account) call})async{
    var db = await BaseSqlHep.instance.initSql();
    var list = await db.query(SqlTableName.cashListB,where: '"cashType" = ? AND "cashMoney" = ?',whereArgs: [cashType,cashMoney]);
    if(list.isEmpty){
      return;
    }
    var accountList = await db.query(SqlTableName.cashAccountB,where: '"cashType" = ?',whereArgs: [cashType]);
    String account="";
    if(accountList.isNotEmpty){
      account=accountList.first["account"] as String;
    }
    var map = list.first;
    call.call(map["rankNum"] as int ,map["rankAllPerson"] as int,account);
  }

  Future<int> updateTaskRank({required int cashType,required int cashMoney})async{
    var db = await BaseSqlHep.instance.initSql();
    var list = await db.query(SqlTableName.cashListB,where: '"cashType" = ? AND "cashMoney" = ? AND "cashStatus" = ?',whereArgs: [cashType,cashMoney,CashStatus.rank]);
    if(list.isEmpty){
      return 0;
    }
    var intAllDeleteList = _otherConfigBean?.cashAll?.intAllDelete??[1,3];
    var intCurrentDeleteList = _otherConfigBean?.cashCurrent?.intCurrentDelete??[5,8];
    var intAllDelete=0,intCurrentDelete=0;
    if(intAllDeleteList.length<=1){
      intAllDelete=1;
    }else{
      intAllDelete=Random().nextInt(intAllDeleteList.last-intAllDeleteList.first+1)+intAllDeleteList.first;
    }
    if(intCurrentDeleteList.length<=1){
      intCurrentDelete=1;
    }else{
      intCurrentDelete=Random().nextInt(intCurrentDeleteList.last-intCurrentDeleteList.first+1)+intCurrentDeleteList.first;
    }
    var newMap = Map<String, Object?>.from(list.first);
    var currentRankNum = newMap["rankNum"] as int;
    var currentRankAllPerson = newMap["rankAllPerson"] as int;
    newMap["rankAllPerson"]=currentRankAllPerson-intAllDelete;
    var newRankNum = currentRankNum-intCurrentDelete;
    if(newRankNum<=1){
      newRankNum=1;
      newMap["rankNum"]=newRankNum;
      newMap["cashStatus"]=CashStatus.task;
      newMap["currentPro"]=0;
      newMap["taskIndex"]=0;
      newMap["totalPro"]=getNextConfigTaskByIndex(0)?.data??0;
    }else{
      newMap["rankNum"]=newRankNum;
    }
    await db.update(SqlTableName.cashListB, newMap,where: '"id" = ? ',whereArgs: [newMap["id"]]);
    EventData(code: EventCode.updateCashList).send();
    return newRankNum;
  }

  completedCashTask(int cashType, int cashMoney)async{
    var db = await BaseSqlHep.instance.initSql();
    var list = await db.query(SqlTableName.cashListB,where: '"cashType" = ? AND "cashMoney" = ?',whereArgs: [cashType,cashMoney]);
    if(list.isEmpty){
      return;
    }
    await db.delete(SqlTableName.cashListB,where: '"id" = ? ',whereArgs: [list.first["id"]]);
    EventData(code: EventCode.updateCashList).send();
  }

  TixianTask? getConfigTaskByIndex(int index){
    try{
      return _otherConfigBean?.tixianTask?[index];
    }catch(e){
      return null;
    }
  }

  TixianTask? getNextConfigTaskByIndex(int index){
    try{
      if(kDebugMode){
        var tixianTask = _otherConfigBean?.tixianTask?[index+1];
        tixianTask?.data=1;
        return tixianTask;
      }else{
        return _otherConfigBean?.tixianTask?[index+1];
      }
    }catch(e){
      return null;
    }
  }

  bool checkShowAd(AdType adType){
    // if(kDebugMode){
    //   return false;
    // }
    if(adType==AdType.reward){
      return true;
    }
    var playNum = allPlayCardsNum.getData();
    var list = _otherConfigBean?.intadPoint??[];
    if(list.isEmpty){
      return false;
    }
    var last = list.last;
    if(playNum>=(last.endNumber??999999)){
      return Random().nextInt(100)<(last.point??100);
    }
    for (var value in list) {
      if(playNum>=(value.firstNumber??0)&&playNum<(value.endNumber??0)){
        return Random().nextInt(100)<(value.point??10);
      }
    }
    return false;
  }

  bool checkIsLastTask(int taskIndex)=>taskIndex==(_otherConfigBean?.tixianTask??[]).length-1;

  List<int> getConfigCashMoneyList()=>_otherConfigBean?.withdrawRange??[1000,1500,1800,2000];

  double getFloatAddNum()=>_getRewardByList(_otherConfigBean?.floatPrize??[]);

  double getBoxAddNum()=>_getRewardByList(_otherConfigBean?.boxPrize??[]);

  double _getRewardByList(List<FloatPrize> list){
    if(list.isEmpty){
      return 5.0;
    }
    var playNum = allPlayCardsNum.getData();
    if(playNum>=(list.last.endNumber??9999)){
      return _randomMinMax(list.last.prize?.first??5, list.last.prize?.last??10);
    }
    for (var value in list) {
      if(playNum>=(value.firstNumber??0)&&playNum<(value.endNumber??0)){
        return _randomMinMax(value.prize?.first??5, value.prize?.last??10);
      }
    }
    return 5.0;
  }

  double _randomMinMax(int min,int max)=>(Random().nextDouble()*(max-min)+min).toStringAsFixed(2).toDou();

  _getConfigData(){
    try{
      var data = otherBConfig.getData();
      if(data.isEmpty){
        return jsonDecode(otherConfigStr.base64());
      }
      return jsonDecode(data);
    }catch(e){
      return jsonDecode(otherConfigStr.base64());
    }
  }
}