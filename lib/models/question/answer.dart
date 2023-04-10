import 'package:pet_charity/models/model.dart';
import 'package:pet_charity/models/user/user.dart';

class Answer extends Model {
  Answer({num? id, User? user, String? answer, String? createTime}) {
    _id = id;
    _user = user;
    _answer = answer;
    _createTime = createTime;
  }

  Answer.fromJson(dynamic json) {
    _id = json['id'];
    _user = json['user'] != null ? User.fromJson(json['user']) : null;
    _answer = json['answer'];
    _createTime = json['create_time'];
  }

  num? _id;
  User? _user;
  String? _answer;
  String? _createTime;

  num? get id => _id;

  User? get user => _user;

  String? get answer => _answer;

  String? get createTime => _createTime;

  @override
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    if (_user != null) {
      map['user'] = _user?.toJson();
    }
    map['answer'] = _answer;
    map['create_time'] = _createTime;
    return map;
  }
}
