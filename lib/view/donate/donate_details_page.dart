import 'dart:math';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter_svg/svg.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:pet_charity/states/color_schemes.g.dart';

import 'package:pet_charity/models/public/detail.dart';
import 'package:pet_charity/models/donate/donate.dart';
import 'package:pet_charity/models/donate/pet_donate.dart';
import 'package:pet_charity/models/pet/pet_images.dart';

import 'package:pet_charity/service/user_server.dart' as user_service;

import 'package:pet_charity/routers/application.dart';
import 'package:pet_charity/routers/routes.dart';

import 'package:pet_charity/tools/user_tools.dart';

import 'package:pet_charity/view/home/sliver_header_delegate.dart';
import 'package:pet_charity/view/donate/donate_details_custom_chapter.dart';
import 'package:pet_charity/view/donate/donate_help_donation_leaderboard_page.dart';
import 'package:pet_charity/view/donate/donate_help_donation_page.dart';
import 'package:pet_charity/view/donate/donate_progress.dart';
import 'package:pet_charity/view/utils/extension/extension_state.dart';
import 'package:pet_charity/view/view/image/my_image.dart';
import 'package:pet_charity/view/view/my_shader_mask.dart';
import 'package:pet_charity/view/view/my_title.dart';
import 'package:pet_charity/view/view/my_wrap.dart';
import 'package:pet_charity/view/view/pet/pet_bottom_button.dart';
import 'package:pet_charity/view/view/image/clip_image.dart';

class DonateDetailsPage extends StatefulWidget {
  final PetDonate donate;

  const DonateDetailsPage(this.donate, {Key? key}) : super(key: key);

  @override
  State<DonateDetailsPage> createState() => _DonateDetailsPageState();
}

class _DonateDetailsPageState extends State<DonateDetailsPage> {
  @override
  void initState() {
    initComment();
    super.initState();
  }

  void initComment() {
    //
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                // 头部
                SliverPersistentHeader(
                  pinned: true,
                  delegate: SliverHeaderDelegate(
                    minHeight: 1200.h,
                    maxHeight: 1200.h,
                    child: _buildDetailsHead(),
                  ),
                ),
                // 众筹标题
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 48.w, vertical: 8.h),
                  sliver: SliverToBoxAdapter(child: _buildTextTitle('众筹说明')),
                ),
                // 宠物详情卡片
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 48.w),
                  sliver: SliverToBoxAdapter(child: _buildPetDescriptionCard()),
                ),
                // 收藏
                SliverPadding(
                  padding: EdgeInsets.only(left: 48.w, right: 48.w, bottom: 12.h),
                  sliver: SliverToBoxAdapter(child: _buildCollect()),
                ),
                // 留言
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 48.w),
                  sliver: const SliverToBoxAdapter(
                    child: SizedBox(),
                  ),
                ),
              ],
            ),
          ),
          SafeArea(top: false, child: _buildBottomCard()),
        ],
      ),
    );
  }

  /// 头部
  Widget _buildDetailsHead() {
    return SizedBox(
      width: 1290.w,
      height: 1200.h,
      child: Stack(
        children: [
          MyShaderMask(1290.w, 1200.h),
          SafeArea(
            bottom: false,
            child: Stack(
              children: <Widget>[
                // title
                Positioned(
                  left: 0,
                  top: 0,
                  width: 1290.w,
                  height: 120.h,
                  child: const MyTitle('宠物帮助众筹'),
                ),
                // 宠物信息
                Positioned(
                  left: 48.w,
                  top: 200.h,
                  right: 48.w,
                  child: _buildPetMessage(),
                ),
                // 章
                Positioned(
                  top: 128.h,
                  right: 48.w,
                  child: _buildChapter(),
                ),
                // 章图片
                Positioned(
                  top: 128.h,
                  right: 48.h,
                  child: _buildClaws(),
                ),
                Positioned(
                  top: 480.h,
                  left: 32.w,
                  right: 32.w,
                  child: _buildCard(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPetMessage() {
    return Row(
      children: <Widget>[
        ClipImage(widget.donate.coverImage?.image ?? '', size: 192.w, tag: widget.donate.coverImage?.image),
        SizedBox(width: 32.w),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AutoSizeText(widget.donate.name ?? '', style: TextStyle(fontSize: 60.sp), maxLines: 1, overflow: TextOverflow.ellipsis),
              SizedBox(height: 12.h),
              Wrap(
                spacing: 24.w,
                children: [
                  MyWrap(widget.donate.breed?.name ?? ''),
                  MyWrap(widget.donate.breed?.variety ?? ''),
                ],
              ),
            ],
          ),
        ),
        SizedBox(width: 300.w),
      ],
    );
  }

  Widget _buildChapter() {
    return SizedBox(
      width: 300.w,
      height: 300.h,
      child: Center(child: CustomPaint(painter: CustomChapter())),
    );
  }

  Widget _buildClaws() {
    return SizedBox(
      width: 300.w,
      height: 300.h,
      child: Center(
        child: Opacity(
          opacity: 0.5,
          child: Transform.rotate(
            angle: pi / 6,
            child: SvgPicture.asset('assets/donate/claws.svg', height: 108.h, colorFilter: const ColorFilter.mode(Colours.lilac, BlendMode.srcIn)),
          ),
        ),
      ),
    );
  }

  Card _buildCard() {
    return Card(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 32.w),
        height: 420.h,
        child: Column(
          children: [
            Expanded(
              child: DonateProgress(
                widget.donate.amount ?? 0,
                widget.donate.alreadyAmount ?? 0,
                widget.donate.alreadyPeopleCount ?? 0,
              ),
            ),
            Divider(thickness: 1.h),
            Expanded(child: _buildDonationList()),
          ],
        ),
      ),
    );
  }

  Container _buildDonationList() {
    List<Donate>? donationList = widget.donate.donationList;
    return Container(
      padding: EdgeInsets.only(bottom: 24.h, top: 24.h),
      child: Row(
        children: <Widget>[
          Text('爱心捐赠榜:', style: TextStyle(fontSize: 48.sp)),
          const Spacer(),
          Row(
            children: donationList
                    ?.sublist(0, donationList.length > 3 ? 3 : donationList.length)
                    .map(
                      (donate) => Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: ClipImage(donate.user?.head ?? '', size: 72.w),
                      ),
                    )
                    .toList() ??
                [],
          ),
          SizedBox(width: 24.w),
          InkWell(
            borderRadius: BorderRadius.circular(8.w),
            onTap: gotoLeaderboard,
            child: Ink(
              padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
              child: const Icon(CupertinoIcons.forward),
            ),
          ),
        ],
      ),
    );
  }

  // 标题
  Widget _buildTextTitle(String title) => Text(title, style: TextStyle(fontSize: 48.sp, fontWeight: FontWeight.w900));

  // 宠物详情卡片
  Widget _buildPetDescriptionCard() {
    return Card(
      child: Padding(
        padding: EdgeInsets.only(left: 32.w, right: 32.w, top: 48.h, bottom: 72.h),
        child: Column(
          children: [
            Text(widget.donate.description ?? ''),
            SizedBox(height: 24.h),
            _buildDonateImages(widget.donate),
          ],
        ),
      ),
    );
  }

  // 宠物图片
  Widget _buildDonateImages(PetDonate petDonate) {
    List<PetImages>? images = petDonate.images;
    if (images == null || images.isEmpty == true) {
      return const SizedBox();
    }
    return SizedBox(
      height: 400.h,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: images.length,
          itemBuilder: (context, index) => Container(
            margin: EdgeInsets.only(left: index > 0 ? 24.w : 0, right: index == images.length - 1 ? 24.w : 0),
            child: MyImage(images[index].image ?? ''),
          ),
        ),
      ),
    );
  }

  // 跳转到排行榜
  void gotoLeaderboard() {
    gotoPetDonateHelpDonationLeaderboard(context, widget.donate.donationList);
  }

  // 收藏
  Widget _buildCollect() {
    return Row(
      children: [
        const Text('钱款最终已财报为主'),
        const Spacer(),
        SvgPicture.asset('assets/public/收藏2.svg', height: 48.h),
        SizedBox(width: 12.w),
        Text('${widget.donate.collectCount ?? 0}'),
      ],
    );
  }

  // 底部按钮
  Widget _buildBottomCard() {
    return Padding(
      padding: EdgeInsets.only(top: 12.h, left: 24.w, right: 24.w),
      child: Row(
        children: [
          PetBottomButtonWidget('assets/public/收藏.svg', '收藏', onTap: like, color: isCollect ? Colors.red : null),
          PetBottomButtonWidget('assets/public/分享.svg', '分享', onTap: share),
          PetBottomButtonWidget('assets/public/留言.svg', '留言', onTap: comments),
          Expanded(flex: 4, child: _buildBottomButton())
        ],
      ),
    );
  }

  Widget _buildBottomButton() {
    return Container(
      margin: EdgeInsets.only(left: 72.w, right: 48.w),
      child: InkWell(
        borderRadius: BorderRadius.circular(48.w),
        onTap: help,
        child: Ink(
          padding: EdgeInsets.symmetric(vertical: 24.h),
          decoration: BoxDecoration(color: Colours.mainColor, borderRadius: BorderRadius.circular(48.w)),
          child: Text(widget.donate.state == 1 ? '我要帮帮TA' : '---', style: TextStyle(color: Colors.white, fontSize: 48.sp), textAlign: TextAlign.center),
        ),
      ),
    );
  }

  get isCollect => widget.donate.isCollect ?? false;

  set isCollect(isCollect) {
    if (isCollect && widget.donate.collectCount != null) {
      widget.donate.collectCount = widget.donate.collectCount! + 1;
    } else {
      widget.donate.collectCount = widget.donate.collectCount! - 1;
    }
    widget.donate.isCollect = isCollect;
  }

  // 收藏
  void like() async {
    Detail code = await user_service.collect(1, widget.donate.id ?? 0, isCollect);

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

  // 留言
  void comments() {
    //
  }

  // 捐赠
  void help() async {
    if (!judgeLogin(context)) {
      BotToast.showText(text: '未登录');
      return;
    }
    if (widget.donate.state == 1) {
      int? money = await gotoDonateHelpDonation(context, widget.donate);
      if (money != null) {
        debugPrint('$money');
        mySetState(() {
          if (widget.donate.alreadyAmount != null) {
            widget.donate.alreadyAmount = widget.donate.alreadyAmount! + money;
          }
          if (widget.donate.alreadyPeopleCount != null) {
            widget.donate.alreadyPeopleCount = widget.donate.alreadyPeopleCount! + 1;
          }
        });
      }
    } else {
      BotToast.showText(text: '当前不可捐赠！！！');
    }
  }
}

void gotoPetDonateDetails(BuildContext context, PetDonate petDonate) {
  String encodeDonate = Uri.encodeComponent(jsonEncode(petDonate.toJson()));
  Application.router.navigateTo(context, '${Routes.petDonateDetails}?donate=$encodeDonate');
}
