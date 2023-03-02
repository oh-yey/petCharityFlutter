import 'package:pet_charity/models/model.dart';

abstract class DataResult<T extends Model> {
  num? code;
  String? detail;
  T? data;

  DataResult(this.code, this.detail);

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code'] = code;
    map['detail'] = detail;
    if (data != null) map['data'] = data?.toJson();
    return map;
  }
}
