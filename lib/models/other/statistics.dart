import 'package:pet_charity/models/model.dart';

class Statistics extends Model {
  Statistics({num? userCount, num? donateCount, num? donateAmount}) {
    _userCount = userCount;
    _donateCount = donateCount;
    _donateAmount = donateAmount;
  }

  Statistics.fromJson(dynamic json) {
    _userCount = json['userCount'];
    _donateCount = json['donateCount'];
    _donateAmount = json['donateAmount'];
  }

  num? _userCount;
  num? _donateCount;
  num? _donateAmount;

  num? get userCount => _userCount;

  num? get donateCount => _donateCount;

  num? get donateAmount => _donateAmount;

  @override
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['userCount'] = _userCount;
    map['donateCount'] = _donateCount;
    map['donateAmount'] = _donateAmount;
    return map;
  }
}
