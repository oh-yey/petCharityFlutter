import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:pet_charity/models/donate/donate.dart';
import 'package:pet_charity/models/donate/pet_donate.dart';

import 'package:pet_charity/view/donate/donate_progress.dart';
import 'package:pet_charity/view/view/image/clip_image.dart';
import 'package:pet_charity/view/view/my_wrap.dart';

class DonateCard extends StatelessWidget {
  final PetDonate donate;
  final GestureTapCallback gotoDetails;
  final GestureTapCallback gotoTopList;
  late final bool shouldShowDonate;

  DonateCard(this.donate, this.gotoDetails, this.gotoTopList, {Key? key}) : super(key: key) {
    shouldShowDonate = donate.donationList?.isNotEmpty == true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      child: Card(
        child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          onTap: gotoDetails,
          child: Ink(
            padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 24.h),
            child: Column(
              children: <Widget>[
                _buildHead(donate, context),
                _buildDescription(donate),
                DonateProgress(
                  donate.amount ?? 0,
                  donate.alreadyAmount ?? 0,
                  donate.alreadyPeopleCount ?? 0,
                ),
                shouldShowDonate ? _buildEnd(donate.donationList) : SizedBox(height: 32.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 头像部分
  Widget _buildHead(PetDonate donate, BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 12.h),
      child: Row(
        children: <Widget>[
          ClipImage(donate.coverImage?.image ?? '', size: 128.w, tag: donate.coverImage?.image),
          SizedBox(width: 24.w),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 12.w),
                    child: Text(
                      donate.name ?? '',
                      style: TextStyle(fontSize: 44.sp, fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Wrap(
                    spacing: 24.w,
                    children: [
                      MyWrap(donate.breed?.name ?? ''),
                      MyWrap(donate.breed?.variety ?? ''),
                    ],
                  ),
                ],
              ),
            ),
          ),
          _buildPlatformSupervision(context),
        ],
      ),
    );
  }

  /// 平台监管
  Container _buildPlatformSupervision(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
        color: Theme.of(context).colorScheme.primaryContainer,
      ),
      transform: Matrix4.translationValues(32.w, 0, 0),
      child: Text('平台监管', style: TextStyle(fontSize: 32.sp)),
    );
  }

  /// 详情
  Widget _buildDescription(PetDonate donate) {
    return Padding(
      padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 16.h, bottom: 32.h),
      child: Text(
        donate.description ?? '',
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
        style: TextStyle(fontSize: 42.sp),
      ),
    );
  }

  /// 捐赠榜
  Widget _buildEnd(List<Donate>? donationList) {
    return Container(
      padding: EdgeInsets.only(right: 12.w, bottom: 32.h, top: 16.h),
      child: Row(
        children: <Widget>[
          const Text('爱心捐赠榜:  '),
          Expanded(
            child: Row(
              children: donationList
                      ?.sublist(0, donationList.length > 3 ? 3 : donationList.length)
                      .map(
                        (donate) => Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          child: ClipImage(donate.user?.head ?? '', size: 64.w),
                        ),
                      )
                      .toList() ??
                  [],
            ),
          ),
          InkWell(
            borderRadius: BorderRadius.circular(16.w),
            onTap: gotoTopList,
            child: Ink(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.w),
                border: Border.all(width: 1.w),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 8.h),
                child: Text('了解一下', style: TextStyle(fontSize: 36.sp)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
