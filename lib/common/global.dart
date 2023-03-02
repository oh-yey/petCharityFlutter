import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:pet_charity/network/dio_client.dart';

import 'package:pet_charity/models/user/user.dart';

class Global {
  // 配置
  static late SharedPreferences _prefs;

  // 用户
  static User? user;

  // 主题
  static String? theme;

  // ThemeMode?

  static Future<void> init() async {
    debugPrint('init SharedPreferences');
    // 初始化 SharedPreferences
    _prefs = await SharedPreferences.getInstance();

    // 获取当前主题
    theme = _prefs.getString('theme');
    // 获取当前用户
    String? userString = _prefs.getString('user');

    if (userString != null) {
      debugPrint('用户存在');
      user = User.fromJson(json.decode(userString));
      setToken(user?.token);
    }
  }

  /// 设置用户
  static saveUser() {
    setToken(user?.token);
    // 保存用户信息
    if (user != null) {
      _prefs.setString('user', json.encode(user!.toJson()));
    } else {
      _prefs.remove('user');
    }
  }

  /// 设置token
  static setToken(String? token) {
    debugPrint('设置token $token');
    // token更新
    DioClient.token = user?.token;
  }

  /// 设置主题
  static saveTheme() {
    if (theme != null) {
      _prefs.setString('theme', theme!);
    } else {
      _prefs.remove('theme');
    }
  }
}
