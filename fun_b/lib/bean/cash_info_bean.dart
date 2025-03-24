class CashInfoBean {
  CashInfoBean({
      this.cashType, 
      this.cashMoney, 
      this.taskIndex, 
      this.currentPro, 
      this.totalPro, 
      this.rankNum,
      this.cashStatus,
      this.rankAllPerson,
  });

  CashInfoBean.fromJson(dynamic json) {
    cashType = json['cashType'];
    cashMoney = json['cashMoney'];
    taskIndex = json['taskIndex'];
    currentPro = json['currentPro'];
    totalPro = json['totalPro'];
    rankNum = json['rankNum'];
    cashStatus = json['cashStatus'];
    rankAllPerson = json['rankAllPerson'];
  }
  int? cashType;
  int? cashMoney;
  int? taskIndex;
  int? currentPro;
  int? totalPro;
  int? rankNum;
  int? rankAllPerson;
  String? cashStatus;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['cashType'] = cashType;
    map['cashMoney'] = cashMoney;
    map['taskIndex'] = taskIndex;
    map['currentPro'] = currentPro;
    map['totalPro'] = totalPro;
    map['rankNum'] = rankNum;
    map['cashStatus'] = cashStatus;
    map['rankAllPerson'] = rankAllPerson;
    return map;
  }

}