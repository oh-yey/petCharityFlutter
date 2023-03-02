import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter_svg/svg.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:pet_charity/states/user.dart';

import 'package:pet_charity/models/address/area.dart';
import 'package:pet_charity/models/user/user.dart';

import 'package:pet_charity/service/user_server.dart';

import 'package:pet_charity/routers/application.dart';
import 'package:pet_charity/routers/routes.dart';

import 'package:pet_charity/view/personal/select_address_page.dart';
import 'package:pet_charity/view/personal/personal_contact_view.dart';
import 'package:pet_charity/view/personal/personal_authentication_page.dart';
import 'package:pet_charity/view/utils/date.dart';
import 'package:pet_charity/view/utils/extension/extension_state.dart';
import 'package:pet_charity/view/utils/my_input_decoration.dart';
import 'package:pet_charity/view/utils/svg_picture_color.dart';
import 'package:pet_charity/view/view/button/my_ok_button.dart';
import 'package:pet_charity/view/view/my_scaffold.dart';

class PersonalCenterPage extends StatefulWidget {
  const PersonalCenterPage({Key? key}) : super(key: key);

  @override
  State<PersonalCenterPage> createState() => _PersonalCenterPageState();
}

class _PersonalCenterPageState extends State<PersonalCenterPage> {
  User? _user;

  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _qqController = TextEditingController();
  final TextEditingController _introductionController = TextEditingController();
  final FocusNode _nicknameFocusNode = FocusNode();
  final FocusNode _qqFocusNode = FocusNode();
  final FocusNode _introductionFocusNode = FocusNode();

  int _sex = 0;
  Area? _area;

  @override
  void initState() {
    _user = context.read<UserModel>().user;
    _nicknameController.text = _user?.nickname ?? '';
    _qqController.text = _user?.qq ?? '';
    _introductionController.text = _user?.introduction ?? '';
    _sex = _user?.sex?.toInt() ?? _sex;
    _area = _user?.area;
    super.initState();
  }

  String getSexName(int sex) => ['保密', '男', '女'][sex];

  @override
  Widget build(BuildContext context) => MyScaffold(title: '个人主页', body: _body());

  Widget _body() {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              _buildGroupCard([
                _buildItem(
                  'assets/personal/昵称.svg',
                  '昵称',
                  child: _buildInputBox(
                    _nicknameController,
                    _nicknameFocusNode,
                    '输入昵称',
                  ),
                ),
                _buildItem('assets/personal/性别.svg', '性别', value: getSexName(_sex), onTap: _onTapSex),
                _buildItem(
                  'assets/personal/QQ.svg',
                  'QQ',
                  child: _buildInputBox(
                    _qqController,
                    _qqFocusNode,
                    '输入QQ',
                  ),
                ),
                _buildItem(
                  'assets/personal/简介.svg',
                  '简介',
                  child: _buildInputBox(
                    _introductionController,
                    _introductionFocusNode,
                    '输入简介',
                    maxLength: 255,
                  ),
                ),
              ]),
              //
              _buildGroupCard([
                _buildItem('assets/home/位置.svg', '所属地区', value: _area?.area ?? '', onTap: _onTapAddress),
                _buildItem('assets/personal/联系方式.svg', '联系方式', onTap: _gotoPersonalContact),
                _buildItem('assets/personal/身份证.svg', '真实姓名', value: _user?.realName ?? '点击实名认证', onTap: _onTapAuthentication),
              ]),
              //
              // _buildGroupCard([
              //   _buildItem('assets/personal/密码.svg', '修改密码', onTap: _onTapPassword),
              //   _buildItem('assets/personal/密码.svg', '修改支付密码', onTap: _onTapPayPassword),
              // ]),
              //
              _buildGroupCard([
                _buildItem('assets/login/phone.svg', '手机号', value: _user?.phone ?? ''),
                _buildItem('assets/public/余额.svg', '余额', value: '${_user?.balance ?? 0}'),
                _buildItem('assets/personal/注册.svg', '注册时间', value: dateStringToString(_user?.createTime ?? '')),
              ]),
            ],
          ),
        ),
        SizedBox(height: 32.h),
        MyOkButton('保存', onTap: _save),
      ],
    );
  }

  Card _buildGroupCard(List<Widget> children) {
    for (int i = children.length - 1; i > 0; i--) {
      children.insert(i, _buildDivider());
    }
    return Card(
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 12.w),
        child: Column(children: children),
      ),
    );
  }

  Divider _buildDivider() {
    return Divider(color: Theme.of(context).colorScheme.background, height: 0, thickness: 1, indent: 120.w, endIndent: 64.w);
  }

  Widget _buildItem(
    String svg,
    String title, {
    String? value,
    Widget? child,
    GestureTapCallback? onTap,
  }) {
    Color? textColor = Theme.of(context).textTheme.titleMedium?.color;
    return InkWell(
      borderRadius: const BorderRadius.all(Radius.circular(12)),
      onTap: onTap,
      child: Ink(
        padding: EdgeInsets.symmetric(vertical: 32.h, horizontal: 32.w),
        child: Row(
          children: [
            SizedBox(width: 72.w, height: 72.h, child: SvgPicture.asset(svg, colorFilter: SvgPictureColor.color(textColor))),
            Container(width: 32.w),
            Text(title),
            Expanded(
              child: child ??
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: Text(
                      value ?? '',
                      textAlign: TextAlign.end,
                      style: TextStyle(color: textColor?.withOpacity(onTap != null ? 1 : 0.5)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
            ),
            Container(width: 32.w),
            const Icon(CupertinoIcons.forward),
          ],
        ),
      ),
    );
  }

  // 输入框
  Widget _buildInputBox(
    TextEditingController controller,
    FocusNode focusNode,
    String hintText, {
    int maxLength = 32,
  }) {
    return TextField(
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
    );
  }

  void loseFocus(e) => FocusScope.of(context).requestFocus(FocusNode());

  void _onTapSex() async {
    //
    int? selected = await showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text('性别'),
            content: const Text('请选择您的性别'),
            actions: [
              CupertinoButton(
                onPressed: () => Navigator.pop(context, 0),
                child: const Text('保密', style: TextStyle(color: CupertinoColors.systemTeal)),
              ),
              CupertinoButton(
                onPressed: () => Navigator.pop(context, 1),
                child: const Text('男', style: TextStyle(color: CupertinoColors.systemBlue)),
              ),
              CupertinoButton(
                onPressed: () => Navigator.pop(context, 2),
                child: const Text('女', style: TextStyle(color: CupertinoColors.systemPink)),
              ),
            ],
          );
        });
    debugPrint('$selected');

    if (selected != null && selected >= 0 && selected <= 2) {
      _sex = selected;
      mySetState(() {});
    }
  }

  void _onTapAddress() async {
    Area? area = await gotoSelectAddressPage(context, _area);
    _area = area ?? _area;
    mySetState(() {});
  }

  void _gotoPersonalContact() {
    gotoPersonalContactView(context);
  }

  void _onTapAuthentication() {
    if (_user?.verified != true) {
      gotoPersonalAuthenticationPage(context);
    } else {
      BotToast.showText(text: '您已经实名认证了');
    }
    //
  }

  void _onTapPassword() {
    //
  }

  void _onTapPayPassword() {
    //
  }

  void _save() async {
    //
    if (!_verify()) {
      return;
    }
    String nickname = _nicknameController.text.trim();
    String qq = _qqController.text.trim();
    String introduction = _introductionController.text.trim();

    bool isSuccess = await updateInformation(
      nickname: nickname,
      qq: qq,
      introduction: introduction,
      sex: _sex,
      area: _area?.id ?? 430602,
    );

    if (isSuccess) {
      BotToast.showText(text: '修改成功');
      if (!mounted) return;
      Navigator.pop(context, true);
    } else {
      BotToast.showText(text: '修改失败，请稍后再试!');
    }
  }

  /// 验证
  bool _verify() {
    if (_nicknameController.text.trim().isEmpty) {
      FocusScope.of(context).requestFocus(_nicknameFocusNode);
      BotToast.showText(text: '请输入昵称');
      return false;
    } else if (_qqController.text.trim().isEmpty) {
      FocusScope.of(context).requestFocus(_qqFocusNode);
      BotToast.showText(text: '请输入QQ');
      return false;
    } else if (_introductionController.text.trim().isEmpty) {
      FocusScope.of(context).requestFocus(_introductionFocusNode);
      BotToast.showText(text: '请输入简介');
      return false;
    } else {
      return true;
    }
  }
}

Future<bool?> gotoPersonalCenterPage(BuildContext context) async {
  return await Application.router.navigateTo(context, Routes.personalCenter);
}
