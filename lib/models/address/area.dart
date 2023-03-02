import 'package:pet_charity/models/address/city.dart';

class Area {
  int? _id;
  String? _area;
  City? _belongCity;

  int? get id => _id;

  String? get area => _area;

  City? get belongCity => _belongCity;

  Area({int? id, String? area, City? belongCity}) {
    _id = id;
    _area = area;
    _belongCity = belongCity;
  }

  Area.fromJson(dynamic json) {
    _id = json['id'];
    _area = json['area'];
    _belongCity = json['belong_city'] != null ? City.fromJson(json['belong_city']) : null;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['area'] = _area;
    if (_belongCity != null) map['belong_city'] = _belongCity?.toJson();

    return map;
  }
}
