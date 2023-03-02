import 'package:pet_charity/models/model.dart';
import 'package:pet_charity/models/pet/breed.dart';
import 'package:pet_charity/models/pet/pet_images.dart';
import 'package:pet_charity/models/user/user.dart';

class Pet extends Model {
  Pet({
    this.name,
    this.sex,
    this.weight,
    this.birth,
    this.visual,
    this.breed,
    num? id,
    String? sexValue,
    List<PetImages>? images,
    PetImages? coverImage,
    User? user,
    String? createTime,
  }) {
    _id = id;
    _sexValue = sexValue;
    _images = images;
    _coverImage = coverImage;
    _user = user;
    _createTime = createTime;
  }

  Pet.fromJson(dynamic json) {
    _id = json['id'];
    _sexValue = json['sex_value'];
    if (json['images'] != null) {
      _images = [];
      json['images'].forEach((v) {
        _images?.add(PetImages.fromJson(v));
      });
    }
    _coverImage = json['cover_image'] != null ? PetImages.fromJson(json['cover_image']) : null;
    _user = json['user'] != null ? User.fromJson(json['user']) : null;
    sex = json['sex'];
    name = json['name'];
    weight = double.parse('${json['weight'] ?? 0}');
    birth = json['birth'];
    visual = json['visual'];
    _createTime = json['create_time'];
    breed = json['breed'] != null ? Breed.fromJson(json['breed']) : null;
  }

  num? _id;
  String? _sexValue;
  List<PetImages>? _images;
  PetImages? _coverImage;
  User? _user;
  num? sex;
  String? name;
  double? weight;
  String? birth;
  bool? visual;
  String? _createTime;
  Breed? breed;

  num? get id => _id;

  String? get sexValue => _sexValue;

  List<PetImages>? get images => _images;

  PetImages? get coverImage => _coverImage;

  User? get user => _user;


  String? get createTime => _createTime;

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
    if (_user != null) {
      map['user'] = _user?.toJson();
    }
    map['sex'] = sex;
    map['name'] = name;
    map['weight'] = weight;
    map['birth'] = birth;
    map['visual'] = visual;
    map['create_time'] = _createTime;
    if (breed != null) {
      map['breed'] = breed?.toJson();
    }
    return map;
  }
}
