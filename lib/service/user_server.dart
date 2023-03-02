import 'package:dio/dio.dart';

import 'package:pet_charity/network/dio_client.dart';

import 'package:pet_charity/models/user/followers_list.dart';
import 'package:pet_charity/models/user/user.dart';
import 'package:pet_charity/models/public/detail.dart';

/// 收藏
Future<Detail> collect(int collectCategory, num collectId, bool cancel) async {
  Response response = await DioClient().doPost('/user/collect', data: {'collectCategory': collectCategory, 'collectId': collectId, 'cancel': cancel});
  return Detail.fromJson(response.data);
}

/// 关注
Future<Detail> following(num userId, bool cancel) async {
  Response response = await DioClient().doPost('/user/followers/user', data: {'userId': userId, 'cancel': cancel});
  return Detail.fromJson(response.data);
}

/// 关注列表
Future<FollowersList?> followersList({
  int page = 1,
  num? followers,
  num? following,
}) async {
  String path = '/user/followers/list';
  if (followers != null && following != null) {
    path += '?followers=$followers&following=$following';
  } else if (followers != null) {
    path += '?followers=$followers';
  } else if (following != null) {
    path += '?following=$following';
  }
  Response response = await DioClient().doGet(path);
  if (response.statusCode == 200) {
    return FollowersList.fromJson(response.data);
  }
  return null;
}

/// Token获取用户信息
Future<User?> getInformationByToken() async {
  Response response = await DioClient().doPost('/user/token/information');
  if (response.statusCode == 200) {
    return User.fromJson(response.data);
  } else {
    return null;
  }
}

/// 修改用户信息
Future<bool> updateInformation({
  required String nickname,
  required String qq,
  required String introduction,
  required num sex,
  required num area,
}) async {
  Response response = await DioClient().doPatch('/user/token/information', data: {
    "nickname": nickname,
    "qq": qq,
    "sex": sex,
    "area": area,
    "introduction": introduction,
  });
  return response.statusCode == 200;
}

/// 修改用户联系方式
Future<Detail?> updateContact({
  required String phone,
  required String mail,
  required String qq,
  required String wechat,
}) async {
  Response response = await DioClient().doPost('/user/contact', data: {
    "phone": phone,
    "mail": mail,
    "qq": qq,
    "wechat": wechat,
  });
  return Detail.fromJson(response.data);
}

/// 实名认证
Future<Detail?> authentication({
  required String realName,
  required String idCard,
}) async {
  Response response = await DioClient().doPost('/user/authentication', data: {"realName": realName, "idCard": idCard});
  return Detail.fromJson(response.data);
}

/// 头像上传
Future<bool> upload(String path) async {
  FormData requestData = FormData.fromMap({'head': await MultipartFile.fromFile(path, filename: path.split('/').last)});
  Response response = await DioClient().uploadFile('/user/avatar/upload', requestData);
  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}
