import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:pet_charity/states/color_schemes.g.dart';
import 'package:pet_charity/states/user.dart';

import 'package:pet_charity/models/user/user.dart';
import 'package:pet_charity/models/public/detail.dart';
import 'package:pet_charity/models/pet/pet_images.dart';
import 'package:pet_charity/models/adopt/pet_adopt.dart';

import 'package:pet_charity/service/user_server.dart' as user_service;

import 'package:pet_charity/routers/application.dart';
import 'package:pet_charity/routers/routes.dart';

import 'package:pet_charity/tools/user_tools.dart';

import 'package:pet_charity/view/adopt/adopt_details_contact_page.dart';
import 'package:pet_charity/view/pet/pet_cover_image_card.dart';
import 'package:pet_charity/view/utils/extension/extension_state.dart';
import 'package:pet_charity/view/view/image/my_image.dart';
import 'package:pet_charity/view/view/my_scaffold.dart';
import 'package:pet_charity/view/view/pet/pet_bottom_button.dart';

class AdoptDetailsPage extends StatefulWidget {
  final PetAdopt adopt;

  const AdoptDetailsPage(this.adopt, {Key? key}) : super(key: key);

  @override
  State<AdoptDetailsPage> createState() => _AdoptDetailsPageState();
}

class _AdoptDetailsPageState extends State<AdoptDetailsPage> {
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
    return MyScaffold(
      title: '宠物领养',
      body: Column(
        children: [
          Expanded(child: _buildCustomScrollView()),
          _buildBottomCard(),
        ],
      ),
    );
  }

  CustomScrollView _buildCustomScrollView() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: PetCoverImageCard(widget.adopt.pet)),
        // 领养描述标题
        SliverPadding(
          padding: EdgeInsets.only(left: 48.w, right: 48.2, top: 8.h, bottom: 24.h),
          sliver: SliverToBoxAdapter(child: _buildTextTitle('领养描述:')),
        ),
        // 领养描述
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 48.w),
          sliver: SliverToBoxAdapter(child: _buildPetDescriptionCard()),
        ),
        // 领养要求标题
        SliverPadding(
          padding: EdgeInsets.only(left: 48.w, right: 48.2, top: 16.h, bottom: 24.h),
          sliver: SliverToBoxAdapter(child: _buildTextTitle('领养要求:')),
        ),
        // 领养要求
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 48.w),
          sliver: SliverToBoxAdapter(child: _buildPetRequirementsCard()),
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
    );
  }

  Widget _buildTextTitle(String title) => Text(title, style: TextStyle(fontSize: 48.sp, fontWeight: FontWeight.w900));

  // 宠物详情卡片
  Widget _buildPetDescriptionCard() {
    return Card(
      child: Padding(
        padding: EdgeInsets.only(left: 32.w, right: 32.w, top: 48.h, bottom: 72.h),
        child: Column(
          children: [
            Text(widget.adopt.description ?? ''),
            SizedBox(height: 24.h),
            _buildAdoptImages(widget.adopt),
          ],
        ),
      ),
    );
  }

  // 宠物图片
  Widget _buildAdoptImages(PetAdopt petAdopt) {
    List<PetImages>? images = petAdopt.pet?.images;
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

  Widget _buildPetRequirementsCard() {
    return Card(
      child: Padding(
        padding: EdgeInsets.only(left: 32.w, right: 32.w, top: 48.h, bottom: 72.h),
        child: Text(widget.adopt.requirements ?? ''),
      ),
    );
  }

  // 收藏
  Widget _buildCollect() {
    return Row(
      children: [
        const Text('领养需实名认证'),
        const Spacer(),
        SvgPicture.asset('assets/public/收藏2.svg', height: 48.h),
        SizedBox(width: 12.w),
        Text('${widget.adopt.collectCount ?? 0}'),
      ],
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
          // PetBottomButtonWidget('assets/public/留言.svg', '留言', onTap: comments),
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
        onTap: gotoContact,
        child: Ink(
          padding: EdgeInsets.symmetric(vertical: 24.h),
          decoration: BoxDecoration(color: Colours.mainColor, borderRadius: BorderRadius.circular(48.w)),
          child: Text('查看联系方式', style: TextStyle(color: Colors.white, fontSize: 48.sp), textAlign: TextAlign.center),
        ),
      ),
    );
  }

  get isCollect => widget.adopt.isCollect ?? false;

  set isCollect(isCollect) {
    if (isCollect && widget.adopt.collectCount != null) {
      widget.adopt.collectCount = widget.adopt.collectCount! + 1;
    } else {
      widget.adopt.collectCount = widget.adopt.collectCount! - 1;
    }
    widget.adopt.isCollect = isCollect;
  }

  // 收藏
  void like() async {
    if (!judgeLogin(context)) {
      BotToast.showText(text: '未登录');
      return;
    }
    Detail code = await user_service.collect(2, widget.adopt.id ?? 0, isCollect);

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

  // // 留言
  // void comments() {
  //   //
  // }

  // 查看联系方式
  void gotoContact() {
    if (!judgeLogin(context)) {
      BotToast.showText(text: '未登录');
      return;
    }
    if (widget.adopt.pet?.user != null) {
      User? user = context.read<UserModel>().user;
      if (user?.verified == true) {
        gotoAdoptDetailsContact(context, widget.adopt.pet!.user!);
      } else {
        BotToast.showText(text: '请实名认证！');
      }
    } else {
      BotToast.showText(text: '联系方式为空！');
    }
  }
}

void gotoPetAdoptDetails(BuildContext context, PetAdopt petAdopt) {
  String encodeAdopt = Uri.encodeComponent(jsonEncode(petAdopt.toJson()));
  Application.router.navigateTo(context, '${Routes.petAdoptDetails}?adopt=$encodeAdopt');
}
