class Province {
  int? _id;
  String? _province;

  int? get id => _id;

  String? get province => _province;

  Province({int? id, String? province}) {
    _id = id;
    _province = province;
  }

  Province.fromJson(dynamic json) {
    _id = json['id'];
    _province = json['province'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['province'] = _province;
    return map;
  }
}
