import 'package:dio/dio.dart';

import 'package:pet_charity/network/dio_client.dart';

import 'package:pet_charity/models/pet/breed.dart';
import 'package:pet_charity/models/pet/pet_images.dart';
import 'package:pet_charity/models/pet/pet.dart';
import 'package:pet_charity/models/pet/pet_list.dart';

/// 获取宠物
Future<Pet?> getPet(num pk) async {
  Response response = await DioClient().doGet('/pet/pet/$pk');
  if (response.statusCode == 200) {
    return Pet.fromJson(response.data);
  }
  return null;
}

/// 获取宠物列表
Future<PetList?> petList(num userId, {int page = 1}) async {
  String path = '/pet/pet/list?user=$userId&page=$page';
  Response response = await DioClient().doGet(path);
  if (response.statusCode == 200) {
    return PetList.fromJson(response.data);
  }
  return null;
}

Future<List<Breed>> breedList({int race = 0}) async {
  Response response = await DioClient().doGet('/pet/breed/list?race=$race');
  List<Breed> results = [];
  if (response.statusCode == 200) {
    var json = response.data;
    if (json != null) {
      json.forEach((v) => results.add(Breed.fromJson(v)));
    }
  }
  return results;
}

/// 上传宠物图片
Future<PetImages?> imageUpload(String path, {String? petName}) async {
  if (petName == null) {
    petName = path.split('/').last;
  } else {
    petName = '$petName.jpg';
  }
  FormData requestData = FormData.fromMap({'image': await MultipartFile.fromFile(path, filename: petName)});
  Response response = await DioClient().uploadFile('/pet/image/create', requestData);
  if (response.statusCode == 201) {
    return PetImages.fromJson(response.data);
  } else {
    return null;
  }
}

/// 上传宠物
Future<bool> petCreate({
  required String name,
  required num breed,
  required num sex,
  required double weight,
  required String birth,
  required bool visual,
  required List<num> images,
  required num coverImage,
}) async {
  var data = {
    "name": name,
    "breed": breed,
    "sex": sex,
    "weight": weight.toStringAsFixed(3),
    "birth": birth,
    "visual": visual,
    "images": images,
    "cover_image": coverImage,
  };
  Response response = await DioClient().doPost('/pet/pet/create', data: data);
  return response.statusCode == 201;
}

/// 宠物信息修改
Future<bool> petUpdate(
  num pk, {
  required String name,
  required num breed,
  required num sex,
  required double weight,
  required String birth,
  required bool visual,
  required List<num> images,
  required num coverImage,
}) async {
  var data = {
    "name": name,
    "breed": breed,
    "sex": sex,
    "weight": weight.toStringAsFixed(3),
    "birth": birth,
    "visual": visual,
    "images": images,
    "cover_image": coverImage,
  };
  Response response = await DioClient().doPatch('/pet/pet/partialUpdate/$pk', data: data);
  return response.statusCode == 200;
}

/// 宠物信息删除
Future<bool> petDelete(num pk) async {
  Response response = await DioClient().doDelete('/pet/pet/delete/$pk');
  return response.statusCode == 204;
}
