import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:pet_charity/models/donate/donate.dart';

import 'package:pet_charity/routers/application.dart';
import 'package:pet_charity/routers/routes.dart';

import 'package:pet_charity/tools/extension/extension_num.dart';

import 'package:pet_charity/view/utils/dark.dart';
import 'package:pet_charity/view/view/image/clip_image.dart';
import 'package:pet_charity/view/view/my_scaffold.dart';

class DonateHelpDonationLeaderboardPage extends StatefulWidget {
  final List<Donate> donationList;

  const DonateHelpDonationLeaderboardPage(this.donationList, {Key? key}) : super(key: key);

  @override
  State<DonateHelpDonationLeaderboardPage> createState() => _DonateHelpDonationLeaderboardPageState();
}

class _DonateHelpDonationLeaderboardPageState extends State<DonateHelpDonationLeaderboardPage> {
  @override
  Widget build(BuildContext context) => MyScaffold(title: '捐赠榜', body: _buildListView());

  Widget _buildListView() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 32.h, horizontal: 48.w),
      itemBuilder: (_, index) {
        Donate donate = widget.donationList[index];
        return _buildListItemView(index, donate);
      },
      itemCount: widget.donationList.length,
    );
  }

  Widget _buildListItemView(int index, Donate donate) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 12.h),
      color: _getBGColor(index),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 48.w, vertical: 32.h),
        child: Row(
          children: [
            _buildIndex(index),
            SizedBox(width: 32.w),
            ClipImage(donate.user?.head ?? '', size: 128.w),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 32.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(donate.user?.nickname ?? '', style: TextStyle(fontSize: 58.sp, color: _getColor(index)), maxLines: 1, overflow: TextOverflow.ellipsis),
                    Text(
                      donate.user?.introduction ?? '',
                      style: TextStyle(fontSize: 36.sp, color: _getColor(index)?.withOpacity(0.75)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            Text(donate.amount?.moneySymbol ?? '', style: TextStyle(color: _getColor(index))),
            SizedBox(width: 32.w),
          ],
        ),
      ),
    );
  }

  Widget _buildIndex(int index) {
    if (index < 3) {
      return Stack(
        children: [
          SvgPicture.asset(
            'assets/donate/奖牌.svg',
            width: 128.w,
            height: 128.h,
            colorFilter: ColorFilter.mode(_getSvgColor(index), BlendMode.srcIn),
            // color:
          ),
          Container(
            padding: EdgeInsets.only(bottom: 10.h),
            width: 128.w,
            height: 118.h,
            child: Center(child: Text('${index + 1}', style: TextStyle(fontSize: 58.sp, color: _getColor(index)))),
          ),
        ],
      );
    } else {
      return SizedBox(
        width: 128.w,
        height: 128.h,
        child: Center(child: Text('${index + 1}', style: TextStyle(fontSize: 72.sp, color: _getColor(index)))),
      );
    }
  }

  Color? _getBGColor(int index) {
    Color? color;
    switch (index) {
      case 0:
        color = const Color(0xFFFE6E75);
        break;
      case 1:
        color = const Color(0xFFFFC647);
        break;
      case 2:
        color = const Color(0xFF6FBDFF);
        break;
    }
    if (isDark(context)) {
      return color?.withOpacity(0.375);
    }
    return color;
  }

  Color? _getColor(int index) => index < 3 ? Colors.white : Theme.of(context).textTheme.titleMedium?.color;

  Color _getSvgColor(int index) {
    Color color = Theme.of(context).cardColor;
    switch (index) {
      case 0:
        color = const Color(0xFFFFCC45);
        break;
      case 1:
        color = const Color(0xFFD9D9D9);
        break;
      case 2:
        color = const Color(0xFFEFB048);
        break;
    }
    return color.withOpacity(isDark(context) ? 0.75 : 1);
  }
}

void gotoPetDonateHelpDonationLeaderboard(BuildContext context, List<Donate>? donationList) {
  String encodeDonate = Uri.encodeComponent(jsonEncode(donationList?.map((item) => item.toJson()).toList()));
  Application.router.navigateTo(context, '${Routes.petDonateHelpDonationLeaderboard}?donationList=$encodeDonate');
}
