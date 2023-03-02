import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:pet_charity/models/donate/pet_donate.dart';

import 'package:pet_charity/routers/application.dart';
import 'package:pet_charity/routers/routes.dart';

import 'package:pet_charity/view/donate/donate_help_donation_play_page.dart';
import 'package:pet_charity/view/utils/extension/extension_state.dart';
import 'package:pet_charity/view/view/my_scaffold.dart';
import 'package:pet_charity/view/view/my_keyboard_view.dart';

class DonateHelpDonationPage extends StatefulWidget {
  final PetDonate donate;

  const DonateHelpDonationPage(this.donate, {Key? key}) : super(key: key);

  @override
  State<DonateHelpDonationPage> createState() => _DonateHelpDonationPageState();
}

class _DonateHelpDonationPageState extends State<DonateHelpDonationPage> {
  num maxMoney = 0;

  num _money = 0;
  bool _isShowKeyboard = false;

  @override
  void initState() {
    super.initState();
    maxMoney = (widget.donate.amount ?? 0) - (widget.donate.alreadyAmount ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      title: '捐赠',
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 48.w, vertical: 32.h),
            child: _buildDonationCard(),
          ),
          const Spacer(),
          if (_isShowKeyboard)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 48.w),
              child: _buildKeyboard(),
            ),
        ],
      ),
    );
  }

  Card _buildDonationCard() {
    return Card(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 36.h),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(height: 50.h, child: VerticalDivider(color: Theme.of(context).primaryColor, width: 32.w, thickness: 2)),
                const Text('捐赠金额'),
              ],
            ),
            GridView(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(vertical: 72.h),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 4,
              ),
              children: [
                _moneyButton(5),
                _moneyButton(20),
                _moneyButton(100),
                _customizationMoneyButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _moneyButton(int money) {
    return TextButton(
      style: _customizationButtonStyleButton(),
      onPressed: maxMoney >= money ? () => _finish(money) : null,
      child: Text('$money元'),
    );
  }

  Widget _customizationMoneyButton() {
    return TextButton(
      style: _customizationButtonStyleButton(),
      onPressed: showKeyboard,
      child: _money == 0 ? Text('输入金额', style: TextStyle(color: Theme.of(context).primaryColor.withOpacity(0.5))) : Text('$_money元'),
    );
  }

  ButtonStyle _customizationButtonStyleButton() {
    return TextButton.styleFrom(
      side: BorderSide(width: 1.w, color: Theme.of(context).hintColor),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
    );
  }

  Widget _buildKeyboard() {
    return MyKeyboardView(
      callback: (int num) {
        if (num == 127) {
          // 删除
          if (_money != 0) {
            _money = _money ~/ 10;
          }
        } else if (num == 13) {
          //
          if (_money > 0) {
            _finish(_money);
          } else {
            BotToast.showText(text: '请输入金额！');
          }
        } else {
          _money = _money * 10 + num;
          if (_money > maxMoney) {
            _money = maxMoney;
          }
        }
        mySetState(() {});
      },
    );
  }

  void showKeyboard() {
    if (!_isShowKeyboard) {
      _isShowKeyboard = true;
      mySetState(() {});
    }
  }

  void _finish(num money) async {
    int? code = await gotoDonateHelpDonationPlayPage(context, widget.donate, money);
    if (code == 200) {
      if (!mounted) return;
      Navigator.pop(context, money);
    }
  }
}

Future<int?> gotoDonateHelpDonation(BuildContext context, PetDonate donate) async {
  String encodeDonate = Uri.encodeComponent(jsonEncode(donate.toJson()));
  return await Application.router.navigateTo(context, '${Routes.petDonateHelpDonation}?donate=$encodeDonate');
}
