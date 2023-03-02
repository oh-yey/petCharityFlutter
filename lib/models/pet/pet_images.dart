class PetImages {
  PetImages({num? id, String? image, num? width, num? height}) {
    _id = id;
    _image = image;
    _width = width;
    _height = height;
  }

  PetImages.fromJson(dynamic json) {
    _id = json['id'];
    _image = json['image'];
    _width = json['width'];
    _height = json['height'];
  }

  num? _id;
  String? _image;
  num? _width;
  num? _height;

  num? get id => _id;

  String? get image => _image;

  num? get width => _width;

  num? get height => _height;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['image'] = _image;
    map['width'] = _width;
    map['height'] = _height;
    return map;
  }
}
