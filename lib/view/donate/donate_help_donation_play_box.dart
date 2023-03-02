import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:pet_charity/view/donate/donate_help_donation_play_password_input_box.dart';
import 'package:pet_charity/view/utils/extension/extension_state.dart';
import 'package:pet_charity/view/view/my_keyboard_view.dart';

class DonateHelpDonationPlayBox extends StatefulWidget {
  const DonateHelpDonationPlayBox({Key? key}) : super(key: key);

  @override
  State<DonateHelpDonationPlayBox> createState() => _DonateHelpDonationPlayBoxState();
}

class _DonateHelpDonationPlayBoxState extends State<DonateHelpDonationPlayBox> {
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(flex: 4),
        SizedBox(
          width: 1024.w,
          height: 768.h,
          child: Card(
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
            child: Container(
              padding: EdgeInsets.all(64.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Ink(child: const Icon(CupertinoIcons.clear_thick, size: 24, color: Colors.grey)),
                  ),
                  const Spacer(flex: 1),
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: 32.h),
                    child: Text('请输入支付密码', style: TextStyle(fontSize: 72.sp, fontWeight: FontWeight.w900)),
                  ),
                  const Spacer(flex: 12),
                  Expanded(
                    flex: 16,
                    child: SizedBox(
                      width: double.infinity,
                      child: DonateHelpDonationPlayPasswordInputBox(password.length),
                    ),
                  ),
                  const Spacer(flex: 20),
                ],
              ),
            ),
          ),
        ),
        const Spacer(flex: 3),
        MyKeyboardView(callback: onButton, upset: true),
      ],
    );
  }

  void onButton(int num) {
    switch (num) {
      // 提交
      case 13:
        if (password.length == 6) {
          Navigator.pop(context, password);
        } else {
          BotToast.showText(text: '请输入正确的支付密码');
        }
        break;
      // 删除
      case 127:
        if (password.isNotEmpty) {
          mySetState(() {
            password = password.substring(0, password.length - 1);
          });
        }
        break;
      // 其他数字
      default:
        if (password.length < 6) {
          mySetState(() {
            password = '$password$num';
          });
          if (password.length == 6) {
            Navigator.pop(context, password);
          }
        }
    }
  }
}
