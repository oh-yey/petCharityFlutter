import 'dart:math';

import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:pet_charity/view/utils/svg_picture_color.dart';

// 自定义键盘
class MyKeyboardView extends StatefulWidget {
  final Function(int) callback;
  final bool upset;
  final bool isShowHide;
  final GestureTapCallback? onTopHide;

  const MyKeyboardView({
    Key? key,
    required this.callback,
    this.upset = false,
    this.isShowHide = false,
    this.onTopHide,
  }) : super(key: key);

  @override
  State<MyKeyboardView> createState() => _MyKeyboardViewState();
}

class _MyKeyboardViewState extends State<MyKeyboardView> {
  void onNum(int num) => widget.callback(num);

  void onDeleteChange() => widget.callback(127);

  void onCommitChange() => widget.callback(13);

  List<int> list = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];

  @override
  void initState() {
    if (widget.upset) {
      int m = list.length - 1;
      // 打乱顺序
      Random random = Random();
      while (m >= 0) {
        int index = random.nextInt(list.length);
        int t = list[index];
        list[index] = list[m];
        list[m--] = t;
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        width: 1290.w,
        height: 750.h,
        color: Theme.of(context).dialogBackgroundColor,
        child: Column(
          children: <Widget>[
            widget.isShowHide
                ? InkWell(
                    onTap: widget.onTopHide,
                    child: Ink(
                      height: 75.h,
                      child: Text(
                        '点击隐藏',
                        style: TextStyle(fontSize: 40.sp, color: Colors.red),
                      ),
                    ),
                  )
                : SizedBox(height: 75.h),
            //  键盘主体
            Column(
              children: <Widget>[
                //  第一行
                Row(children: list.sublist(1, 4).map((e) => KeyboardWidget(text: '$e', onTap: () => onNum(e))).toList()),
                //  第二行
                Row(children: list.sublist(4, 7).map((e) => KeyboardWidget(text: '$e', onTap: () => onNum(e))).toList()),
                //  第三行
                Row(children: list.sublist(7, 10).map((e) => KeyboardWidget(text: '$e', onTap: () => onNum(e))).toList()),
                //  第四行
                Row(
                  children: <Widget>[
                    KeyboardWidget(icon: 'assets/keyboard/cross.svg', onTap: () => onDeleteChange()),
                    KeyboardWidget(text: '${list[0]}', onTap: () => onNum(list[0])),
                    KeyboardWidget(icon: 'assets/keyboard/ok.svg', onTap: () => onCommitChange()),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class KeyboardWidget extends StatelessWidget {
  final String? text;
  final String? icon;

  final VoidCallback onTap;

  const KeyboardWidget({Key? key, required this.onTap, this.text, this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
        height: 150.h,
        child: OutlinedButton(
          onPressed: onTap,
          child: text != null
              ? Text(text!, style: TextStyle(fontSize: 64.sp, color: Theme.of(context).textTheme.titleMedium?.color))
              : icon != null
                  ? SvgPicture.asset(
                      icon!,
                      colorFilter: SvgPictureColor.color(Theme.of(context).textTheme.titleMedium?.color),
                      width: 96.w,
                    )
                  : const Placeholder(),
        ),
      ),
    );
  }
}
