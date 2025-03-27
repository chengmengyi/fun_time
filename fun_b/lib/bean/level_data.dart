class LevelData {
  LevelData({
      this.levelNum, 
      this.singleStatus,
      this.doubleStatus,
  });

  LevelData.fromJson(dynamic json) {
    levelNum = json['levelNum'];
    singleStatus = json['singleStatus'];
    doubleStatus = json['doubleStatus'];
  }

  int? levelNum;
  int? singleStatus;
  int? doubleStatus;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['levelNum'] = levelNum;
    map['singleStatus'] = singleStatus;
    map['doubleStatus'] = doubleStatus;
    return map;
  }

}