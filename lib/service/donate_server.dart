import 'package:dio/dio.dart';

import 'package:pet_charity/network/dio_client.dart';

import 'package:pet_charity/models/public/detail.dart';
import 'package:pet_charity/models/donate/pet_donate_list.dart';

/// 获取宠物帮助众筹列表
Future<PetDonateList?> donateList({int page = 1, String search = '', num? breed, num? sex}) async {
  String path = '/donate/list?ordering=-publish_time&state=1&page=$page&search=$search';
  if (breed != null) {
    path += '&breed=$breed';
  }
  if (sex != null) {
    path += '&sex=$sex';
  }
  Response response = await DioClient().doGet(path);
  if (response.statusCode == 200) {
    return PetDonateList.fromJson(response.data);
  }
  return null;
}

/// 捐赠
Future<Detail?> userDonate(num donateId, num amount, String password) async {
  Response response = await DioClient().doPost('/donate/donate/userDonate', data: {
    "donateId": donateId,
    "amount": amount,
    "payPassword": password,
  });
  if (response.statusCode == 200) {
    return Detail.fromJson(response.data);
  }
  return null;
}
