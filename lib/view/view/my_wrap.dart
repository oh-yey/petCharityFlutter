import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:pet_charity/view/utils/dark.dart';

class MyWrap extends StatelessWidget {
  final String title;
  final Color? textColor;
  final Color? bgColor;

  const MyWrap(this.title, {this.textColor, this.bgColor, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        color: isDark(context) ? Theme.of(context).dialogBackgroundColor : bgColor ?? Theme.of(context).dialogBackgroundColor,
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 32.sp,
          color: isDark(context)
              ? Theme.of(context).textTheme.titleMedium?.color?.withOpacity(0.625)
              : textColor ?? Theme.of(context).textTheme.titleMedium?.color?.withOpacity(0.625),
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }
}
