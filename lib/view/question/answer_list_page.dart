import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pet_charity/models/user/user.dart';

import 'package:pet_charity/states/color_schemes.g.dart';
import 'package:pet_charity/states/user.dart';

import 'package:pet_charity/models/public/detail.dart';
import 'package:pet_charity/models/question/answer.dart';
import 'package:pet_charity/models/question/answer_list.dart';
import 'package:pet_charity/models/question/question.dart';

import 'package:pet_charity/service/user_server.dart' as user_service;
import 'package:pet_charity/service/question_server.dart' as question_server;

import 'package:pet_charity/routers/application.dart';
import 'package:pet_charity/routers/routes.dart';

import 'package:pet_charity/tools/date.dart';
import 'package:pet_charity/tools/user_tools.dart';

import 'package:pet_charity/view/question/answer_page.dart';
import 'package:pet_charity/view/utils/dark.dart';
import 'package:pet_charity/view/view/my_404.dart';
import 'package:pet_charity/view/view/my_scaffold.dart';
import 'package:pet_charity/view/view/my_loading_view.dart';
import 'package:pet_charity/view/view/image/clip_image.dart';
import 'package:pet_charity/view/view/pet/pet_bottom_button.dart';
import 'package:pet_charity/view/utils/extension/extension_state.dart';

class AnswerListPage extends StatefulWidget {
  final Question question;

  const AnswerListPage(this.question, {Key? key}) : super(key: key);

  @override
  State<AnswerListPage> createState() => _AnswerListPageState();
}

class _AnswerListPageState extends State<AnswerListPage> {
  // 问答数据
  bool _shouldShow = false;
  List<Answer> _answerList = [];
  int _answerPage = 1;

  @override
  void initState() {
    super.initState();
    _initAnswer();
  }

  /// 问答初始化
  Future<void> _initAnswer() async {
    _answerList = [];
    _answerPage = 1;
    await _answerLoading();
    _shouldShow = true;
    mySetState(() {});
  }

  /// 获取数据
  Future<IndicatorResult> _answerLoading() async {
    AnswerList? list = await question_server.answerList(widget.question.id ?? 0, page: _answerPage);
    if (list != null) {
      _answerList.addAll(list.results ?? []);
      _answerPage++;
      mySetState(() {});
      await Future.delayed(kThemeAnimationDuration * 2);
      return IndicatorResult.success;
    } else {
      return IndicatorResult.noMore;
    }
  }

  Future<void> _refresh() async {
    await _initAnswer();
    await Future.delayed(const Duration(seconds: 2)).then((e) => setState(() {}));
    BotToast.showText(text: "刷新成功");
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      title: '问答',
      body: Column(
        children: [
          _buildQuestionCard(),
          Expanded(child: _buildAnswerList()),
          _buildBottomCard(),
        ],
      ),
    );
  }

  Widget _buildQuestionCard() {
    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 48.h),
        child: Column(
          children: [
            Row(
              children: [
                ClipImage(widget.question.user?.head ?? '', size: 156.w),
                SizedBox(width: 20.w),
                Text(widget.question.user?.nickname ?? '', textScaleFactor: 1.125),
                const Spacer(),
                Opacity(opacity: 0.5, child: Text(calculateHowLongTime(widget.question.createTime))),
                SizedBox(width: 20.w),
              ],
            ),
            SizedBox(height: 20.h),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 12.w, right: 20.w),
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 2.w),
                    borderRadius: BorderRadius.all(Radius.circular(12.w)),
                    color: Colours.questionCard1,
                  ),
                  child: const Text("问", style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white)),
                ),
                Expanded(
                  child: Text(
                    widget.question.question ?? '',
                    textScaleFactor: 1.25,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 问题答案列表
  Widget _buildAnswerList() {
    if (!_shouldShow) {
      return MyLoadingView(size: 128.w);
    }
    if (_answerList.isEmpty) {
      return const My404();
    }
    return EasyRefresh.builder(
      header: const CupertinoHeader(),
      footer: const CupertinoFooter(),
      onLoad: _answerLoading,
      onRefresh: _refresh,
      childBuilder: (BuildContext context, ScrollPhysics physics) {
        return CustomScrollView(
          physics: physics,
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _buildItem(_answerList[index]),
                childCount: _answerList.length,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildItem(Answer answer) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      child: Card(
        color: Theme.of(context).cardColor.withOpacity(0.25),
        child: InkWell(
          onTap: () => _onDel(answer),
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 48.h),
            child: Column(
              children: [
                Row(
                  children: [
                    ClipImage(answer.user?.head ?? '', size: 156.w),
                    SizedBox(width: 20.w),
                    Text(answer.user?.nickname ?? '', textScaleFactor: 1.125),
                    const Spacer(),
                    Opacity(opacity: 0.5, child: Text(calculateHowLongTime(answer.createTime))),
                    SizedBox(width: 20.w),
                  ],
                ),
                SizedBox(height: 16.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 12.w, right: 20.w),
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 2.w),
                        borderRadius: BorderRadius.all(Radius.circular(12.w)),
                        color: Colours.questionCard2,
                      ),
                      child: const Text("答", style: TextStyle(fontWeight: FontWeight.w800)),
                    ),
                    Expanded(child: Text(answer.answer ?? '')),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomCard() {
    return Padding(
      padding: EdgeInsets.only(top: 12.h, left: 24.w, right: 24.w),
      child: Row(
        children: [
          PetBottomButtonWidget('assets/public/收藏.svg', '收藏', onTap: like, color: isCollect ? Colors.red : null, flex: 3),
          PetBottomButtonWidget('assets/public/分享.svg', '分享', onTap: share, flex: 3),
          const Spacer(flex: 2),
          Expanded(flex: 12, child: _buildBottomButton())
        ],
      ),
    );
  }

  Widget _buildBottomButton() {
    return Container(
      margin: EdgeInsets.only(left: 72.w, right: 48.w),
      child: InkWell(
        borderRadius: BorderRadius.circular(48.w),
        onTap: gotoAnswer,
        child: Ink(
          padding: EdgeInsets.symmetric(vertical: 24.h),
          decoration: BoxDecoration(color: Colours.mainColor, borderRadius: BorderRadius.circular(48.w)),
          child: Text('我来回答', style: TextStyle(color: Colors.white, fontSize: 48.sp), textAlign: TextAlign.center),
        ),
      ),
    );
  }

  void gotoAnswer() async {
    if (!judgeLogin(context)) {
      BotToast.showText(text: '未登录');
      return;
    }
    bool? isSuccess = await gotoAnswerPage(context, widget.question);
    if (isSuccess == true) {
      _initAnswer();
    }
  }

  get isCollect => widget.question.isCollect ?? false;

  set isCollect(isCollect) {
    if (isCollect && widget.question.collectCount != null) {
      widget.question.collectCount = widget.question.collectCount! + 1;
    } else {
      widget.question.collectCount = widget.question.collectCount! - 1;
    }
    widget.question.isCollect = isCollect;
  }

  // 收藏
  void like() async {
    if (!judgeLogin(context)) {
      BotToast.showText(text: '未登录');
      return;
    }
    Detail code = await user_service.collect(3, widget.question.id ?? 0, isCollect);

    // 提示
    if (code.code == 200) {
      isCollect = !isCollect;
      if (isCollect) {
        BotToast.showText(text: '收藏成功');
      } else {
        BotToast.showText(text: '取消收藏成功');
      }
    } else {
      BotToast.showText(text: '收藏失败');
    }
    mySetState(() {});
  }

  // 分享
  void share() {
    //
  }

  void _onDel(Answer answer) {
    User? user = Provider.of<UserModel>(context, listen: false).user;
    if (!(user?.id != null && user?.id == answer.user?.id)) {
      return;
    }
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text('答案删除'),
            content: const Text('删除操作不可恢复'),
            actions: [
              CupertinoButton(
                onPressed: () => Navigator.pop(context),
                child: Text('取消', style: TextStyle(color: Theme.of(context).textTheme.titleMedium?.color)),
              ),
              CupertinoButton(
                onPressed: () => _delPet(answer.id ?? 0),
                child: Text('确认', style: TextStyle(color: CupertinoColors.destructiveRed.withOpacity(isDark(context) ? 0.5 : 1))),
              ),
            ],
          );
        });
  }

  void _delPet(num id) async {
    Navigator.pop(context);
    bool isSuccess = await question_server.deleteAnswer(id);
    if (isSuccess) {
      BotToast.showText(text: '删除成功');
      _answerList.removeWhere((element) => element.id == id);
      mySetState(() {});
    } else {
      BotToast.showText(text: '删除失败');
    }
  }
}

void gotoAnswerListPage(BuildContext context, Question question) {
  String encode = Uri.encodeComponent(jsonEncode(question.toJson()));
  Application.router.navigateTo(context, '${Routes.answerList}?question=$encode');
}
