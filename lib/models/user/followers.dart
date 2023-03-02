import 'package:pet_charity/models/model.dart';
import 'package:pet_charity/models/user/user.dart';

class Followers extends Model {
  Followers({num? id, User? followers, User? following, String? time}) {
    _id = id;
    _followers = followers;
    _following = following;
    _time = time;
  }

  Followers.fromJson(dynamic json) {
    _id = json['id'];
    _followers = json['followers'] != null ? User.fromJson(json['followers']) : null;
    _following = json['following'] != null ? User.fromJson(json['following']) : null;
    _time = json['time'];
  }

  num? _id;
  User? _followers;
  User? _following;
  String? _time;

  num? get id => _id;

  User? get followers => _followers;

  User? get following => _following;

  String? get time => _time;

  @override
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    if (_followers != null) {
      map['followers'] = _followers?.toJson();
    }
    if (_following != null) {
      map['following'] = _following?.toJson();
    }
    map['time'] = _time;
    return map;
  }
}
