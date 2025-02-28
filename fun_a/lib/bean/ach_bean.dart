class AchBean {
  AchBean({
      this.title, 
      this.currentPro, 
      this.totalPro, 
      this.achType, 
      this.status,});

  AchBean.fromJson(dynamic json) {
    title = json['title'];
    currentPro = json['currentPro'];
    totalPro = json['totalPro'];
    achType = json['achType'];
    status = json['status'];
  }
  String? title;
  int? currentPro;
  int? totalPro;
  String? achType;
  int? status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = title;
    map['currentPro'] = currentPro;
    map['totalPro'] = totalPro;
    map['achType'] = achType;
    map['status'] = status;
    return map;
  }

}