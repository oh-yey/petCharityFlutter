import 'package:pet_charity/models/abstract/list_result.dart';
import 'package:pet_charity/models/user/followers.dart';

class FollowersList extends ListResult<Followers> {
  FollowersList.fromJson(dynamic json) : super(json['count'], json['previous'], json['next']) {
    if (json['results'] != null) {
      results = [];
      json['results'].forEach((v) {
        results?.add(Followers.fromJson(v));
      });
    }
  }
}
