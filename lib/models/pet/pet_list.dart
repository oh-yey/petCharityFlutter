import 'package:pet_charity/models/abstract/list_result.dart';
import 'package:pet_charity/models/pet/pet.dart';

class PetList extends ListResult<Pet> {
  PetList.fromJson(dynamic json) : super(json['count'], json['previous'], json['next']) {
    if (json['results'] != null) {
      results = [];
      json['results'].forEach((v) {
        results?.add(Pet.fromJson(v));
      });
    }
  }
}
