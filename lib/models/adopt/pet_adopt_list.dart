import 'package:pet_charity/models/abstract/list_result.dart';
import 'package:pet_charity/models/adopt/pet_adopt.dart';

class PetAdoptList extends ListResult<PetAdopt> {
  PetAdoptList.fromJson(dynamic json) : super(json['count'], json['previous'], json['next']) {
    if (json['results'] != null) {
      results = [];
      json['results'].forEach((v) {
        results?.add(PetAdopt.fromJson(v));
      });
    }
  }
}
