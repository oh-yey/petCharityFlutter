import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:pet_charity/states/user.dart';

import 'package:pet_charity/models/user/user.dart';

import 'package:pet_charity/view/utils/svg_picture_color.dart';

class HomeSearchView extends StatelessWidget {
  final void Function() onTapSearch;

  const HomeSearchView(this.onTapSearch, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Theme.of(context).dialogBackgroundColor,
          width: 1290.w,
          height: 400.h,
        ),
        SafeArea(
          bottom: false,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 32.h),
            child: Row(
              children: <Widget>[
                SizedBox(width: 24.w),
                _buildAddress(),
                SizedBox(width: 32.w),
                Expanded(
                  child: InkWell(
                    onTap: onTapSearch,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(12)),
                        color: Theme.of(context).dividerColor.withOpacity(0.15),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SvgPicture.asset('assets/home/搜索.svg',
                              height: 48.w, colorFilter: SvgPictureColor.color(Theme.of(context).textTheme.titleMedium?.color)),
                          SizedBox(width: 24.w),
                          Text('搜索', style: TextStyle(fontSize: 48.sp)),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 64.w),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Consumer<UserModel> _buildAddress() {
    return Consumer<UserModel>(
      builder: (context, UserModel userModel, _) {
        User? user = userModel.user;
        return InkWell(
          borderRadius: BorderRadius.circular(12.w),
          onTap: () {
            debugPrint('${user?.area?.id}');
          },
          child: Ink(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
            child: Row(
              children: [
                SvgPicture.asset('assets/home/位置.svg', height: 64.h, colorFilter: SvgPictureColor.color(Theme.of(context).textTheme.titleMedium?.color)),
                SizedBox(width: 12.w),
                Text(user?.area?.belongCity?.city ?? '岳阳市', style: TextStyle(fontSize: 40.sp)),
              ],
            ),
          ),
        );
      },
    );
  }
}
