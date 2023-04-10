class Classification {
  Classification({num? id, String? classification}) {
    _id = id;
    _classification = classification;
  }

  Classification.fromJson(dynamic json) {
    _id = json['id'];
    _classification = json['classification'];
  }

  num? _id;
  String? _classification;

  num? get id => _id;

  String? get classification => _classification;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['classification'] = _classification;
    return map;
  }
}
