class Contact {
  Contact({num? id, String? phone, String? mail, String? qq, String? wechat, String? createTime}) {
    _id = id;
    _phone = phone;
    _mail = mail;
    _qq = qq;
    _wechat = wechat;
    _createTime = createTime;
  }

  Contact.fromJson(dynamic json) {
    _id = json['id'];
    _phone = json['phone'];
    _mail = json['mail'];
    _qq = json['qq'];
    _wechat = json['wechat'];
    _createTime = json['create_time'];
  }

  num? _id;
  String? _phone;
  String? _mail;
  String? _qq;
  String? _wechat;
  String? _createTime;

  num? get id => _id;

  String? get phone => _phone;

  String? get mail => _mail;

  String? get qq => _qq;

  String? get wechat => _wechat;

  String? get createTime => _createTime;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['phone'] = _phone;
    map['mail'] = _mail;
    map['qq'] = _qq;
    map['wechat'] = _wechat;
    map['create_time'] = _createTime;
    return map;
  }
}
