import 'dart:async';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pet_charity/routers/routes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:pet_charity/states/user.dart';

import 'package:pet_charity/models/user/user_result.dart';
import 'package:pet_charity/models/public/detail.dart';

import 'package:pet_charity/service/login.dart' as server;

import 'package:pet_charity/routers/application.dart';

import 'package:pet_charity/view/login/input_box_view.dart';
import 'package:pet_charity/view/utils/dark.dart';

import 'package:pet_charity/view/view/my_keyboard_view.dart';
import 'package:pet_charity/view/utils/svg_picture_color.dart';

class VerificationCodePage extends StatefulWidget {
  final String? phone;

  const VerificationCodePage(this.phone, {Key? key}) : super(key: key);

  @override
  State<VerificationCodePage> createState() => _VerificationCodePageState();
}

class _VerificationCodePageState extends State<VerificationCodePage> {
  final ValueNotifier<String> _vCode = ValueNotifier('');

  final ValueNotifier<int> _timeCount = ValueNotifier(0);
  final ValueNotifier<String> _timeText = ValueNotifier('发送');

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _sendVCode();
  }
  @override
  Widget build(BuildContext context) {
    debugPrint('_VerificationCodePageState build');
    return Scaffold(
      body: Stack(
        children: [
          isDark(context) ? SizedBox(width: 1290.w, height: 2796.h) : Image.asset("assets/login/vCodeBg.png", width: 1290.w, height: 2796.h, fit: BoxFit.fill),
          _buildBack(),
          _buildTop(),
          _buildVCodeInputBox(),
          _buildSendVCode(),
          _buildKeyboard(),
        ],
      ),
    );
  }

  Widget _buildBack() {
    return Positioned(
      top: 220.h,
      left: 32.w,
      width: 100.w,
      height: 100.h,
      child: InkWell(
        onTap: () => Application.router.pop(context),
        child: Ink(
          child: SvgPicture.asset(
            'assets/public/返回.svg',
            colorFilter: SvgPictureColor.color(Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.5)),
          ),
        ),
      ),
    );
  }

  Widget _buildTop() {
    return Positioned(
      top: 630.h,
      left: 128.w,
      width: 1290.w,
      height: 220.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("验证码", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 76.sp)),
          SizedBox(height: 12.h),
          Text("验证码已发送至手机${widget.phone?.substring(0, 3) ?? '***'}****${widget.phone?.substring(7, 11) ?? '****'}",
              style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.5))),
        ],
      ),
    );
  }

  Positioned _buildVCodeInputBox() {
    return Positioned(
      top: 860.h,
      left: 0.w,
      width: 1290.w,
      height: 200.h,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 145.w),
        child: ValueListenableBuilder<String>(
          valueListenable: _vCode,
          builder: (context, value, child) => VCodeInputBoxView(value),
        ),
      ),
    );
  }

  Widget _buildSendVCode() {
    return Positioned(
      top: 1160.h,
      left: 128.w,
      width: 1030.w,
      height: 80.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: _sendVCode,
            child: Ink(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: ValueListenableBuilder<String>(
                valueListenable: _timeText,
                builder: (context, value, child) {
                  return Text(value,
                      style: TextStyle(color: Theme.of(context).textTheme.titleMedium?.color?.withOpacity('重新获取' == value || value == '发送' ? 1 : 0.5)));
                },
              ),
            ),
          ),
          SizedBox(height: 12.h),
          Text("没有收到验证码?", style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.5))),
        ],
      ),
    );
  }

  void _sendVCode() async {
    if (_timeCount.value == 0) {
      Detail sendVCodeDetail = await server.sendVerificationCode(widget.phone ?? '');
      if (sendVCodeDetail.code == 200) {
        BotToast.showText(text: '验证码已发送，请注意查收');
        _timeCount.value = 60;
        _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
          _timeCount.value--;
          if (_timeCount.value <= 0) {
            _timeText.value = '重新获取';
            _timer?.cancel();
          } else {
            _timeText.value = '重新发送(' '${_timeCount.value}' 's)';
          }
        });
      } else {
        BotToast.showText(text: '发送验证码失败');
      }
    }
  }

  Widget _buildKeyboard() {
    return Positioned(
      bottom: 0,
      left: 0,
      width: 1290.w,
      height: 750.h,
      child: MyKeyboardView(
        callback: (int num) {
          String value = _vCode.value;
          if (num == 127) {
            // 删除
            if (value.isNotEmpty) {
              _vCode.value = value.substring(0, value.length - 1);
            }
          } else if (num == 13) {
            //
            _finish();
          } else {
            if (value.length < 4) {
              _vCode.value = '$value$num';
              if (value.length == 4) {
                _finish();
              }
            }
          }
        },
      ),
    );
  }

  void _finish() async {
    String value = _vCode.value;
    if (value.length != 4) {
      BotToast.showText(text: "请输入验证码");
    } else {
      bool flag = false;
      String phone = widget.phone ?? '';
      Detail isRegisterDetail = await server.judgeRegister(phone);
      if (isRegisterDetail.whether ?? true) {
        // 注册
        Detail registerDetail = await server.register(phone, value);
        if (registerDetail.code == 200) {
          BotToast.showText(text: "注册成功");
          flag = true;
        } else if (registerDetail.code == 1001) {
          BotToast.showText(text: "验证码错误");
        } else if (registerDetail.code == 400) {
          BotToast.showText(text: "手机号码非法");
        } else if (registerDetail.code == 204) {
          BotToast.showText(text: "请发送验证码");
        }
      } else {
        flag = true;
      }

      if (flag) {
        // 登录
        UserResult userLogin = await server.login(phone, code: value);
        debugPrint('${userLogin.code ?? -1}');
        if (userLogin.code == 200) {
          if (!(isRegisterDetail.whether ?? true)) {
            BotToast.showText(text: "登录成功");
          }
          if (!mounted) return;
          Provider.of<UserModel>(context, listen: false).user = userLogin.data;
          Application.router.pop(context, 200);
        } else if (userLogin.code == 400) {
          BotToast.showText(text: "请输入正确的验证码");
        } else if (userLogin.code == 204) {
          BotToast.showText(text: "验证码错误");
        }
      }
    }
  }
}

Future<dynamic> gotoVCode(BuildContext context, String phone) async {
  return await Application.router.navigateTo(context, '${Routes.vCode}?phone=$phone');
}
