import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:pet_charity/models/question/question.dart';

import 'package:pet_charity/service/question_server.dart' as question_server;

import 'package:pet_charity/routers/application.dart';
import 'package:pet_charity/routers/routes.dart';

import 'package:pet_charity/view/utils/my_input_decoration.dart';
import 'package:pet_charity/view/view/my_scaffold.dart';

class AnswerPage extends StatefulWidget {
  final Question question;

  const AnswerPage(this.question, {Key? key}) : super(key: key);

  @override
  State<AnswerPage> createState() => _AnswerPageState();
}

class _AnswerPageState extends State<AnswerPage> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      title: widget.question.question ?? '',
      rightView: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(32)),
        onTap: _save,
        child: Ink(padding: const EdgeInsets.all(8), child: const Icon(Icons.save)),
      ),
      body: Padding(
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
    );
  }

  void _save() async {
    if (_controller.text.trim().length < 10) {
      FocusScope.of(context).requestFocus(_focusNode);
      BotToast.showText(text: '内容需要大于10字！');
    } else {
      question_server.createAnswer(question: widget.question.id ?? 0, answer: _controller.text.trim()).then((bool isSuccess) {
        if (isSuccess) {
          BotToast.showText(text: '回复成功！');
          Navigator.of(context).pop(true);
        } else {
          BotToast.showText(text: '未知错误');
        }
      });
    }
  }
}

Future<bool?> gotoAnswerPage(BuildContext context, Question question) async {
  String encode = Uri.encodeComponent(jsonEncode(question.toJson()));
  return await Application.router.navigateTo(context, '${Routes.answer}?question=$encode');
}
