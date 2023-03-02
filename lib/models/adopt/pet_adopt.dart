import 'package:pet_charity/models/mixin/collect.dart';
import 'package:pet_charity/models/model.dart';
import 'package:pet_charity/models/pet/pet.dart';

class PetAdopt extends Model with Collect {
  PetAdopt({
    num? id,
    String? stateValue,
    Pet? pet,
    String? title,
    String? description,
    String? requirements,
    String? createTime,
    num? collectCount,
    bool? isCollect,
  }) {
    _id = id;
    _pet = pet;
    _title = title;
    _description = description;
    _requirements = requirements;
    _createTime = createTime;
    this.collectCount = collectCount;
    this.isCollect = isCollect;
  }

  PetAdopt.fromJson(dynamic json) {
    _id = json['id'];
    _pet = json['pet'] != null ? Pet.fromJson(json['pet']) : null;
    _title = json['title'];
    _description = json['description'];
    _requirements = json['requirements'];
    _createTime = json['create_time'];
    collectFromJson(json);
  }

  num? _id;
  Pet? _pet;
  String? _title;
  String? _description;
  String? _requirements;
  String? _createTime;

  num? get id => _id;

  Pet? get pet => _pet;

  String? get title => _title;

  String? get description => _description;

  String? get requirements => _requirements;

  String? get createTime => _createTime;

  @override
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    if (_pet != null) {
      map['pet'] = _pet?.toJson();
    }
    map['title'] = _title;
    map['description'] = _description;
    map['requirements'] = _requirements;

    map['create_time'] = _createTime;
    collectToJson(map);
    return map;
  }
}
