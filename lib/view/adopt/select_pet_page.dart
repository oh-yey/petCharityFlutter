import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pet_charity/view/view/my_loading_view.dart';

import 'package:pet_charity/states/user.dart';

import 'package:pet_charity/models/user/user.dart';
import 'package:pet_charity/models/pet/pet.dart';
import 'package:pet_charity/models/pet/pet_list.dart';

import 'package:pet_charity/service/pet_server.dart' as pet_server;

import 'package:pet_charity/routers/application.dart';
import 'package:pet_charity/routers/routes.dart';

import 'package:pet_charity/view/pet/pet_list_item_card.dart';
import 'package:pet_charity/view/utils/extension/extension_state.dart';
import 'package:pet_charity/view/view/my_scaffold.dart';

class SelectPetPage extends StatefulWidget {
  const SelectPetPage({Key? key}) : super(key: key);

  @override
  State<SelectPetPage> createState() => _SelectPetPageState();
}

class _SelectPetPageState extends State<SelectPetPage> {
  late EasyRefreshController _controller;

  User? _user;

  // 宠物数据
  bool _shouldShow = false;
  List<Pet> _petList = [];
  int _page = 1;

  @override
  void initState() {
    _initController();
    _initUser();
    _initPet();
    super.initState();
  }

  void _initController() {
    _controller = EasyRefreshController(
      controlFinishRefresh: true,
      controlFinishLoad: true,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _initUser() {
    _user = context.read<UserModel>().user;
  }

  /// 宠物数据初始化
  Future<void> _initPet() async {
    _petList = [];
    _page = 1;
    await _loading();
    _shouldShow = true;
  }

  // 加载
  Future<void> _loading() async {
    PetList? list = await pet_server.petList(_user?.id ?? 0, page: _page);
    if (list != null) {
      _petList.addAll(list.results ?? []);
      _page++;
      mySetState(() {});
      _controller.finishLoad(IndicatorResult.success);
    } else {
      _controller.finishLoad(IndicatorResult.noMore);
    }
  }

  // 下拉刷新
  Future<void> _refresh() async {
    await _initPet();
    if (!mounted) return;
    _controller.finishRefresh();
    _controller.resetFooter();
  }

  @override
  Widget build(BuildContext context) => MyScaffold(title: '请选择宠物', body: _buildEasyRefresh());

  Widget _buildEasyRefresh() {
    if (!_shouldShow) {
      return MyLoadingView(size: 300.w);
    }
    return EasyRefresh.builder(
      controller: _controller,
      header: const CupertinoHeader(),
      footer: const CupertinoFooter(),
      onLoad: _loading,
      onRefresh: _refresh,
      childBuilder: (BuildContext context, ScrollPhysics physics) {
        return CustomScrollView(
          physics: physics,
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _buildListItemCard(index),
                childCount: _petList.length,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildListItemCard(int index) {
    return PetListItemCard(
      _petList[index],
      onTap: () => Navigator.pop(context, _petList[index]),
    );
  }
}

Future<Pet?> gotoSelectPetPage(BuildContext context) async {
  return await Application.router.navigateTo(context, Routes.selectPet);
}
