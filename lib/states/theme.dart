import 'package:flutter/material.dart';

import 'package:pet_charity/common/global.dart';

class ThemeModel extends ChangeNotifier {
  static final Map<ThemeMode, String> themes = {
    ThemeMode.system: 'System',
    ThemeMode.light: 'Light',
    ThemeMode.dark: 'Dark',
  };

  static ThemeMode getThemeMode(theme) {
    switch (theme) {
      case 'Light':
        return ThemeMode.light;
      case 'Dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  ThemeMode get theme => getThemeMode(Global.theme);

  // 主题改变后，通知其依赖项，新主题会立即生效
  set theme(ThemeMode color) {
    Global.theme = themes[color];
    notifyListeners();
  }

  @override
  void notifyListeners() {
    Global.saveTheme();
    super.notifyListeners();
  }
}
