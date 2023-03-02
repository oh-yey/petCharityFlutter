import 'package:pet_charity/models/abstract/list_result.dart';
import 'package:pet_charity/models/donate/pet_donate.dart';

class PetDonateList extends ListResult<PetDonate> {
  PetDonateList.fromJson(dynamic json) : super(json['count'], json['previous'], json['next']) {
    if (json['results'] != null) {
      results = [];
      json['results'].forEach((v) {
        results?.add(PetDonate.fromJson(v));
      });
    }
  }
}
