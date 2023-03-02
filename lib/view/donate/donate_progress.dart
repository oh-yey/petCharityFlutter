import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:pet_charity/view/view/my_progress.dart';

class DonateProgress extends StatelessWidget {
  // 目标金额
  final num amount;

  // 已筹金额
  final num alreadyAmount;

  // 众筹人数
  final num playCount;

  const DonateProgress(this.amount, this.alreadyAmount, this.playCount, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 24.h),
      child: Row(
        children: <Widget>[
          myWidget1(context, '$alreadyAmount', '已筹金额'),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 35.w, vertical: 4.h),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 24.h),
                  MyLiquidLinearProgressIndicator(alreadyAmount, amount),
                  SizedBox(height: 16.h),
                  Text('已有$playCount人捐款', style: TextStyle(fontSize: 24.sp)),
                ],
              ),
            ),
          ),
          myWidget1(context, '$amount', '目标金额'),
        ],
      ),
    );
  }

  // 金额 小部件
  Widget myWidget1(context, String number, String text) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(number, style: TextStyle(fontSize: 32.sp, color: Theme.of(context).hintColor)),
        SizedBox(height: 8.h),
        Text(text, style: TextStyle(fontSize: 28.sp, color: Theme.of(context).hintColor)),
      ],
    );
  }
}

// 进度条 动画
class MyLiquidLinearProgressIndicator extends StatelessWidget {
  final num alreadyAmount;
  final num amount;

  const MyLiquidLinearProgressIndicator(this.alreadyAmount, this.amount, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: alreadyAmount.toDouble()),
      duration: const Duration(milliseconds: 2000),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return MyProgress(
          total: amount,
          cur: value,
          height: 20.h,
          roundedEdges: const Radius.circular(10),
          selectedGradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF66BB6A), Color(0xFF2ABE5C)],
          ),
          unselectedGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Theme.of(context).dividerColor.withOpacity(0.2), Theme.of(context).dividerColor.withOpacity(0.3)],
          ),
        );
      },
    );
  }
}
