import 'package:flutter/material.dart';

import 'package:pet_charity/common/global.dart';

import 'package:pet_charity/models/user/user.dart';

class UserModel with ChangeNotifier {
  User? get user => Global.user;

  set user(User? user) {
    Global.user = user;
    notifyListeners();
  }

  @override
  void notifyListeners() {
    Global.saveUser();
    super.notifyListeners();
  }
}
