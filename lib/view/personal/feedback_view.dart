import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


import 'package:pet_charity/service/user_server.dart' as user_server;

import 'package:pet_charity/routers/application.dart';
import 'package:pet_charity/routers/routes.dart';

import 'package:pet_charity/view/utils/extension/extension_state.dart';
import 'package:pet_charity/view/utils/my_input_decoration.dart';
import 'package:pet_charity/view/view/my_scaffold.dart';

class FeedbackView extends StatefulWidget {
  const FeedbackView({Key? key}) : super(key: key);

  @override
  State<FeedbackView> createState() => _FeedbackViewState();
}

class _FeedbackViewState extends State<FeedbackView> {
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final FocusNode _nicknameFocusNode = FocusNode();
  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _contentFocusNode = FocusNode();

  int score = 5;

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      title: '用户反馈',
      rightView: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(32)),
        onTap: _save,
        child: Ink(padding: const EdgeInsets.all(8), child: const Icon(Icons.save)),
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return ListView(
      padding: EdgeInsets.symmetric(vertical: 32.h),
      children: [
        _buildItem('昵称', child: _buildTitleTextField(_nicknameController, _nicknameFocusNode, '输入昵称')),
        _buildScoreSelect(),
        _buildItem('标题', child: _buildTitleTextField(_titleController, _titleFocusNode, '输入标题')),
        _buildItem('反馈内容', onTap: () => loseFocus(null)),
        _buildTextInput(_contentController, _contentFocusNode, '输入内容...'),
      ],
    );
  }

  Widget _buildItem(String title, {Widget? child, GestureTapCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Ink(
        padding: EdgeInsets.symmetric(vertical: 32.h, horizontal: 48.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text(title), if (child != null) Expanded(child: child)],
        ),
      ),
    );
  }

  Widget _buildScoreSelect() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 32.h, horizontal: 48.w),
      child: Row(
        children: [
          const Text("评级"),
          const Spacer(),
          DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: score,
              elevation: 1,
              icon: const Icon(Icons.expand_more),
              items: [1, 2, 3, 4, 5].map((e) => DropdownMenuItem<int>(value: e, child: Text('$e'))).toList(),
              onChanged: (int? newScore) => mySetState(() => score = newScore ?? score),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTitleTextField(TextEditingController controller, FocusNode focusNode, String hintText) {
    return TextField(
      scrollPadding: EdgeInsets.zero,
      textAlign: TextAlign.end,
      textAlignVertical: TextAlignVertical.center,
      decoration: myTransparentInputDecoration(hintText: hintText),
      controller: controller,
      focusNode: focusNode,
      maxLines: 1,
      inputFormatters: [LengthLimitingTextInputFormatter(32)],
      textInputAction: TextInputAction.done,
      onSubmitted: loseFocus,
    );
  }

  Widget _buildTextInput(TextEditingController controller, FocusNode focusNode, String hintText) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 38.w, vertical: 32.h),
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
        minLines: 5,
        maxLines: 10,
        showCursor: true,
      ),
    );
  }

  void loseFocus(e) => FocusScope.of(context).requestFocus(FocusNode());

  void _save() async {
    if (_verify()) {
      bool isSuccess = await user_server.feedback(
        nickname: _contentController.text.trim(),
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        score: score,
      );
      if (isSuccess) {
        BotToast.showText(text: '反馈成功');
        if (!mounted) return;
        Navigator.pop(context, true);
      } else {
        BotToast.showText(text: '反馈失败 请稍后再试');
      }
    }
  }

  /// 验证
  bool _verify() {
    if (_nicknameController.text.trim().isEmpty) {
      FocusScope.of(context).requestFocus(_nicknameFocusNode);
      BotToast.showText(text: '昵称不能为空！');
      return false;
    } else if (_titleController.text.trim().isEmpty) {
      FocusScope.of(context).requestFocus(_titleFocusNode);
      BotToast.showText(text: '标题不能为空');
      return false;
    } else if (_contentController.text.trim().length < 20) {
      FocusScope.of(context).requestFocus(_contentFocusNode);
      BotToast.showText(text: '反馈内容需要大于20字！');
      return false;
    } else {
      return true;
    }
  }
}

Future gotoFeedbackView(BuildContext context) async {
  return await Application.router.navigateTo(context, Routes.feedback);
}
