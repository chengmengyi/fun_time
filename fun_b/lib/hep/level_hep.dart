import 'package:fun_b/bean/level_data.dart';
import 'package:fun_base/util/sql/base_sql_hep.dart';
import 'package:fun_base/util/sql/sql_table_name.dart';

class LevelStatus{
  static const int normal=0;
  static const int canReceive=1;
  static const int received=2;
}

enum UpdateLevelStatusType{
  singleStatus,doubleStatus,all
}

class LevelHep {
  static final LevelHep _instance=LevelHep();
  static LevelHep get instance => _instance;

  initLevelData()async{
    var sql = await BaseSqlHep.instance.initSql();
    for (int i = 0; i < 36; i++) {
      sql.insert(SqlTableName.levelB, {"levelNum":i+1,"singleStatus":LevelStatus.normal,"doubleStatus":LevelStatus.normal});
    }
  }

  Future<List<LevelData>> getLevelList()async{
    var sql = await BaseSqlHep.instance.initSql();
    var list = await sql.query(SqlTableName.levelB);
    List<LevelData> resultList=[];
    for (var value in list) {
      resultList.add(LevelData.fromJson(value));
    }
    return resultList;
  }

  updateLevelData(int nowLevel,int status,UpdateLevelStatusType statueType)async{
    var sql = await BaseSqlHep.instance.initSql();
    var list = await sql.query(SqlTableName.levelB,where: '"levelNum" = ?',whereArgs: [nowLevel]);
    if(list.isEmpty){
      return;
    }
    var newMap = Map<String, Object?>.from(list.first);
    if(statueType==UpdateLevelStatusType.singleStatus){
      newMap["singleStatus"]=status;
    }
    if(statueType==UpdateLevelStatusType.doubleStatus){
      newMap["doubleStatus"]=status;
    }
    if(statueType==UpdateLevelStatusType.all){
      newMap["singleStatus"]=status;
      newMap["doubleStatus"]=status;
    }

    await sql.update(SqlTableName.levelB, newMap,where: '"id" = ? ',whereArgs: [newMap["id"]]);
  }
} 