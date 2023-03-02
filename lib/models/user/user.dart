import 'package:pet_charity/models/address/area.dart';
import 'package:pet_charity/models/model.dart';
import 'package:pet_charity/models/user/contact.dart';

class User extends Model {
  num? _id;
  String? _sexValue;
  String? _identityValue;
  bool? _verified;
  num? _followingCount;
  num? _followersCount;
  num? _commentLikeCount;
  num? _collectCount;
  String? _token;
  String? _nickname;
  String? _phone;
  String? _qq;
  num? _sex;
  num? _identity;
  String? _introduction;
  String? _head;
  double? _balance;
  String? _realName;
  String? _createTime;
  Area? _area;
  Contact? _contact;

  num? get id => _id;

  String? get sexValue => _sexValue;

  String? get identityValue => _identityValue;

  bool? get verified => _verified;

  num? get followingCount => _followingCount;

  num? get followersCount => _followersCount;

  num? get commentLikeCount => _commentLikeCount;

  num? get collectCount => _collectCount;

  String? get token => _token;

  String? get nickname => _nickname;

  String? get phone => _phone;

  String? get qq => _qq;

  num? get sex => _sex;

  num? get identity => _identity;

  String? get introduction => _introduction;

  String? get head => _head;

  double? get balance => _balance;

  String? get realName => _realName;

  String? get createTime => _createTime;

  Area? get area => _area;

  Contact? get contact => _contact;

  User({
    num? id,
    String? sexValue,
    String? identityValue,
    bool? verified,
    num? followingCount,
    num? followersCount,
    num? commentLikeCount,
    num? collectCount,
    String? token,
    String? nickname,
    String? phone,
    String? qq,
    num? sex,
    num? identity,
    String? introduction,
    String? head,
    double? balance,
    String? realName,
    String? createTime,
    Area? area,
    Contact? contact,
  }) {
    _id = id;
    _sexValue = sexValue;
    _identityValue = identityValue;
    _verified = verified;
    _followingCount = followingCount;
    _followersCount = followersCount;
    _commentLikeCount = commentLikeCount;
    _collectCount = collectCount;
    _token = token;
    _nickname = nickname;
    _phone = phone;
    _qq = qq;
    _sex = sex;
    _identity = identity;
    _introduction = introduction;
    _head = head;
    _balance = balance;
    _realName = realName;
    _createTime = createTime;
    _area = area;
    _contact = contact;
  }

  User.fromJson(dynamic json) {
    _id = json['id'];
    _sexValue = json['sex_value'];
    _identityValue = json['identity_value'];
    _verified = json['verified'];
    _followingCount = json['following_count'];
    _followersCount = json['followers_count'];
    _commentLikeCount = json['comment_like_count'];
    _collectCount = json['collect_count'];
    _token = json['token'];
    _nickname = json['nickname'];
    _phone = json['phone'];
    _qq = json['qq'];
    _sex = json['sex'];
    _identity = json['identity'];
    _introduction = json['introduction'];
    _head = json['head'];
    _balance = double.parse('${json['balance'] ?? 0}');
    _realName = json['real_name'];
    _createTime = json['create_time'];
    _area = json['area'] != null ? Area.fromJson(json['area']) : null;
    _contact = json['contact'] != null ? Contact.fromJson(json['contact']) : null;
  }

  @override
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['sex_value'] = _sexValue;
    map['identity_value'] = _identityValue;
    map['verified'] = _verified;
    map['following_count'] = _followingCount;
    map['followers_count'] = _followersCount;
    map['comment_like_count'] = _commentLikeCount;
    map['collect_count'] = _collectCount;
    map['token'] = _token;
    map['nickname'] = _nickname;
    map['phone'] = _phone;
    map['qq'] = _qq;
    map['sex'] = _sex;
    map['identity'] = _identity;
    map['introduction'] = _introduction;
    map['head'] = _head;
    map['balance'] = _balance;
    map['real_name'] = _realName;
    map['create_time'] = _createTime;
    if (_area != null) {
      map['area'] = _area?.toJson();
    }
    if (_contact != null) {
      map['contact'] = _contact?.toJson();
    }
    return map;
  }
}
