import 'package:flutter/material.dart';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:pet_charity/states/color_schemes.g.dart';

import 'package:pet_charity/routers/application.dart';
import 'package:pet_charity/routers/routes.dart';

import 'package:pet_charity/view/login/verification_code_page.dart';
import 'package:pet_charity/view/utils/dark.dart';
import 'package:pet_charity/view/utils/extension/extension_state.dart';
import 'package:pet_charity/view/utils/svg_picture_color.dart';
import 'package:pet_charity/view/view/my_keyboard_view.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _consentAgreement = false;

  String _phone = '15555555555';
  bool _isShowKeyboard = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          isDark(context) ? SizedBox(width: 1290.w, height: 2796.h) : Image.asset("assets/login/loginBg.png", width: 1290.w, height: 2796.h, fit: BoxFit.fill),
          _buildPhone(),
          _buildLogin(),
          _buildRegister(),
          _buildOtherLogin(),
          _buildServiceAgreement(),
          if (_isShowKeyboard) _buildKeyboard()
        ],
      ),
    );
  }

  Positioned _buildPhone() {
    return Positioned(
      bottom: 1180.h,
      left: 0.w,
      width: 1290.w,
      height: 200.h,
      child: InkWell(
        borderRadius: BorderRadius.circular(48.w),
        onTap: () {
          mySetState(() => _isShowKeyboard = !_isShowKeyboard);
        },
        child: Center(
          child: _phone.isNotEmpty
              ? Text(_phone, style: TextStyle(fontSize: 128.sp, fontWeight: FontWeight.w600))
              : Text(_isShowKeyboard ? '' : '点击输入手机号码', style: TextStyle(fontSize: 72.sp, fontWeight: FontWeight.w400)),
        ),
      ),
    );
  }

  Positioned _buildLogin() {
    return Positioned(
      bottom: 880.h,
      left: 145.w,
      width: 1000.w,
      height: 200.h,
      child: Material(
        child: InkWell(
          borderRadius: BorderRadius.circular(48.w),
          onTap: _login,
          child: Ink(
            decoration: BoxDecoration(
              border: Border.all(width: 2.w, color: Colours.mineralPurple),
              borderRadius: BorderRadius.circular(48.w),
              color: Colours.mainColor,
            ),
            width: 1000.w,
            height: 200.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset("assets/login/phone.svg", height: 100.w, colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn)),
                SizedBox(width: 24.w),
                Text("登录", style: TextStyle(fontSize: 68.sp, color: Colors.white)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Positioned _buildRegister() {
    return Positioned(
      bottom: 750.h,
      left: 0.w,
      width: 1290.w,
      height: 100.h,
      child: Center(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(24.w),
            onTap: () {
              BotToast.showText(text: "未注册登录会自动注册！");
            },
            child: Ink(
              padding: EdgeInsets.symmetric(horizontal: 64.w, vertical: 12.h),
              child: Text("注册", style: TextStyle(fontSize: 60.sp)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOtherLogin() {
    return Positioned(
      bottom: 280.h,
      left: 0,
      width: 1290.w,
      height: 200.h,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 160.w),
        // color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.5),
        child: Material(
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildLoginByApp("assets/login/google.svg", () {}),
              _buildLoginByApp("assets/login/facebook.svg", () {}),
              _buildLoginByApp("assets/login/twitter.svg", () {}),
              _buildLoginByApp("assets/login/wechat.svg", () {}),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginByApp(String icon, GestureTapCallback onTap) {
    return InkWell(
      borderRadius: BorderRadius.circular(126.w),
      onTap: onTap,
      child: Ink(
        child: SvgPicture.asset(
          icon,
          height: 136.h,
          colorFilter: SvgPictureColor.color(Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.5)),
        ),
      ),
    );
  }

  Widget _buildServiceAgreement() {
    return Positioned(
      bottom: 120.h,
      left: 0,
      width: 1290.w,
      height: 100.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Checkbox(
            value: _consentAgreement,
            onChanged: (_) {
              mySetState(() => _consentAgreement = !_consentAgreement);
            },
            shape: const CircleBorder(),
          ),
          Text("已阅读并同意", style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.5))),
          const Text("《服务协议》"),
          Text("和", style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.5))),
          const Text("《隐私政策》"),
        ],
      ),
    );
  }

  Widget _buildKeyboard() {
    return Positioned(
      bottom: 0,
      left: 0,
      width: 1290.w,
      height: 750.h,
      child: MyKeyboardView(
        isShowHide: true,
        onTopHide: () {
          mySetState(() => _isShowKeyboard = false);
        },
        callback: (int num) {
          if (num == 127) {
            // 删除
            if (_phone.isNotEmpty) {
              _phone = _phone.substring(0, _phone.length - 1);
            }
          } else if (num == 13) {
            // 登录
            _login();
          } else {
            if (_phone.length < 11) {
              _phone = '$_phone$num';
            }
          }
          mySetState(() {});
        },
      ),
    );
  }

  // 登录
  void _login() async {
    if (!_consentAgreement) {
      BotToast.showText(text: '请阅读并同意《服务协议》和《隐私政策》');
    } else {
      if (_phone.length != 11) {
        BotToast.showText(text: '手机号码非法！！！');
        return;
      }
      var resultCode = await gotoVCode(context, _phone);
      if (resultCode == 200) {
        if (mounted) {
          Application.router.pop(context, 200);
        }
      }
    }
  }
}

Future<dynamic> gotoLogin(BuildContext context) async {
  debugPrint("跳转到登录");
  return await Application.router.navigateTo(context, Routes.login);
}
