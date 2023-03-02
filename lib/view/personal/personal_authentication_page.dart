import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:pet_charity/models/public/detail.dart';

import 'package:pet_charity/service/user_server.dart' as user_service;

import 'package:pet_charity/routers/application.dart';
import 'package:pet_charity/routers/routes.dart';

import 'package:pet_charity/view/utils/dark.dart';
import 'package:pet_charity/view/utils/extension/extension_state.dart';
import 'package:pet_charity/view/utils/my_input_decoration.dart';
import 'package:pet_charity/view/view/my_scaffold.dart';

class PersonalAuthenticationPage extends StatefulWidget {
  const PersonalAuthenticationPage({Key? key}) : super(key: key);

  @override
  State<PersonalAuthenticationPage> createState() => _PersonalAuthenticationPageState();
}

class _PersonalAuthenticationPageState extends State<PersonalAuthenticationPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idCardController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _idCardFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) => MyScaffold(title: '实名认证', body: _body());

  int _position = 0;

  Widget _body() {
    return Stepper(
      currentStep: _position,
      onStepTapped: _onStepTapped,
      onStepContinue: _onStepContinue,
      onStepCancel: _onStepCancel,
      controlsBuilder: (_, ControlsDetails details) {
        return Row(
          children: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                shape: const CircleBorder(side: BorderSide(width: 2, color: Colors.white)),
              ),
              onPressed: details.onStepContinue,
              child: const Icon(Icons.check, color: Colors.white),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.withOpacity(isDark(context) ? 0.5 : 1),
                shape: const CircleBorder(side: BorderSide(width: 2, color: Colors.white)),
              ),
              onPressed: details.onStepCancel,
              child: const Icon(Icons.keyboard_backspace, color: Colors.white),
            ),
          ],
        );
      },
      steps: [
        Step(
          title: Text('输入真实姓名', style: TextStyle(color: _textColor(0))),
          isActive: _isSelected(0),
          state: _getState(0),
          content: _buildTextField('输入真实姓名', _nameController, _nameFocusNode, 10),
        ),
        Step(
          title: Text('输入身份证号码', style: TextStyle(color: _textColor(1))),
          isActive: _isSelected(1),
          state: _getState(1),
          content: _buildTextField('输入身份证号码', _idCardController, _idCardFocusNode, 18),
        ),
        Step(
          title: Text('确认信息', style: TextStyle(color: _textColor(2))),
          isActive: _isSelected(2),
          state: _getState(2),
          content: _buildMessage(),
        ),
      ],
    );
  }

  Color? _textColor(int index) => _isSelected(index) ? null : Theme.of(context).textTheme.titleMedium?.color?.withOpacity(0.5);

  Widget _buildTextField(String hintText, TextEditingController controller, FocusNode focusNode, int num) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      child: TextField(
        scrollPadding: EdgeInsets.zero,
        decoration: myColorInputDecoration(
          contentPadding: const EdgeInsets.all(12),
          hintText: hintText,
          color: Theme.of(context).textTheme.titleMedium?.color ?? Colors.black,
        ),
        controller: controller,
        focusNode: focusNode,
        onSubmitted: loseFocus,
        minLines: 1,
        maxLines: 1,
        inputFormatters: [LengthLimitingTextInputFormatter(num)],
        showCursor: true,
      ),
    );
  }

  Widget _buildMessage() {
    return Card(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
        child: ListTile(
          title: Text('姓名：${_nameController.text.trim()}'),
          subtitle: Text('身份证：${_idCardController.text.trim()}'),
        ),
      ),
    );
  }

  void loseFocus(e) => FocusScope.of(context).requestFocus(FocusNode());

  /// 上一步
  void _onStepCancel() {
    if (_position > 0) {
      mySetState(() => _position--);
    }
  }

  /// 下一步
  void _onStepContinue() {
    switch (_position) {
      case 0:
        if (_nameController.text.trim().length < 2) {
          FocusScope.of(context).requestFocus(_nameFocusNode);
          BotToast.showText(text: '请输入姓名');
          return;
        }
        _position = 1;
        break;
      case 1:
        if (_idCardController.text.trim().length != 18) {
          FocusScope.of(context).requestFocus(_idCardFocusNode);
          BotToast.showText(text: '请输入身份证');
          return;
        }
        _position = 2;
        break;
      case 2:
        _ok();
        break;
    }
    mySetState(() {});
  }

  void _ok() async {
    Detail? detail = await user_service.authentication(realName: _nameController.text.trim(), idCard: _idCardController.text.trim());
    num? code = detail?.code;
    if (code == 200) {
      BotToast.showText(text: '实名认证成功！');
      if (!mounted) return;
      Navigator.pop(context);
    } else if (code == 1001) {
      BotToast.showText(text: '姓名或身份证号码非法！');
    } else if (code == 1002) {
      BotToast.showText(text: '用户已实名认证！');
    } else {
      BotToast.showText(text: '未知错误！');
    }
  }

  /// 直接点击时
  void _onStepTapped(index) {
    if (index < _position) {
      mySetState(() => _position = index);
    }
  }

  StepState _getState(int index) {
    if (_isSelected(index)) return StepState.editing;
    if (_position > index) return StepState.complete;
    return StepState.indexed;
  }

  bool _isSelected(int index) => _position == index;
}

void gotoPersonalAuthenticationPage(BuildContext context) async {
  Application.router.navigateTo(context, Routes.personalAuthentication);
}
