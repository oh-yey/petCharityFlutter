import 'dart:io';

import 'package:flutter/services.dart';

class DisableScreenshots {
  // 私有构造函数
  DisableScreenshots._internal();

  // 保存单例
  static final DisableScreenshots _singleton = DisableScreenshots._internal();

  // 工厂构造函数
  factory DisableScreenshots() => _singleton;

  static const _methodChannel = MethodChannel('com.miyou.pet_charity/disableScreenshots');

  Future<void> disableScreenshots(bool disable) async {
    // 仅Android平台支持禁用屏幕截图
    if (Platform.isAndroid) {
      await _methodChannel.invokeMethod("disableScreenshots", {"disable": disable});
    }
  }
}
