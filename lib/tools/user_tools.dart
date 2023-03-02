import 'package:provider/provider.dart';

import 'package:pet_charity/states/user.dart';

import 'package:pet_charity/models/user/user.dart';

bool judgeLogin(context) {
  User? user = Provider.of<UserModel>(context, listen: false).user;
  if (user == null) {
    return false;
  } else {
    return true;
  }
}
