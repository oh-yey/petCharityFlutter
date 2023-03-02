import 'package:pet_charity/models/pet/breed.dart';

class FilterResult {
  num? sex;
  Breed? breed;

  FilterResult(this.sex, this.breed);

  FilterResult.fromJson(dynamic json) {
    sex = json['sex'];
    if (json['breed'] != null) {
      breed = Breed.fromJson(json['breed']);
    }
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['sex'] = sex;
    map['breed'] = breed?.toJson();
    return map;
  }
}
