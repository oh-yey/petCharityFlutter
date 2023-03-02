import 'package:pet_charity/models/model.dart';

class Statistics extends Model {
  Statistics({num? count, num? donateCount, num? amount}) {
    _count = count;
    _donateCount = donateCount;
    _amount = amount;
  }

  Statistics.fromJson(dynamic json) {
    _count = json['count'];
    _donateCount = json['donateCount'];
    _amount = json['amount'];
  }

  num? _count;
  num? _donateCount;
  num? _amount;

  num? get count => _count;

  num? get donateCount => _donateCount;

  num? get amount => _amount;

  @override
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['count'] = _count;
    map['donateCount'] = _donateCount;
    map['amount'] = _amount;
    return map;
  }
}
