import 'package:pet_charity/models/mixin/collect.dart';
import 'package:pet_charity/models/donate/donate.dart';
import 'package:pet_charity/models/model.dart';
import 'package:pet_charity/models/pet/breed.dart';
import 'package:pet_charity/models/pet/pet_images.dart';

class PetDonate extends Model with Collect {
  PetDonate({
    num? id,
    String? sexValue,
    List<PetImages>? images,
    PetImages? coverImage,
    List<Donate>? donationList,
    num? alreadyAmount,
    num? alreadyPeopleCount,
    num? sex,
    String? name,
    double? weight,
    String? birth,
    String? description,
    num? amount,
    num? state,
    String? createTime,
    String? publishTime,
    String? finishTime,
    Breed? breed,
    num? collectCount,
    bool? isCollect,
  }) {
    _id = id;
    _sexValue = sexValue;
    _images = images;
    _coverImage = coverImage;
    _donationList = donationList;
    _alreadyAmount = alreadyAmount;
    _alreadyPeopleCount = alreadyPeopleCount;
    _sex = sex;
    _name = name;
    _weight = weight;
    _birth = birth;
    _description = description;
    _amount = amount;
    _state = state;
    _createTime = createTime;
    _publishTime = publishTime;
    _finishTime = finishTime;
    _breed = breed;
    this.collectCount = collectCount;
    this.isCollect = isCollect;
  }

  PetDonate.fromJson(dynamic json) {
    _id = json['id'];
    _sexValue = json['sex_value'];
    if (json['images'] != null) {
      _images = [];
      json['images'].forEach((v) {
        _images?.add(PetImages.fromJson(v));
      });
    }
    _coverImage = json['cover_image'] != null ? PetImages.fromJson(json['cover_image']) : null;
    if (json['donation_list'] != null) {
      _donationList = [];
      json['donation_list'].forEach((v) {
        _donationList?.add(Donate.fromJson(v));
      });
    }
    _alreadyAmount = json['already_amount'];
    _alreadyPeopleCount = json['already_people_count'];
    _sex = json['sex'];
    _name = json['name'];
    _weight = double.parse('${json['weight'] ?? 0}');
    _birth = json['birth'];
    _description = json['description'];
    _amount = json['amount'];
    _state = json['state'];
    _createTime = json['create_time'];
    _publishTime = json['publish_time'];
    _finishTime = json['finish_time'];
    _breed = json['breed'] != null ? Breed.fromJson(json['breed']) : null;
    collectFromJson(json);
  }

  num? _id;
  String? _sexValue;
  List<PetImages>? _images;
  PetImages? _coverImage;
  List<Donate>? _donationList;
  num? _alreadyAmount;
  num? _alreadyPeopleCount;
  num? _sex;
  String? _name;
  double? _weight;
  String? _birth;
  String? _description;
  num? _amount;
  num? _state;
  String? _createTime;
  String? _publishTime;
  String? _finishTime;
  Breed? _breed;

  num? get id => _id;

  String? get sexValue => _sexValue;

  List<PetImages>? get images => _images;

  PetImages? get coverImage => _coverImage;

  List<Donate>? get donationList => _donationList;

  num? get alreadyAmount => _alreadyAmount;

  set alreadyAmount(alreadyAmount) {
    _alreadyAmount = alreadyAmount;
  }

  num? get alreadyPeopleCount => _alreadyPeopleCount;

  set alreadyPeopleCount(alreadyPeopleCount) {
    _alreadyPeopleCount = alreadyPeopleCount;
  }

  num? get sex => _sex;

  String? get name => _name;

  double? get weight => _weight;

  String? get birth => _birth;

  String? get description => _description;

  num? get amount => _amount;

  num? get state => _state;

  String? get createTime => _createTime;

  String? get publishTime => _publishTime;

  String? get finishTime => _finishTime;

  Breed? get breed => _breed;

  @override
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['sex_value'] = _sexValue;
    if (_images != null) {
      map['images'] = _images?.map((v) => v.toJson()).toList();
    }
    if (_coverImage != null) {
      map['cover_image'] = _coverImage?.toJson();
    }
    if (_donationList != null) {
      map['donation_list'] = _donationList?.map((v) => v.toJson()).toList();
    }
    map['already_amount'] = _alreadyAmount;
    map['already_people_count'] = _alreadyPeopleCount;
    map['sex'] = _sex;
    map['name'] = _name;
    map['weight'] = _weight;
    map['birth'] = _birth;
    map['description'] = _description;
    map['amount'] = _amount;
    map['state'] = _state;
    map['create_time'] = _createTime;
    map['publish_time'] = _publishTime;
    map['finish_time'] = _finishTime;
    if (_breed != null) {
      map['breed'] = _breed?.toJson();
    }
    collectToJson(map);
    return map;
  }
}
