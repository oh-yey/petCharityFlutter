class Detail {
  num? code;
  bool? whether;
  String? detail;

  Detail(this.code, this.whether, this.detail);

  Detail.fromJson(dynamic json) {
    code = json['code'];
    whether = json['whether'];
    detail = json['detail'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code'] = code;
    map['whether'] = whether;
    map['detail'] = detail;
    return map;
  }
}
