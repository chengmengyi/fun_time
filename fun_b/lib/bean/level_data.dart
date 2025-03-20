class LevelData {
  LevelData({
      this.levelNum, 
      this.status,});

  LevelData.fromJson(dynamic json) {
    levelNum = json['levelNum'];
    status = json['status'];
  }
  int? levelNum;
  int? status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['levelNum'] = levelNum;
    map['status'] = status;
    return map;
  }

}