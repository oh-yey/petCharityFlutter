import 'package:dio/dio.dart';

import 'package:pet_charity/network/dio_client.dart';

import 'package:pet_charity/models/public/detail.dart';
import 'package:pet_charity/models/adopt/pet_adopt_list.dart';

/// 获取宠物领养列表
Future<PetAdoptList?> adoptList({
  int page = 1,
  String search = '',
  num? breed,
  num? sex,
  num? userId,
}) async {
  String path = '/adopt/list?ordering=-create_time&page=$page&search=$search';
  if (userId != null) {
    path += '&pet__user=$userId';
  }
  if (breed != null) {
    path += '&pet__breed=$breed';
  }
  if (sex != null) {
    path += '&pet__sex=$sex';
  }
  Response response = await DioClient().doGet(path);
  if (response.statusCode == 200) {
    return PetAdoptList.fromJson(response.data);
  }
  return null;
}

/// 上传宠物
Future<num> adoptCreate({
  required num petID,
  required String title,
  required String description,
  required String requirements,
}) async {
  var data = {"pet": petID, "title": title, "description": description, "requirements": requirements};
  Response response = await DioClient().doPost('/adopt/create', data: data);
  if (response.statusCode == 201) {
    return 200;
  }
  return Detail.fromJson(response.data).code ?? 500;
}

/// 宠物信息修改
Future<num> adoptUpdate(
  num pk, {
  required num petID,
  required String title,
  required String description,
  required String requirements,
}) async {
  var data = {"pet": petID, "title": title, "description": description, "requirements": requirements};
  Response response = await DioClient().doPatch('/adopt/update/$pk', data: data);
  if (response.statusCode == 200) {
    return 200;
  }
  return Detail.fromJson(response.data).code ?? 500;
}

/// 宠物信息删除
Future<bool> adoptDelete(num pk) async {
  Response response = await DioClient().doDelete('/adopt/delete/$pk');
  return response.statusCode == 204;
}
