import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:pet_charity/models/question/question.dart';

import 'package:pet_charity/service/question_server.dart' as question_server;

import 'package:pet_charity/routers/application.dart';
import 'package:pet_charity/routers/routes.dart';

import 'package:pet_charity/view/view/my_scaffold.dart';
import 'package:pet_charity/view/utils/my_input_decoration.dart';
import 'package:pet_charity/view/utils/extension/extension_state.dart';

class QuestionEditPage extends StatefulWidget {
  final Question? question;
  final bool isAdd;

  const QuestionEditPage({this.isAdd = true, this.question, Key? key}) : super(key: key);

  @override
  State<QuestionEditPage> createState() => _QuestionEditPageState();
}

class _QuestionEditPageState extends State<QuestionEditPage> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  num classificationId = 1;

  @override
  void initState() {
    super.initState();
    classificationId = widget.question?.classification?.id ?? classificationId;
    _controller.text = widget.question?.question ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      title: widget.isAdd ? '问答添加' : '问答编辑',
      rightView: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(32)),
        onTap: _save,
        child: Ink(padding: const EdgeInsets.all(8), child: const Icon(Icons.save)),
      ),
      body: Column(
        children: [
          InkWell(
            onTap: () {
              mySetState(() {
                classificationId = classificationId == 1 ? 2 : 1;
              });
            },
            child: Ink(
              padding: EdgeInsets.symmetric(vertical: 48.h, horizontal: 48.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [const Text('分组'), Text(classificationId == 1 ? '品种百科' : '能不能吃')],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 38.w, vertical: 32.h),
            child: TextField(
              scrollPadding: EdgeInsets.zero,
              decoration: myColorInputDecoration(
                contentPadding: const EdgeInsets.all(12),
                hintText: '请输入',
                color: Theme.of(context).textTheme.titleMedium?.color ?? Colors.black,
              ),
              controller: _controller,
              focusNode: _focusNode,
              onSubmitted: (e) => _save(),
              minLines: 5,
              maxLines: 10,
              showCursor: true,
            ),
          ),
        ],
      ),
    );
  }

  void _save() async {
    if (_controller.text.trim().length < 10) {
      FocusScope.of(context).requestFocus(_focusNode);
      BotToast.showText(text: '内容需要大于10字！');
    } else {
      if (widget.isAdd) {
        bool isSuccess = await question_server.createQuestion(
          classification: classificationId,
          question: _controller.text.trim(),
        );
        if (isSuccess) {
          BotToast.showText(text: '创建成功');
          if (!mounted) return;
          Navigator.pop(context, true);
        } else {
          BotToast.showText(text: '未知错误');
        }
      } else {
        bool isSuccess = await question_server.updateQuestion(
          widget.question?.id ?? 0,
          classification: classificationId,
          question: _controller.text.trim(),
        );
        if (isSuccess) {
          BotToast.showText(text: '修改成功');
          if (!mounted) return;
          Navigator.pop(context, true);
        } else {
          BotToast.showText(text: '未知错误');
        }
      }
    }
  }
}

Future gotoQuestionEditPage(BuildContext context, Question question) async {
  String encode = Uri.encodeComponent(jsonEncode(question.toJson()));
  return await Application.router.navigateTo(context, '${Routes.questionEdit}?question=$encode');
}

Future gotoQuestionAddPage(BuildContext context) async {
  return await Application.router.navigateTo(context, Routes.questionAdd);
}
