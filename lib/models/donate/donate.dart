import 'package:pet_charity/models/model.dart';
import 'package:pet_charity/models/user/user.dart';

class Donate extends Model {
  Donate({num? id, User? user, num? amount, String? order, String? remarks, String? donateTime, num? donate}) {
    _id = id;
    _user = user;
    _amount = amount;
    _order = order;
    _remarks = remarks;
    _donateTime = donateTime;
    _donate = donate;
  }

  Donate.fromJson(dynamic json) {
    _id = json['id'];
    _user = json['user'] != null ? User.fromJson(json['user']) : null;
    _amount = json['amount'];
    _order = json['order'];
    _remarks = json['remarks'];
    _donateTime = json['donate_time'];
    _donate = json['donate'];
  }

  num? _id;
  User? _user;
  num? _amount;
  String? _order;
  String? _remarks;
  String? _donateTime;
  num? _donate;

  num? get id => _id;

  User? get user => _user;

  num? get amount => _amount;

  String? get order => _order;

  String? get remarks => _remarks;

  String? get donateTime => _donateTime;

  num? get donate => _donate;

  @override
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    if (_user != null) {
      map['user'] = _user?.toJson();
    }
    map['amount'] = _amount;
    map['order'] = _order;
    map['remarks'] = _remarks;
    map['donate_time'] = _donateTime;
    map['donate'] = _donate;
    return map;
  }
}
