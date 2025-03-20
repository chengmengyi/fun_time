
import 'dart:convert';

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
import 'package:fun_base/util/sql/base_sql_hep.dart';
import 'package:fun_base/util/sql/sql_table_name.dart';
import 'package:fun_base/util/util.dart';

class CashStatus{
  static const String cashing="cashing";
  static const String ranking="ranking";
  static const String success="success";
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
    _otherConfigBean=OtherConfigBean.fromJson(jsonDecode(otherConfigStr.base64()));
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
      widget: AccountDialog(),
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
    var bean = CashInfoBean(cashType: cashType,cashMoney: cashMoney,taskIndex: 0,currentPro: 0,totalPro: getConfigTaskByIndex(0)?.data??0,rankNum: 0,cashStatus:CashStatus.cashing);
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
      if(getConfigTaskByIndex(taskIndex)?.title==cashTaskType&&currentPro<totalPro){
        if(currentPro==totalPro-1){
          if(checkIsLastTask(taskIndex)){
            newMap["currentPro"]=currentPro+1;
            newMap["cashStatus"]=CashStatus.ranking;
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
      return _otherConfigBean?.tixianTask?[index+1];
    }catch(e){
      return null;
    }
  }

  bool checkIsLastTask(int taskIndex)=>taskIndex==(_otherConfigBean?.tixianTask??[]).length-1;

  List<int> getConfigCashMoneyList()=>_otherConfigBean?.withdrawRange??[1000,1500,1800,2000];
}