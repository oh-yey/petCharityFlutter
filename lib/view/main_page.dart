import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pet_charity/view/login/login_page.dart';

import 'package:pet_charity/states/user.dart';

import 'package:pet_charity/models/user/user.dart';

import 'package:pet_charity/view/home/home_page.dart';
import 'package:pet_charity/view/personal/personal_view.dart';
import 'package:pet_charity/view/utils/extension/extension_state.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final List<Widget> _tabBodies = [const HomePage(), const PersonalView()];

  int _curIndex = 0;

  // 保留最后一次按返回的时间
  DateTime? lastPopTime;

  @override
  void initState() {
    _change(0);
    super.initState();
  }

  void _change(int index) async {
    if (index != _curIndex) {
      if (index == 1) {
        User? user = context.read<UserModel>().user;
        if (user == null) {
          var resultCode = await gotoLogin(context);
          if (resultCode != 200) {
            return;
          }
        }
      }
      mySetState(() {
        _curIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        body: _tabBodies[_curIndex],
        // 底部导航栏
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _curIndex,
          onTap: _change,
          items: [
            myBottomNavigationBarItem('assets/main/home.svg', '首页', 0),
            myBottomNavigationBarItem('assets/main/my.svg', '我的', 1),
          ],
        ),
      ),
      // 返回拦截
      onWillPop: () async {
        if (lastPopTime == null || DateTime.now().difference(lastPopTime!) > const Duration(seconds: 2)) {
          lastPopTime = DateTime.now();
          BotToast.showText(text: '再按一次退出');
          return false;
        } else {
          lastPopTime = DateTime.now();
          // 退出app
          return true;
        }
      },
    );
  }

  // 普通底部按钮
  BottomNavigationBarItem myBottomNavigationBarItem(String icon, String text, int index) {
    Color color = index == _curIndex ? Theme.of(context).primaryColorLight : Theme.of(context).focusColor;
    return BottomNavigationBarItem(
      icon: SvgPicture.asset(icon, height: 24, colorFilter: ColorFilter.mode(color, BlendMode.srcIn)),
      label: text,
    );
  }
}
