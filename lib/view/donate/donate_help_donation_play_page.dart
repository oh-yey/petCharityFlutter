import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:pet_charity/states/user.dart';

import 'package:pet_charity/models/donate/pet_donate.dart';
import 'package:pet_charity/models/public/detail.dart';
import 'package:pet_charity/models/user/user.dart';

import 'package:pet_charity/service/donate_server.dart' as donate_server;

import 'package:pet_charity/routers/application.dart';
import 'package:pet_charity/routers/routes.dart';

import 'package:pet_charity/tools/extension/extension_num.dart';

import 'package:pet_charity/view/donate/donate_help_donation_play_box.dart';
import 'package:pet_charity/view/view/button/my_ok_button.dart';
import 'package:pet_charity/view/view/my_scaffold.dart';

class DonateHelpDonationPlayPage extends StatefulWidget {
  final PetDonate donate;
  final num money;

  const DonateHelpDonationPlayPage(this.donate, this.money, {Key? key}) : super(key: key);

  @override
  State<DonateHelpDonationPlayPage> createState() => _DonateHelpDonationPlayPageState();
}

class _DonateHelpDonationPlayPageState extends State<DonateHelpDonationPlayPage> {
  @override
  Widget build(BuildContext context) => MyScaffold(title: '支付', body: _buildMessage());

  Widget _buildMessage() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 48.w, right: 48.w, top: 48.h, bottom: 16.h),
          child: const Text('爱心捐赠'),
        ),
        Padding(
          padding: EdgeInsets.only(left: 48.w, right: 48.w, bottom: 32.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 24.sp),
                child: Text('￥', style: TextStyle(fontSize: 64.sp)),
              ),
              Text(widget.money.money, style: TextStyle(fontSize: 128.sp)),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 48.w, vertical: 32.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('订单信息'),
              Expanded(
                child: Text(
                  '爱心捐赠(${widget.donate.name})',
                  textAlign: TextAlign.end,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        Divider(indent: 48.w, endIndent: 28.w, thickness: 1.w),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 48.w, vertical: 32.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [Text('交易方式'), Text('余额')],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 32.h),
          child: Card(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                    color: Theme.of(context).colorScheme.primaryContainer,
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(left: 48.w, top: 32.h, bottom: 24.h),
                    child: const Text('支付工具'),
                  ),
                ),
                ListTile(
                  leading: SvgPicture.asset('assets/public/余额.svg', width: 96.w),
                  title: const Text('账号余额'),
                  subtitle: _buildBalance(),
                ),
              ],
            ),
          ),
        ),
        const Spacer(),
        MyOkButton('确认交易', onTap: play),
      ],
    );
  }

  Consumer<UserModel> _buildBalance() {
    return Consumer<UserModel>(
      builder: (context, UserModel userModel, _) {
        double balance = userModel.user?.balance ?? 0;
        if (shouldPay()) {
          return Text('可用：${balance.moneySymbol}');
        } else {
          return Text('余额不足，剩余：${balance.moneySymbol}');
        }
      },
    );
  }

  bool shouldPay() {
    User? user = Provider.of<UserModel>(context, listen: false).user;
    double balance = user?.balance ?? 0;
    return balance >= widget.money;
  }

  void play() {
    if (shouldPay()) {
      _finish();
    } else {
      BotToast.showText(text: '余额不足');
    }
  }

  void _finish() async {
    String? password = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => const LoadingDialog(),
    );
    if (password != null) {
      Detail? detail = await donate_server.userDonate(widget.donate.id ?? 0, widget.money, password);
      switch (detail?.code) {
        case 200:
          BotToast.showText(text: '捐赠成功 感谢您的捐赠！');
          if (!mounted) return;
          Navigator.pop(context, 200);
          break;
        case 1602:
          // 支付密码错误
          BotToast.showText(text: '支付密码错误');
          break;
        case 1603:
          // 众筹当前未在进行中
          BotToast.showText(text: '众筹当前未在进行中');
          break;
        case 1604:
          // 捐赠金额小于0或者大于剩余捐赠金额
          BotToast.showText(text: '捐赠金额问题 小于0 或者大于剩余捐赠金额');
          break;
        case 1605:
          // 余额不足
          BotToast.showText(text: '余额不足');
          break;
        default:
          BotToast.showText(text: '未知错误${detail?.code}');
      }
    }
  }
}

class LoadingDialog extends Dialog {
  const LoadingDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Material(
      type: MaterialType.transparency,
      child: DonateHelpDonationPlayBox(),
    );
  }
}

Future<int?> gotoDonateHelpDonationPlayPage(BuildContext context, PetDonate donate, num money) async {
  String encodeDonate = Uri.encodeComponent(jsonEncode(donate.toJson()));
  return await Application.router.navigateTo(context, '${Routes.petDonateHelpDonationPlay}?donate=$encodeDonate&money=$money');
}
