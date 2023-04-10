import 'package:pet_charity/models/mixin/collect.dart';
import 'package:pet_charity/models/model.dart';
import 'package:pet_charity/models/question/classification.dart';
import 'package:pet_charity/models/user/user.dart';

class Question extends Model with Collect {
  Question({
    num? id,
    User? user,
    String? newAnswer,
    String? question,
    String? createTime,
    int? answerCount,
    Classification? classification,
    num? collectCount,
    bool? isCollect,
  }) {
    _id = id;
    _user = user;
    _newAnswer = newAnswer;
    _question = question;
    _createTime = createTime;
    _answerCount = answerCount;
    _classification = classification;
    this.collectCount = collectCount;
    this.isCollect = isCollect;
  }

  Question.fromJson(dynamic json) {
    _id = json['id'];
    _user = json['user'] != null ? User.fromJson(json['user']) : null;
    _newAnswer = json['newAnswer'];
    _question = json['question'];
    _createTime = json['create_time'];
    _answerCount = json['answerCount'];
    _classification = json['classification'] != null ? Classification.fromJson(json['classification']) : null;
    collectFromJson(json);
  }

  num? _id;
  User? _user;
  String? _newAnswer;
  String? _question;
  String? _createTime;
  num? _answerCount;
  Classification? _classification;

  num? get id => _id;

  User? get user => _user;

  String? get newAnswer => _newAnswer;

  String? get question => _question;

  num? get answerCount => _answerCount;

  String? get createTime => _createTime;

  Classification? get classification => _classification;

  @override
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    if (_user != null) {
      map['user'] = _user?.toJson();
    }
    map['newAnswer'] = _newAnswer;
    map['question'] = _question;
    map['create_time'] = _createTime;
    map['answerCount'] = _answerCount;
    if (_classification != null) {
      map['classification'] = _classification?.toJson();
    }
    collectToJson(map);
    return map;
  }
}
