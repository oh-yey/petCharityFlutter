import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:pet_charity/states/user.dart';

import 'package:pet_charity/models/public/detail.dart';
import 'package:pet_charity/models/user/followers_list.dart';
import 'package:pet_charity/models/user/user.dart';

import 'package:pet_charity/service/user_server.dart' as user_service;

import 'package:pet_charity/routers/application.dart';
import 'package:pet_charity/routers/routes.dart';

import 'package:pet_charity/view/utils/extension/extension_state.dart';
import 'package:pet_charity/view/view/my_scaffold.dart';
import 'package:pet_charity/view/view/image/clip_image.dart';

class AdoptDetailsContactPage extends StatefulWidget {
  final User user;

  const AdoptDetailsContactPage(this.user, {Key? key}) : super(key: key);

  @override
  State<AdoptDetailsContactPage> createState() => _AdoptDetailsContactPageState();
}

class _AdoptDetailsContactPageState extends State<AdoptDetailsContactPage> {
  User? user;
  bool _isFocus = false;

  @override
  void initState() {
    user = widget.user;
    _init();
    super.initState();
  }

  void _init() async {
    User? my = context.read<UserModel>().user;
    FollowersList? followersList = await user_service.followersList(followers: my?.id, following: user?.id);
    if (followersList?.count == 1) {
      _isFocus = true;
      mySetState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      title: '联系方式',
      body: Column(
        children: [
          _buildUserCard(),
          SizedBox(height: 24.h),
          _buildMessageItem('手机号：', user?.contact?.phone ?? '', _onTapPhone),
          _buildMessageItem('邮箱：', user?.contact?.mail ?? '', _onTapMail),
          _buildMessageItem('QQ：', user?.contact?.qq ?? '', _onTapQQ),
          _buildMessageItem('微信：', user?.contact?.wechat ?? '', _onTapWechat),
        ],
      ),
    );
  }

  Widget _buildUserCard() {
    return Card(
      color: Colors.transparent,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 32.h, horizontal: 32.w),
        child: Row(
          children: [
            ClipImage(user?.head ?? '', size: 172.w),
            SizedBox(width: 32.w),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user?.nickname ?? '--', style: TextStyle(fontSize: 72.sp, fontWeight: FontWeight.w700)),
                  Text(user?.introduction ?? '--', style: TextStyle(fontSize: 48.sp, color: Theme.of(context).textTheme.titleMedium?.color?.withOpacity(0.5))),
                ],
              ),
            ),
            SizedBox(width: 32.w),
            InkWell(
              borderRadius: BorderRadius.circular(32.w),
              onTap: _focus,
              child: Ink(
                padding: EdgeInsets.symmetric(horizontal: 58.w, vertical: 16.h),
                decoration: BoxDecoration(
                  color: _isFocus ? null : Colors.pink,
                  borderRadius: BorderRadius.circular(32.w),
                  border: _isFocus ? Border.all(width: 1, color: Theme.of(context).dividerColor) : null,
                ),
                child: Container(
                  alignment: Alignment.center,
                  width: 120.w,
                  child: Text(
                    _isFocus ? '已关注' : '关注',
                    style: TextStyle(color: _isFocus ? Theme.of(context).textTheme.titleMedium?.color?.withOpacity(0.5) : Colors.white, fontSize: 36.sp),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding _buildMessageItem(String title, String message, GestureTapCallback onTap) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 24.h),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: TextStyle(fontSize: 64.sp)),
              InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(8.w),
                child: Ink(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                  child: Text(message, style: TextStyle(fontSize: 64.sp)),
                ),
              ),
            ],
          ),
          Divider(thickness: 1.h)
        ],
      ),
    );
  }

  void _onTapPhone() async {
    final Uri uri = Uri(
      scheme: 'tel',
      path: user?.contact?.phone ?? '',
    );
    if (await launchUrl(uri)) {
      await launchUrl(uri);
    } else {
      debugPrint('launchUrl 错误');
    }
  }

  void _onTapMail() async {
    final Uri uri = Uri(
      scheme: 'mailto',
      path: user?.contact?.mail ?? '',
    );
    if (await launchUrl(uri)) {
      await launchUrl(uri);
    } else {
      debugPrint('launchUrl 错误');
    }
  }

  void _onTapQQ() async {
    final Uri uri = Uri(
      scheme: 'mqq',
      path: user?.contact?.qq ?? '',
    );
    if (await launchUrl(uri)) {
      await launchUrl(uri);
    } else {
      debugPrint('launchUrl 错误');
    }
  }

  void _onTapWechat() async {
    final Uri uri = Uri(
      scheme: 'sinavdisk',
      path: user?.contact?.wechat ?? '',
    );
    if (await launchUrl(uri)) {
      await launchUrl(uri);
    } else {
      debugPrint('launchUrl 错误');
    }
  }

  void _focus() async {
    Detail code = await user_service.following(user?.id ?? 0, _isFocus);
    if (code.code == 200) {
      _isFocus = !_isFocus;
      if (_isFocus) {
        BotToast.showText(text: '关注成功');
      } else {
        BotToast.showText(text: '取消关注成功');
      }
    } else {
      BotToast.showText(text: '关注失败');
    }
    mySetState(() {});
  }
}

void gotoAdoptDetailsContact(BuildContext context, User user) {
  String encode = Uri.encodeComponent(jsonEncode(user.toJson()));
  Application.router.navigateTo(context, '${Routes.petAdoptDetailsContact}?user=$encode');
}
