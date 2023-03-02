import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:pet_charity/states/user.dart';

import 'package:pet_charity/models/adopt/pet_adopt.dart';
import 'package:pet_charity/models/adopt/pet_adopt_list.dart';

import 'package:pet_charity/service/adopt_server.dart' as adopt_server;

import 'package:pet_charity/routers/application.dart';
import 'package:pet_charity/routers/routes.dart';

import 'package:pet_charity/view/adopt/adopt_edit_page.dart';
import 'package:pet_charity/view/adopt/adopt_card.dart';
import 'package:pet_charity/view/utils/extension/extension_state.dart';
import 'package:pet_charity/view/view/my_404.dart';
import 'package:pet_charity/view/view/my_loading_view.dart';
import 'package:pet_charity/view/view/my_scaffold.dart';

class MyAdoptListPage extends StatefulWidget {
  const MyAdoptListPage({Key? key}) : super(key: key);

  @override
  State<MyAdoptListPage> createState() => _MyAdoptListPageState();
}

class _MyAdoptListPageState extends State<MyAdoptListPage> {
  // 宠物领养数据
  bool _shouldShowAdopt = false;
  List<PetAdopt> _adoptList = [];
  int _adoptPage = 1;

  @override
  void initState() {
    _initPetAdopt();
    super.initState();
  }

  Future<void> _initPetAdopt() async {
    _adoptList = [];
    _adoptPage = 1;
    await _adoptLoading();
    _shouldShowAdopt = true;
    mySetState(() {});
  }

  /// 获取领养
  Future<IndicatorResult> _adoptLoading() async {
    PetAdoptList? list = await adopt_server.adoptList(
      page: _adoptPage,
      userId: context.read<UserModel>().user?.id ?? 0,
    );
    if (list != null) {
      _adoptList.addAll(list.results ?? []);
      _adoptPage++;
      mySetState(() {});
      return IndicatorResult.success;
    } else {
      return IndicatorResult.noMore;
    }
  }

  Future<void> _refreshAdopt() async {
    await _initPetAdopt();
    await Future.delayed(const Duration(seconds: 2)).then((e) => setState(() {}));
    BotToast.showText(text: "刷新成功");
  }

  @override
  Widget build(BuildContext context) => MyScaffold(
      title: '我的发布',
      rightView: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(32)),
        onTap: _addPet,
        child: Ink(padding: const EdgeInsets.all(8), child: const Icon(Icons.add)),
      ),
      body: _buildAdopt());

  /// 领养
  Widget _buildAdopt() {
    if (!_shouldShowAdopt) {
      return MyLoadingView(size: 128.w);
    }
    if (_adoptList.isEmpty) {
      return const My404();
    }
    return EasyRefresh.builder(
      header: const CupertinoHeader(),
      footer: const CupertinoFooter(),
      onLoad: _adoptLoading,
      onRefresh: _refreshAdopt,
      childBuilder: (BuildContext context, ScrollPhysics physics) {
        return CustomScrollView(
          physics: physics,
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return AdoptCard(_adoptList[index], () => _editPet(_adoptList[index]));
                },
                childCount: _adoptList.length,
              ),
            ),
          ],
        );
      },
    );
  }

  void _addPet() async {
    bool? isSuccess = await gotoAdoptAddPage(context);
    if (isSuccess == true) {
      _refreshAdopt();
    }
  }

  void _editPet(PetAdopt adopt) async {
    bool? isSuccess = await gotoAdoptEditPage(context, adopt);
    if (isSuccess == true) {
      _initPetAdopt();
    }
  }
}

Future<bool?> gotoMyAdoptListPage(BuildContext context) async {
  return await Application.router.navigateTo(context, Routes.myPetAdoptList);
}
