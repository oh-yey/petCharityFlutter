import 'package:pet_charity/models/abstract/list_result.dart';
import 'package:pet_charity/models/question/answer.dart';

class AnswerList extends ListResult<Answer> {
  AnswerList.fromJson(dynamic json) : super(json['count'], json['previous'], json['next']) {
    if (json['results'] != null) {
      results = [];
      json['results'].forEach((v) {
        results?.add(Answer.fromJson(v));
      });
    }
  }
}
