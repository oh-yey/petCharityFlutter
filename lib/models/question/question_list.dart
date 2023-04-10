import 'package:pet_charity/models/abstract/list_result.dart';
import 'package:pet_charity/models/question/question.dart';

class QuestionList extends ListResult<Question> {
  QuestionList.fromJson(dynamic json) : super(json['count'], json['previous'], json['next']) {
    if (json['results'] != null) {
      results = [];
      json['results'].forEach((v) {
        results?.add(Question.fromJson(v));
      });
    }
  }
}
