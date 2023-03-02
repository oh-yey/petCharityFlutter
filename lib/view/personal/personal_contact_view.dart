import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:pet_charity/states/user.dart';

import 'package:pet_charity/models/user/user.dart';
import 'package:pet_charity/models/public/detail.dart';

import 'package:pet_charity/service/user_server.dart' as user_server;

import 'package:pet_charity/routers/application.dart';
import 'package:pet_charity/routers/routes.dart';

import 'package:pet_charity/view/utils/my_input_decoration.dart';
import 'package:pet_charity/view/view/button/my_ok_button.dart';
import 'package:pet_charity/view/view/my_scaffold.dart';

class PersonalContactView extends StatefulWidget {
  const PersonalContactView({Key? key}) : super(key: key);

  @override
  State<PersonalContactView> createState() => _PersonalContactViewState();
}

class _PersonalContactViewState extends State<PersonalContactView> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _qqController = TextEditingController();
  final TextEditingController _wechatController = TextEditingController();
  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _qqFocusNode = FocusNode();
  final FocusNode _wechatFocusNode = FocusNode();

  @override
  void initState() {
    _init();
    super.initState();
  }

  void _init() {
    User? user = context.read<UserModel>().user;
    _phoneController.text = user?.contact?.phone ?? '';
    _emailController.text = user?.contact?.mail ?? '';
    _qqController.text = user?.contact?.qq ?? '';
    _wechatController.text = user?.contact?.wechat ?? '';
  }

  @override
  Widget build(BuildContext context) => MyScaffold(title: '个人联系方式', body: _body());

  Widget _body() {
    return Column(
      children: [
        _buildMessageItem('手机号：', _phoneController, _phoneFocusNode, '请输入手机号码', maxLength: 11),
        _buildMessageItem('邮箱：', _emailController, _emailFocusNode, '请输入邮箱'),
        _buildMessageItem('QQ：', _qqController, _qqFocusNode, '请输入QQ号码', maxLength: 10),
        _buildMessageItem('微信：', _wechatController, _wechatFocusNode, '请输入微信号'),
        const Spacer(),
        MyOkButton('保存', onTap: _save)
      ],
    );
  }

  Padding _buildMessageItem(
    String title,
    TextEditingController controller,
    FocusNode focusNode,
    String hintText, {
    int maxLength = 32,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 24.h),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: TextStyle(fontSize: 64.sp)),
              Expanded(
                child: TextField(
                  scrollPadding: EdgeInsets.zero,
                  textAlign: TextAlign.end,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: myTransparentInputDecoration(hintText: hintText),
                  controller: controller,
                  focusNode: focusNode,
                  maxLines: 1,
                  inputFormatters: [LengthLimitingTextInputFormatter(maxLength)],
                  textInputAction: TextInputAction.done,
                  onSubmitted: loseFocus,
                ),
              ),
            ],
          ),
          Divider(thickness: 1.h)
        ],
      ),
    );
  }

  void loseFocus(e) => FocusScope.of(context).requestFocus(FocusNode());

  void _save() async {
    if (!_verify()) {
      return;
    }
    Detail? detail = await user_server.updateContact(
      phone: _phoneController.text.trim(),
      mail: _emailController.text.trim(),
      qq: _qqController.text.trim(),
      wechat: _wechatController.text.trim(),
    );
    if (detail?.code == 200) {
      BotToast.showText(text: '修改成功');
      if (!mounted) return;
      Navigator.pop(context, true);
    } else {
      BotToast.showText(text: '未知错误');
    }
  }

  /// 验证
  bool _verify() {
    if (_phoneController.text.trim().isEmpty) {
      FocusScope.of(context).requestFocus(_phoneFocusNode);
      BotToast.showText(text: '请输入手机号');
      return false;
    } else if (_emailController.text.trim().isEmpty) {
      FocusScope.of(context).requestFocus(_emailFocusNode);
      BotToast.showText(text: '请输入邮箱');
      return false;
    } else if (_qqController.text.trim().isEmpty) {
      FocusScope.of(context).requestFocus(_qqFocusNode);
      BotToast.showText(text: '请输入QQ');
      return false;
    } else if (_wechatController.text.trim().isEmpty) {
      FocusScope.of(context).requestFocus(_wechatFocusNode);
      BotToast.showText(text: '请输入微信');
      return false;
    } else {
      return true;
    }
  }
}

void gotoPersonalContactView(BuildContext context) async {
  Application.router.navigateTo(context, Routes.personalContact);
}
