import 'dart:convert';

import 'package:fun_base/util/sql/sql_table_name.dart';
import 'package:sqflite/sqflite.dart';

class BaseSqlHep{
  static final BaseSqlHep _instance = BaseSqlHep();
  static BaseSqlHep get instance => _instance;


  Future<Database> initSql()async{
    var database = await openDatabase(
        "ft.db",
        version: 1,
        onCreate: (db,version)async{
          db.execute('CREATE TABLE ${SqlTableName.userInfoA} (id INTEGER PRIMARY KEY AUTOINCREMENT, coinsNum INTEGER, diamondNum INTEGER, winnerGamePlayNum INTEGER, fruitMatchPlayNum INTEGER, chasingLuckPlayNum INTEGER, casinoRushPlayNum INTEGER, winOrLosePlayNum INTEGER, luckyNumberPlayNum INTEGER, bettingHighPlayNum INTEGER)');
          db.execute('CREATE TABLE ${SqlTableName.playedNumA} (id INTEGER PRIMARY KEY AUTOINCREMENT, playedNum INTEGER, startTime INTEGER, gameType TEXT)');
          db.execute('CREATE TABLE ${SqlTableName.achA} (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, currentPro INTEGER, totalPro INTEGER,achType TEXT,status INTEGER)');

          _createVersion2DB(db);
        },
        onUpgrade: (db,oldVersion,newVersion){
          if(newVersion==2){
            _createVersion2DB(db);
          }
        }
    );
    return database;
  }

  _createVersion2DB(Database db){
    db.execute('CREATE TABLE ${SqlTableName.userInfoB} (id INTEGER PRIMARY KEY AUTOINCREMENT, coinsNum DOUBLE, diamondNum INTEGER, winnerGamePlayNum INTEGER, fruitMatchPlayNum INTEGER, chasingLuckPlayNum INTEGER, casinoRushPlayNum INTEGER, winOrLosePlayNum INTEGER, luckyNumberPlayNum INTEGER, bettingHighPlayNum INTEGER)');
    db.execute('CREATE TABLE ${SqlTableName.playedNumB} (id INTEGER PRIMARY KEY AUTOINCREMENT, playedNum INTEGER, startTime INTEGER, gameType TEXT)');
    db.execute('CREATE TABLE ${SqlTableName.levelB} (id INTEGER PRIMARY KEY AUTOINCREMENT, levelNum INTEGER, singleStatus INTEGER,doubleStatus INTEGER)');
    db.execute('CREATE TABLE ${SqlTableName.cashListB} (id INTEGER PRIMARY KEY AUTOINCREMENT, cashType INTEGER, cashMoney INTEGER, taskIndex INTEGER, currentPro INTEGER, totalPro INTEGER,rankNum INTEGER,cashStatus TEXT,rankAllPerson INTEGER)');
    db.execute('CREATE TABLE ${SqlTableName.rankListB} (id INTEGER PRIMARY KEY AUTOINCREMENT, userId TEXT,account TEXT,amount INTEGER)');
    db.execute('CREATE TABLE ${SqlTableName.cashAccountB} (id INTEGER PRIMARY KEY AUTOINCREMENT, account TEXT,cashType INTEGER)');
    db.execute('CREATE TABLE ${SqlTableName.tbaPointB} (id INTEGER PRIMARY KEY AUTOINCREMENT, tbaPointJsonStr TEXT)');
  }

  insertTbaPointJson(Map<String,dynamic> map)async{
    var sql = await initSql();
    print("kkk===insert=${map}");
    sql.insert(SqlTableName.tbaPointB, {"tbaPointJsonStr":jsonEncode(map)});
  }

  Future<List<Map<String,dynamic>>> queryTbaPoint()async{
    var sql = await initSql();
    var list = await sql.query(SqlTableName.tbaPointB);
    if(list.isEmpty){
      return [];
    }
    List<Map<String,dynamic>> resultList=[];
    for (var value in list) {
      resultList.add(jsonDecode(value["tbaPointJsonStr"] as String));
    }
    return resultList;
  }

  deleteTbaData()async{
    var sql = await initSql();
    sql.delete(SqlTableName.tbaPointB);
  }
}