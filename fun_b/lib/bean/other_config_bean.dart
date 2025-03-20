class OtherConfigBean {
  OtherConfigBean({
      this.withdrawRange, 
      this.cashAll, 
      this.cashCurrent, 
      this.intadPoint, 
      this.floatPrize, 
      this.boxPrize, 
      this.tixianTask,});

  OtherConfigBean.fromJson(dynamic json) {
    withdrawRange = json['withdraw_range'] != null ? json['withdraw_range'].cast<int>() : [];
    cashAll = json['cash_all'] != null ? CashAll.fromJson(json['cash_all']) : null;
    cashCurrent = json['cash_current'] != null ? CashCurrent.fromJson(json['cash_current']) : null;
    if (json['intad_point'] != null) {
      intadPoint = [];
      json['intad_point'].forEach((v) {
        intadPoint?.add(IntadPoint.fromJson(v));
      });
    }
    if (json['float_prize'] != null) {
      floatPrize = [];
      json['float_prize'].forEach((v) {
        floatPrize?.add(FloatPrize.fromJson(v));
      });
    }
    if (json['box_prize'] != null) {
      boxPrize = [];
      json['box_prize'].forEach((v) {
        boxPrize?.add(BoxPrize.fromJson(v));
      });
    }
    if (json['tixian_task'] != null) {
      tixianTask = [];
      json['tixian_task'].forEach((v) {
        tixianTask?.add(TixianTask.fromJson(v));
      });
    }
  }
  List<int>? withdrawRange;
  CashAll? cashAll;
  CashCurrent? cashCurrent;
  List<IntadPoint>? intadPoint;
  List<FloatPrize>? floatPrize;
  List<BoxPrize>? boxPrize;
  List<TixianTask>? tixianTask;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['withdraw_range'] = withdrawRange;
    if (cashAll != null) {
      map['cash_all'] = cashAll?.toJson();
    }
    if (cashCurrent != null) {
      map['cash_current'] = cashCurrent?.toJson();
    }
    if (intadPoint != null) {
      map['intad_point'] = intadPoint?.map((v) => v.toJson()).toList();
    }
    if (floatPrize != null) {
      map['float_prize'] = floatPrize?.map((v) => v.toJson()).toList();
    }
    if (boxPrize != null) {
      map['box_prize'] = boxPrize?.map((v) => v.toJson()).toList();
    }
    if (tixianTask != null) {
      map['tixian_task'] = tixianTask?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class TixianTask {
  TixianTask({
      this.title, 
      this.data,});

  TixianTask.fromJson(dynamic json) {
    title = json['title'];
    data = json['data'];
  }
  String? title;
  int? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = title;
    map['data'] = data;
    return map;
  }

}

class BoxPrize {
  BoxPrize({
      this.firstNumber, 
      this.prize, 
      this.endNumber,});

  BoxPrize.fromJson(dynamic json) {
    firstNumber = json['first_number'];
    prize = json['prize'] != null ? json['prize'].cast<int>() : [];
    endNumber = json['end_number'];
  }
  int? firstNumber;
  List<int>? prize;
  int? endNumber;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['first_number'] = firstNumber;
    map['prize'] = prize;
    map['end_number'] = endNumber;
    return map;
  }

}

class FloatPrize {
  FloatPrize({
      this.firstNumber, 
      this.prize, 
      this.endNumber,});

  FloatPrize.fromJson(dynamic json) {
    firstNumber = json['first_number'];
    prize = json['prize'] != null ? json['prize'].cast<int>() : [];
    endNumber = json['end_number'];
  }
  int? firstNumber;
  List<int>? prize;
  int? endNumber;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['first_number'] = firstNumber;
    map['prize'] = prize;
    map['end_number'] = endNumber;
    return map;
  }

}

class IntadPoint {
  IntadPoint({
      this.firstNumber, 
      this.point, 
      this.endNumber,});

  IntadPoint.fromJson(dynamic json) {
    firstNumber = json['first_number'];
    point = json['point'];
    endNumber = json['end_number'];
  }
  int? firstNumber;
  int? point;
  int? endNumber;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['first_number'] = firstNumber;
    map['point'] = point;
    map['end_number'] = endNumber;
    return map;
  }

}

class CashCurrent {
  CashCurrent({
      this.intCurrent, 
      this.intCurrentDelete,});

  CashCurrent.fromJson(dynamic json) {
    intCurrent = json['int_current'];
    intCurrentDelete = json['int_current_delete'] != null ? json['int_current_delete'].cast<int>() : [];
  }
  int? intCurrent;
  List<int>? intCurrentDelete;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['int_current'] = intCurrent;
    map['int_current_delete'] = intCurrentDelete;
    return map;
  }

}

class CashAll {
  CashAll({
      this.intAll, 
      this.intAllDelete,});

  CashAll.fromJson(dynamic json) {
    intAll = json['int_all'];
    intAllDelete = json['int_all_delete'] != null ? json['int_all_delete'].cast<int>() : [];
  }
  int? intAll;
  List<int>? intAllDelete;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['int_all'] = intAll;
    map['int_all_delete'] = intAllDelete;
    return map;
  }

}