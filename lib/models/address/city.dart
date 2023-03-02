import 'package:pet_charity/models/address/province.dart';

class City {
  int? _id;
  String? _city;
  Province? _belongProvince;

  num? get id => _id;

  String? get city => _city;

  Province? get belongProvince => _belongProvince;

  City({int? id, String? city, Province? belongProvince}) {
    _id = id;
    _city = city;
    _belongProvince = belongProvince;
  }

  City.fromJson(dynamic json) {
    _id = json['id'];
    _city = json['city'];
    _belongProvince = json['belong_province'] != null ? Province.fromJson(json['belong_province']) : null;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['city'] = _city;
    if (_belongProvince != null) map['belong_province'] = _belongProvince?.toJson();
    return map;
  }
}
