import 'package:dio/dio.dart';

import 'package:pet_charity/network/dio_client.dart';

import 'package:pet_charity/models/user/user_result.dart';
import 'package:pet_charity/models/public/detail.dart';

/// 判断用户是否注册
Future<Detail> judgeRegister(String phone) async {
  var response = await DioClient().doPost('/user/whetherRegister', data: {'phone': phone});
  return Detail.fromJson(response.data);
}

/// 发送验证码
Future<Detail> sendVerificationCode(String phone) async {
  var response = await DioClient().doPost('/user/sendVCode', data: {'phone': phone});
  return Detail.fromJson(response.data);
}

/// 登录
Future<UserResult> login(String phone, {String? password, String? code}) async {
  var data = {'phone': phone};
  if (password != null) {
    data['password'] = password;
  }
  if (code != null) {
    data['code'] = code;
  }
  Response response = await DioClient().doPost('/user/login', data: data);
  return UserResult.fromJson(response.data);
}

/// 注册
Future<Detail> register(String phone, String code) async {
  Response response = await DioClient().doPost('/user/register', data: {'phone': phone, 'code': code});
  return Detail.fromJson(response.data);
}
//
// Future<int> tokenLogin(BuildContext context) async {
//   Response response = await DioUtil.post('/user/login/token');
//   int state = response.statusCode;
//   if (state == 200) {
//     UserEntity resultEntity = UserEntity().fromJson(response.data);
//     Provider.of<UserModel>(context, listen: false).user = resultEntity;
//     print('自动登录成功');
//   } else if (state == 401) {
//     print('token 失效');
//     BotToast.showText(text: "登录失效 请重新登录");
//     Provider.of<UserModel>(context, listen: false).user = null;
//     Provider.of<MessageModel>(context, listen: false).update(null);
//   }
//   return state;
// }
//

//

//
// //找回密码
// Future<int> findBackPassword(String phone, String code, String newPassword) async {
//   Response response = await DioUtil.patch('/user/findBackPassword', data: {'phone_hz': phone, 'code': code, 'new_password_hz': newPassword});
//   int state = response.statusCode;
//   if (state == 200) {
//     return response.data['code'];
//   }
//   return null;
// }
//
// // 修改密码
// Future<int> modifyPassword(String phone, String oldPassword, String newPassword) async {
//   Response response = await DioUtil.patch('/user/findBackPassword', data: {'phone_hz': phone, 'old_password_hz': oldPassword, 'new_password_hz': newPassword});
//   int state = response.statusCode;
//   if (state == 200) {
//     return response.data['code'];
//   }
//   return null;
// }
//
// // 忘记支付密码
// Future<int> findBackPagPassword(String phone, String code, String newPayPassword) async {
//   Response response = await DioUtil.patch('/user/findBackPayPassword', data: {'phone_hz': phone, 'code': code, 'new_pay_password_hz': newPayPassword});
//   int state = response.statusCode;
//   if (state == 200) {
//     return response.data['code'];
//   }
//   return null;
// }
//
// // 修改支付密码
// Future<int> modifyPagPassword(String phone, String oldPayPassword, String newPayPassword) async {
//   Response response = await DioUtil.patch('/user/findBackPayPassword', data: {'phone_hz': phone, 'old_pay_password_hz': oldPayPassword, 'new_pay_password_hz': newPayPassword});
//   int state = response.statusCode;
//   if (state == 200) {
//     return response.data['code'];
//   }
//   return null;
// }
