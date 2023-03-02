import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:pet_charity/view/utils/dark.dart';

class MyOkButton extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  final Color? bgColor;
  final Color? titleColor;

  const MyOkButton(this.title, {required this.onTap, this.titleColor, this.bgColor, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 48.w, right: 48.w, bottom: 48.h),
      child: TextButton(
        style: TextButton.styleFrom(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
          backgroundColor: bgColor ?? Theme.of(context).colorScheme.primaryContainer,
        ),
        onPressed: onTap,
        child: Center(
          child: Text(
            title,
            style: TextStyle(fontSize: 96.sp, color: titleColor ?? Colors.white.withOpacity(isDark(context) ? 0.5 : 1)),
          ),
        ),
      ),
    );
  }
}
