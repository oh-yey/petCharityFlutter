import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:pet_charity/models/other/statistics_result.dart';

class HomeDataShowView extends StatelessWidget {
  const HomeDataShowView(this.statisticsResult, {Key? key}) : super(key: key);

  final StatisticsResult? statisticsResult;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      width: 1290.w,
      height: 550.h,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              children: <Widget>[
                _left('众筹宝贝', statisticsResult?.data?.donateCount ?? 0, 'assets/home/helpPet.svg', onTap: () {
                  //gotoPetHelpList(context)
                }),
                _left('注册用户数', statisticsResult?.data?.userCount ?? 0, 'assets/home/smilingFace.svg'),
              ],
            ),
          ),
          _right(),
        ],
      ),
    );
  }

  Widget _left(String title, num number, String svg, {GestureTapCallback? onTap}) {
    return Expanded(
      child: Card(
        child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          onTap: onTap,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('$number', style: TextStyle(fontSize: 48.sp)),
                    SizedBox(height: 12.h),
                    Text(title, style: TextStyle(fontSize: 40.sp)),
                  ],
                ),
              ),
              SizedBox(width: 16.w),
              SvgPicture.asset(svg, height: 160.h),
              SizedBox(width: 48.w),
            ],
          ),
        ),
      ),
    );
  }

  Widget _right() {
    return Expanded(
      child: Card(
        child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          onTap: () {},
          child: Stack(
            children: [
              Positioned(
                right: 48.w,
                bottom: 24.h,
                child: SvgPicture.asset('assets/home/box.svg', height: 260.h),
              ),
              Positioned(
                left: 48.w,
                top: 32.h,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${statisticsResult?.data?.donateAmount ?? 0}', style: TextStyle(fontSize: 48.sp)),
                    SizedBox(height: 12.h),
                    Text('众筹金额\n爱心捐粮和公益费用累计', style: TextStyle(fontSize: 42.sp)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
