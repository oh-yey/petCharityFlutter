import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_svg/svg.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:pet_charity/models/adopt/pet_adopt.dart';
import 'package:pet_charity/models/adopt/pet_adopt_list.dart';
import 'package:pet_charity/models/donate/pet_donate.dart';
import 'package:pet_charity/models/donate/pet_donate_list.dart';
import 'package:pet_charity/models/filter/filter_result.dart';

import 'package:pet_charity/service/donate_server.dart' as donate_server;
import 'package:pet_charity/service/adopt_server.dart' as adopt_server;

import 'package:pet_charity/routers/application.dart';
import 'package:pet_charity/routers/routes.dart';

import 'package:pet_charity/view/donate/donate_card.dart';
import 'package:pet_charity/view/donate/donate_details_page.dart';
import 'package:pet_charity/view/donate/donate_help_donation_leaderboard_page.dart';
import 'package:pet_charity/view/adopt/adopt_card.dart';
import 'package:pet_charity/view/adopt/adopt_details_page.dart';
import 'package:pet_charity/view/search/filter_page.dart';
import 'package:pet_charity/view/utils/extension/extension_state.dart';
import 'package:pet_charity/view/utils/my_input_decoration.dart';
import 'package:pet_charity/view/view/my_404.dart';
import 'package:pet_charity/view/view/my_loading_view.dart';
import 'package:pet_charity/view/view/my_shader_mask.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  String _searchText = '';
  FilterResult? filterResult;
  bool _shouldShowData = false;

  // 宠物宠物帮助众筹数据
  bool _shouldShowDonate = false;
  List<PetDonate> _donateList = [];
  int _donatePage = 1;

  // 宠物领养数据
  bool _shouldShowAdopt = false;
  List<PetAdopt> _adoptList = [];
  int _adoptPage = 1;

  /// 宠物帮助众筹初始化
  Future<void> _initPetDonate() async {
    _donateList = [];
    _donatePage = 1;
    await _donateLoading();
    _shouldShowDonate = true;
    mySetState(() {});
  }

  Future<void> _initPetAdopt() async {
    _adoptList = [];
    _adoptPage = 1;
    await _adoptLoading();
    _shouldShowAdopt = true;
    mySetState(() {});
  }

  /// 获取宠物帮助众筹
  Future<IndicatorResult> _donateLoading() async {
    PetDonateList? list = await donate_server.donateList(
      page: _donatePage,
      search: _searchText,
      breed: filterResult?.breed?.id,
      sex: filterResult?.sex,
    );
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
    PetAdoptList? list = await adopt_server.adoptList(
      page: _adoptPage,
      search: _searchText,
      breed: filterResult?.breed?.id,
      sex: filterResult?.sex,
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

  Future<void> _refreshDonate() async {
    await _initPetDonate();
    await Future.delayed(const Duration(seconds: 2)).then((e) => setState(() {}));
    BotToast.showText(text: "刷新成功");
  }

  Future<void> _refreshAdopt() async {
    await _initPetAdopt();
    await Future.delayed(const Duration(seconds: 2)).then((e) => setState(() {}));
    BotToast.showText(text: "刷新成功");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MyShaderMask(1290.w, 1200.h),
          SafeArea(
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: <Widget>[
                  _buildSearchBox(),
                  _buildTabBar(),
                  Expanded(child: _buildTableBarView()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  SizedBox _buildSearchBox() {
    return SizedBox(
      width: 1290.w,
      height: 120.h,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 48.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(
              width: 120.w,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: const BorderRadius.all(Radius.circular(32)),
                  child: const Center(child: Icon(Icons.arrow_back_ios_new)),
                  onTap: () => Navigator.pop(context),
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 48.w),
                padding: EdgeInsets.symmetric(vertical: 12.h),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  color: Theme.of(context).dividerColor.withOpacity(0.15),
                ),
                child: TextField(
                  textAlign: TextAlign.center,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: myTransparentInputDecoration(hintText: '输入搜索内容'),
                  scrollPadding: EdgeInsets.zero,
                  controller: _controller,
                  focusNode: _focusNode,
                  autofocus: true,
                  maxLines: 1,
                  inputFormatters: [LengthLimitingTextInputFormatter(32)],
                  textInputAction: TextInputAction.search,
                  onSubmitted: _search,
                ),
              ),
            ),
            SizedBox(
              width: 120.w,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: const BorderRadius.all(Radius.circular(32)),
                  onTap: _sift,
                  child: Center(child: SvgPicture.asset('assets/search/筛选.svg', width: 96.w)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return const TabBar(
      labelStyle: TextStyle(fontWeight: FontWeight.bold),
      unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
      tabs: [Tab(text: '众筹'), Tab(text: '领养')],
    );
  }

  Widget _buildTableBarView() {
    if (!_shouldShowData) {
      return Container();
    }
    return TabBarView(children: [_buildTapDonate(), _buildTapAdopt()]);
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
      header: const CupertinoHeader(),
      footer: const CupertinoFooter(),
      onLoad: _donateLoading,
      onRefresh: _refreshDonate,
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
                (context, index) => AdoptCard(_adoptList[index], () => _gotoAdoptDetails(_adoptList[index])),
                childCount: _adoptList.length,
              ),
            ),
          ],
        );
      },
    );
  }

  /// 筛选
  void _sift() async {
    filterResult = await gotoFilterPage(context, filterResult);
    _shouldShowData = true;
    if (!mounted) return;
    FocusScope.of(context).requestFocus(_focusNode);
    _initPetDonate();
    _initPetAdopt();
  }

  /// 搜索
  void _search(String text) {
    _searchText = text;
    _shouldShowData = true;
    _initPetDonate();
    _initPetAdopt();
  }

  // 跳转到众筹详情页面
  void _gotoDonateDetails(PetDonate petDonate) => gotoPetDonateDetails(context, petDonate);

  // 跳转到排行榜
  void _gotoLeaderboard(PetDonate petDonate) => gotoPetDonateHelpDonationLeaderboard(context, petDonate.donationList);

  // 跳转到领养详情页面
  void _gotoAdoptDetails(PetAdopt petAdopt) => gotoPetAdoptDetails(context, petAdopt);
}

void gotoSearchPage(BuildContext context) {
  Application.router.navigateTo(context, Routes.search);
}
