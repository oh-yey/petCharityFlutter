import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:provider/provider.dart';
import 'package:flutter_svg/svg.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:pet_charity/states/color_schemes.g.dart';
import 'package:pet_charity/states/user.dart';

import 'package:pet_charity/models/user/user.dart';
import 'package:pet_charity/models/question/question.dart';
import 'package:pet_charity/models/question/question_list.dart';

import 'package:pet_charity/service/question_server.dart' as question_server;

import 'package:pet_charity/tools/date.dart';
import 'package:pet_charity/tools/user_tools.dart';

import 'package:pet_charity/view/utils/dark.dart';
import 'package:pet_charity/view/view/my_404.dart';
import 'package:pet_charity/view/view/my_shader_mask.dart';
import 'package:pet_charity/view/view/my_loading_view.dart';
import 'package:pet_charity/view/view/image/clip_image.dart';
import 'package:pet_charity/view/question/answer_list_page.dart';
import 'package:pet_charity/view/question/question_edit_page.dart';
import 'package:pet_charity/view/utils/extension/extension_state.dart';

class QuestionAndAnswerPage extends StatefulWidget {
  const QuestionAndAnswerPage({Key? key}) : super(key: key);

  @override
  State<QuestionAndAnswerPage> createState() => _QuestionAndAnswerPageState();
}

class _QuestionAndAnswerPageState extends State<QuestionAndAnswerPage> {
  int classification = 1;

  // 问答数据
  bool _shouldShow = false;
  List<Question> _questionList = [];
  int _questionPage = 1;

  @override
  void initState() {
    super.initState();
    _initQuestion();
  }

  /// 问答初始化
  Future<void> _initQuestion() async {
    _questionList = [];
    _questionPage = 1;
    await _questionLoading();
    _shouldShow = true;
    mySetState(() {});
  }

  /// 获取数据
  Future<IndicatorResult> _questionLoading() async {
    QuestionList? list = await question_server.questionList(classification: classification, page: _questionPage);
    if (list != null) {
      _questionList.addAll(list.results ?? []);
      _questionPage++;
      mySetState(() {});
      return IndicatorResult.success;
    } else {
      return IndicatorResult.noMore;
    }
  }

  Future<void> _refresh() async {
    await _initQuestion();
    await Future.delayed(const Duration(seconds: 2)).then((e) => setState(() {}));
    BotToast.showText(text: "刷新成功");
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MyShaderMask(1290.w, 320.h),
        SafeArea(
          child: Column(
            children: [
              _buildTop(),
              Expanded(child: _buildQuestionList()),
            ],
          ),
        ),
        Positioned(
          right: 64.w,
          bottom: 64.h,
          width: 180.w,
          height: 180.h,
          child: ElevatedButton(
            onPressed: _add,
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }

  Widget _buildTop() {
    return SizedBox(
      width: 1290.w,
      height: 320.h,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildTopItem('品种百科', '傻傻分不清楚', 'assets/question/品种百科.svg', Colours.questionCard1, 1),
            _buildTopItem('能不能吃', '毛孩子嗝屁丸', 'assets/question/能不能吃.svg', Colours.questionCard2, 2),
          ],
        ),
      ),
    );
  }

  Widget _buildTopItem(String title, String content, String icon, Color color, int classification) {
    if (isDark(context)) color = Colors.black;

    return Expanded(
      child: Card(
        color: color,
        child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          child: Padding(
            padding: EdgeInsets.only(left: 48.w, right: 24.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.w600), textScaleFactor: 1.125),
                    SizedBox(height: 12.h),
                    Text(content, textScaleFactor: 0.75),
                  ],
                ),
                SvgPicture.asset(icon, height: 64)
              ],
            ),
          ),
          onTap: () {
            this.classification = classification;
            _initQuestion();
          },
        ),
      ),
    );
  }

  /// 问题列表
  Widget _buildQuestionList() {
    if (!_shouldShow) {
      return MyLoadingView(size: 128.w);
    }
    if (_questionList.isEmpty) {
      return const My404();
    }
    return EasyRefresh.builder(
      header: const CupertinoHeader(),
      footer: const CupertinoFooter(),
      onLoad: _questionLoading,
      onRefresh: _refresh,
      childBuilder: (BuildContext context, ScrollPhysics physics) {
        return CustomScrollView(
          physics: physics,
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _buildItem(_questionList[index]),
                childCount: _questionList.length,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildItem(Question item) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      child: Card(
        child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          onTap: () => _edit(item),
          onLongPress: () => _onDel(item),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 48.h),
            child: Column(
              children: [
                Row(
                  children: [
                    ClipImage(item.user?.head ?? '', size: 156.w),
                    SizedBox(width: 24.w),
                    Text(item.user?.nickname ?? ''),
                    const Spacer(),
                    Opacity(opacity: 0.5, child: Text(calculateHowLongTime(item.createTime))),
                    SizedBox(width: 20.w),
                  ],
                ),
                SizedBox(height: 24.h),
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
                      child: const Text("问", style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white)),
                    ),
                    Expanded(
                      child: Text(
                        item.question ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textScaleFactor: 1.25,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 12.w, right: 20.w),
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 2.w),
                        borderRadius: BorderRadius.all(Radius.circular(12.w)),
                        color: Colours.questionCard2,
                      ),
                      child: const Text("答", style: TextStyle(fontWeight: FontWeight.w700)),
                    ),
                    Expanded(
                      child: Opacity(
                        opacity: 0.875,
                        child: Text(
                          item.newAnswer ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Spacer(flex: 1),
                    Container(
                      margin: EdgeInsets.only(top: 12.h, bottom: 16.h),
                      child: InkWell(
                        borderRadius: const BorderRadius.all(Radius.circular(100)),
                        child: Ink(
                          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 6.h),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.withOpacity(0.5), width: 2.w),
                            borderRadius: const BorderRadius.all(Radius.circular(100)),
                          ),
                          child: Opacity(
                            opacity: 0.5,
                            child: Row(
                              children: [
                                SizedBox(width: 12.w),
                                Text("查看${item.answerCount ?? 0}条问答"),
                                const Icon(CupertinoIcons.forward),
                              ],
                            ),
                          ),
                        ),
                        onTap: () {
                          gotoAnswerListPage(context, item);
                        },
                      ),
                    ),
                    // Spacer(flex: 3),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _add() async {
    if (!judgeLogin(context)) {
      BotToast.showText(text: '未登录');
      return;
    }
    bool? isSuccess = await gotoQuestionAddPage(context);
    if (isSuccess == true) {
      _initQuestion();
    }
  }

  void _edit(Question question) async {
    User? user = Provider.of<UserModel>(context, listen: false).user;
    if (user?.id != null && user?.id == question.user?.id) {
      bool? isSuccess = await gotoQuestionEditPage(context, question);
      if (isSuccess == true) {
        _initQuestion();
      }
    }
  }

  void _onDel(Question question) {
    User? user = Provider.of<UserModel>(context, listen: false).user;
    if (!(user?.id != null && user?.id == question.user?.id)) {
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
                onPressed: () => _delPet(question.id ?? 0),
                child: Text('确认', style: TextStyle(color: CupertinoColors.destructiveRed.withOpacity(isDark(context) ? 0.5 : 1))),
              ),
            ],
          );
        });
  }

  void _delPet(num id) async {
    Navigator.pop(context);
    bool isSuccess = await question_server.deleteQuestion(id);
    if (isSuccess) {
      BotToast.showText(text: '删除成功');
      _questionList.removeWhere((element) => element.id == id);
      mySetState(() {});
    } else {
      BotToast.showText(text: '删除失败');
    }
  }
}
