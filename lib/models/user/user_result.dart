import 'package:pet_charity/models/abstract/data_result.dart';
import 'package:pet_charity/models/user/user.dart';

class UserResult extends DataResult<User> {
  UserResult.fromJson(dynamic json) : super(json['code'], json['detail']) {
    data = json['data'] != null ? User.fromJson(json['data']) : null;
  }
}
