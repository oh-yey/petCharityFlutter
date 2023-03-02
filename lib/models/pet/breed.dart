class Breed {
  Breed({num? id, String? name, this.race, String? path, String? variety}) {
    _id = id;
    _name = name;
    _path = path;
    _variety = variety;
  }

  Breed.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    race = json['race'];
    _path = json['path'];
    _variety = json['variety'];
  }

  num? _id;
  String? _name;
  num? race;
  String? _path;
  String? _variety;

  num? get id => _id;

  String? get name => _name;

  String? get path => _path;

  String? get variety => _variety;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['race'] = race;
    map['path'] = _path;
    map['variety'] = _variety;
    return map;
  }
}
