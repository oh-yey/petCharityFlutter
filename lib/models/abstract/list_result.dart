import 'package:pet_charity/models/model.dart';

abstract class ListResult<T extends Model> {
  num? count;
  String? previous;
  String? next;
  List<T>? results;

  ListResult(this.count, this.previous, this.next);

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['count'] = count;
    map['next'] = next;
    map['previous'] = previous;
    if (results != null) {
      map['results'] = results?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
