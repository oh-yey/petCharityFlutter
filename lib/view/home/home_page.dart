import 'package:flutter/material.dart';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:pet_charity/common/config.dart';

import 'package:pet_charity/models/other/statistics_result.dart';
import 'package:pet_charity/models/adopt/pet_adopt.dart';
import 'package:pet_charity/models/adopt/pet_adopt_list.dart';
import 'package:pet_charity/models/donate/pet_donate.dart';
import 'package:pet_charity/models/donate/pet_donate_list.dart';

import 'package:pet_charity/service/statistics.dart';
import 'package:pet_charity/service/donate_server.dart';
import 'package:pet_charity/service/adopt_server.dart';

import 'package:pet_charity/view/home/home_search_view.dart';
import 'package:pet_charity/view/home/home_data_show_view.dart';
import 'package:pet_charity/view/home/home_ad_view.dart';
import 'package:pet_charity/view/home/sliver_header_delegate.dart';
import 'package:pet_charity/view/donate/donate_card.dart';
import 'package:pet_charity/view/donate/donate_details_page.dart';
import 'package:pet_charity/view/donate/donate_help_donation_leaderboard_page.dart';
import 'package:pet_charity/view/adopt/adopt_card.dart';
import 'package:pet_charity/view/adopt/adopt_details_page.dart';
import 'package:pet_charity/view/search/search_page.dart';
import 'package:pet_charity/view/utils/extension/extension_state.dart';
import 'package:pet_charity/view/view/my_404.dart';
import 'package:pet_charity/view/view/my_loading_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  // 轮播图 图片
  final List<String> _adList = [
    'http://${Config.ip}:${Config.port}/statics/shuffling/img1.jpg',
    'http://${Config.ip}:${Config.port}/statics/shuffling/img2.jpg',
    'http://${Config.ip}:${Config.port}/statics/shuffling/img3.jpg',
    'http://${Config.ip}:${Config.port}/statics/shuffling/img4.jpg',
  ];

  // 首页展示数据
  StatisticsResult? _statisticsResult;

  // 宠物宠物帮助众筹数据
  bool _shouldShowDonate = false;
  List<PetDonate> _donateList = [];
  int _donatePage = 1;

  // 宠物领养数据
  bool _shouldShowAdopt = false;
  List<PetAdopt> _adoptList = [];
  int _adoptPage = 1;

  @override
  void initState() {
    _initData();
    super.initState();
  }

  /// 数据初始化
  Future<void> _initData() async {
    await _initShowData();
    await _initPetDonate();
    await _initPetAdopt();
    mySetState(() {});
  }

  /// 数据显示初始化
  Future<void> _initShowData() async {
    _statisticsResult = await statistics();
  }

  /// 宠物帮助众筹初始化
  Future<void> _initPetDonate() async {
    _donateList = [];
    _donatePage = 1;
    await _donateLoading();
    _shouldShowDonate = true;
  }

  Future<void> _initPetAdopt() async {
    _adoptList = [];
    _adoptPage = 1;
    await _adoptLoading();
    _shouldShowAdopt = true;
  }

  /// 获取宠物帮助众筹
  Future<IndicatorResult> _donateLoading() async {
    PetDonateList? list = await donateList(page: _donatePage);
    if (list != null) {
      _donateList.addAll(list.results ?? []);
      _donatePage++;
      mySetState(() {});
      return IndicatorResult.success;
    } else {
      return IndicatorResult.noMore;
    }
  }

  /// 获取领养
  Future<IndicatorResult> _adoptLoading() async {
    PetAdoptList? list = await adoptList(page: _adoptPage);
    if (list != null) {
      _adoptList.addAll(list.results ?? []);
      _adoptPage++;
      mySetState(() {});
      return IndicatorResult.success;
    } else {
      return IndicatorResult.noMore;
    }
  }

  // Future<void> _refresh() async {
  //   await _initData();
  //   await Future.delayed(const Duration(seconds: 2)).then((e) => setState(() {}));
  //   BotToast.showText(text: "刷新成功");
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: DefaultTabController(length: 2, child: _buildNestedScrollView()));
  }

  Widget _buildNestedScrollView() {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          // 搜索
          SliverPersistentHeader(
            pinned: true,
            delegate: SliverHeaderDelegate(
              minHeight: 360.h,
              maxHeight: 360.h,
              child: HomeSearchView(_gotoSearch),
            ),
          ),
          // 轮播图 数据显示
          SliverOverlapAbsorber(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            sliver: SliverToBoxAdapter(
              child: Column(children: [
                HomeADView(_adList),
                HomeDataShowView(_statisticsResult),
              ]),
            ),
          ),
          // Tap
          SliverPersistentHeader(
            pinned: true,
            delegate: SliverHeaderDelegate(minHeight: 96.h, maxHeight: 128.h, child: _buildTabBar()),
          ),
        ];
      },
      body: TabBarView(children: [_buildTapDonate(), _buildTapAdopt()]),
    );
  }

  /// Tab
  Widget _buildTabBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 4.h),
      child: TabBar(
        indicatorColor: Theme.of(context).colorScheme.primaryContainer,
        labelColor: Theme.of(context).colorScheme.primaryContainer,
        unselectedLabelColor: Theme.of(context).textTheme.titleMedium?.color?.withOpacity(0.5),
        labelStyle: const TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
        tabs: const [Tab(text: '众筹'), Tab(text: '领养')],
      ),
    );
  }

  /// 宠物帮助众筹
  Widget _buildTapDonate() {
    if (!_shouldShowDonate) {
      return MyLoadingView(size: 128.w);
    }
    if (_donateList.isEmpty) {
      return const My404();
    }
    return EasyRefresh.builder(
      footer: const CupertinoFooter(),
      onLoad: _donateLoading,
      childBuilder: (BuildContext context, ScrollPhysics physics) {
        return CustomScrollView(
          physics: physics,
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => DonateCard(
                  _donateList[index],
                  () => _gotoDonateDetails(_donateList[index]),
                  () => _gotoLeaderboard(_donateList[index]),
                ),
                childCount: _donateList.length,
              ),
            ),
          ],
        );
      },
    );
  }

  /// 领养
  Widget _buildTapAdopt() {
    if (!_shouldShowAdopt) {
      return MyLoadingView(size: 128.w);
    }
    if (_adoptList.isEmpty) {
      return const My404();
    }
    return EasyRefresh.builder(
      footer: const CupertinoFooter(),
      onLoad: _adoptLoading,
      childBuilder: (BuildContext context, ScrollPhysics physics) {
        return CustomScrollView(
          physics: physics,
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => AdoptCard(_adoptList[index], () => _gotoAdoptDetails(_adoptList[index])),
                childCount: _adoptList.length,
              ),
            ),
          ],
        );
      },
    );
  }

  // 搜索
  void _gotoSearch() => gotoSearchPage(context);

  // 跳转到众筹详情页面
  void _gotoDonateDetails(PetDonate petDonate) => gotoPetDonateDetails(context, petDonate);

  // 跳转到排行榜
  void _gotoLeaderboard(PetDonate petDonate) => gotoPetDonateHelpDonationLeaderboard(context, petDonate.donationList);

  // 跳转到领养详情页面
  void _gotoAdoptDetails(PetAdopt petAdopt) => gotoPetAdoptDetails(context, petAdopt);
}
